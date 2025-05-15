//
//  AudioPlayerFeature.swift
//  AudioBook
//
//  Created by Anna on 5/13/25.
//

import Foundation
import ComposableArchitecture
import AVFoundation

public struct AudioPlayerFeature: Reducer {
    
    private let environment: AudioPlayerEnvironment = .init(
        audioPlayerService: AudioPlayerService(chapter: Chapter(id: UUID(), title: "", fileName: "", fileExtension: "mp3"))
    )
    
    public struct State: Equatable {
        
//        static var current: AudioPlayerFeature.State {
//            appStore.audioPlayerState
//        }
        
        var isPlaying = false
        var currentTime: TimeInterval = 0
        var duration: TimeInterval = 0
        var rate: Float = 1
    }
    
    @CasePathable
    public enum Action: Equatable {
        case onAppear
        case playPauseTapped
        case updateTime(TimeInterval)
        case forwardTapped
        case backwardTapped
        case nextTapped(Chapter?)
        case previousTapped(Chapter?)
        case audioFinished
        case changeRate(Float)
    }
    
    public func reduce(into state: inout AudioPlayerFeature.State, action: AudioPlayerFeature.Action) -> Effect<AudioPlayerFeature.Action> {
        switch action {
        case .onAppear:
            state.duration = environment.audioPlayerService.duration()
            return .run { send in
                for await time in environment.audioPlayerService.timerPublisher() {
                    await send(.updateTime(time))
                }
            }
            
        case let .updateTime(time):
            state.currentTime = time
            return .none
            
        case .playPauseTapped:
            state.isPlaying.toggle()
            let isPlaying = state.isPlaying
            return .run { _ in
                if isPlaying {
                    environment.audioPlayerService.play()
                } else {
                    environment.audioPlayerService.pause()
                }
            }
            
        case .forwardTapped:
            environment.audioPlayerService.seek(by: 10)
            return .none
            
        case .backwardTapped:
            environment.audioPlayerService.seek(by: -5)
            return .none
            
        case .audioFinished:
            state.isPlaying = false
            return .none
            
        case .nextTapped(let chapter):
            if let chapter {
                environment.audioPlayerService.switchToChapter(chapter)
                state.isPlaying = true
            }
            return .none
            
        case .previousTapped(let chapter):
            if let chapter {
                environment.audioPlayerService.switchToChapter(chapter)
                state.isPlaying = true
            }
            return .none
            
        case let .changeRate(rate):
            environment.audioPlayerService.setRate(rate: rate)
            state.rate = rate
            return .none
        }
    }
}

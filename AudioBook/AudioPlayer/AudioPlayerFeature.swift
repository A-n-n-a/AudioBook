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
        audioPlayerService: AudioPlayerService(fileName: "Guide Dog at Work")
    )
    
    public struct State: Equatable {
        var isPlaying = false
        var currentTime: TimeInterval = 0
        var duration: TimeInterval = 0
    }

    @CasePathable
    public enum Action: Equatable {
        case onAppear
        case playPauseTapped
        case updateTime(TimeInterval)
        case forwardTapped
        case backwardTapped
        case nextTapped
        case previousTapped
        case audioFinished
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
            
        case .nextTapped:
            //TODO: switch to next chapter
            return .none
            
        case .previousTapped:
            //TODO: switch to the previous chapter
            return .none
        }
    }
}

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
        audioPlayerService: AudioPlayerService()
    )
    
    public struct State: Equatable {
        
        var isPlaying = false
        var currentTime: TimeInterval = 0
        var duration: TimeInterval = 0
        var rate: Float = 1
        var currentBook: Book?
        var currentChapter: Chapter?
        
        var numberOfChapters: Int {
            return currentBook?.chapters.count ?? 0
        }
        
        var chapterNumber: Int {
            return (currentBook?.chapters.firstIndex(where: { $0.id ==  currentChapter?.id}) ?? 0) + 1
        }
    }
    
    @CasePathable
    public enum Action: Equatable {
        case onAppear
        case setFirstBookToPlayer(Book?)
        case playPauseTapped
        case updateTime(TimeInterval)
        case forwardTapped
        case backwardTapped
        case nextTapped(Chapter?)
        case previousTapped(Chapter?)
        case changeRate(Float)
        case updateBookData(Book?)
        case rewindToTime(TimeInterval)
    }
    
    public func reduce(into state: inout AudioPlayerFeature.State, action: AudioPlayerFeature.Action) -> Effect<AudioPlayerFeature.Action> {
        switch action {
        case .onAppear:
            return setupAudioPlayerDuration(state: &state, environment: environment)
            
        case .setFirstBookToPlayer(let book):
            state.currentBook = book
            if let chapter = book?.chapters.first {
                environment.audioPlayerService.switchToChapter(chapter, play: false)
                state.currentChapter = chapter
            }
            return .none
            
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
            
        case .nextTapped(let chapter):
            if let chapter {
                environment.audioPlayerService.switchToChapter(chapter, play: true)
                state.currentChapter = chapter
                state.isPlaying = true
                return setupAudioPlayerDuration(state: &state, environment: environment)
            }
            return .none
            
        case .previousTapped(let chapter):
            if let chapter {
                environment.audioPlayerService.switchToChapter(chapter, play: true)
                state.currentChapter = chapter
                state.isPlaying = true
                return setupAudioPlayerDuration(state: &state, environment: environment)
            }
            return .none
            
        case let .changeRate(rate):
            environment.audioPlayerService.setRate(rate: rate)
            state.rate = rate
            return .none
            
        case .updateBookData(let book):
            state.currentBook = book
            return .none
            
        case .rewindToTime(let time):
            state.currentTime = time
            environment.audioPlayerService.rewind(to: time)
            return .none
        }
    }
    
    private func setupAudioPlayerDuration(state: inout AudioPlayerFeature.State, environment: AudioPlayerEnvironment) -> Effect<AudioPlayerFeature.Action> {
        state.duration = environment.audioPlayerService.duration()
        
        return .run { send in
            for await time in environment.audioPlayerService.timerPublisher() {
                await send(.updateTime(time))
            }
        }
    }
}

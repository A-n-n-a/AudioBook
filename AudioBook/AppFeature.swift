//
//  AppFeature.swift
//  AudioBook
//
//  Created by Anna on 5/13/25.
//

import ComposableArchitecture

public struct AppFeature: Reducer {
    
    private let audioPlayerFeature = AudioPlayerFeature()
    private let libraryFeature = LibraryFeature()
    
    //MARK: - State
    public struct State: Equatable {
        public enum Route: Hashable {
            case details
        }
//TODO: check path
        var path: [Route] = []
        var libraryState: LibraryFeature.State
        var audioPlayerState: AudioPlayerFeature.State
        var detailsState: DetailsFeature.State

        static let initial: Self = .init(
            libraryState: LibraryFeature.State(),
            audioPlayerState: AudioPlayerFeature.State(),
            detailsState: DetailsFeature.State(text: "Lorem Ipsum...")
        )
    }

    //MARK: - Action
    @CasePathable
    public enum Action: Equatable {
        case library(LibraryFeature.Action)
        case player(AudioPlayerFeature.Action)
        case details(DetailsFeature.Action)
        case nextChapterTapped
        case previousChapterTapped
    }

    //MARK: - Reducer
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .previousChapterTapped:
                let previousChapter = state.libraryState.previousChapter
                return .concatenate(
                    .send(.library(.selectPrevious)),
                    .send(.player(.previousTapped(previousChapter)))
                )
            case .nextChapterTapped:
                let nextChapter = state.libraryState.nextChapter
                print("[Chapter]", nextChapter?.fileName ?? "nil")
                return .concatenate(
                    .send(.library(.selectNext)),
                    .send(.player(.nextTapped(nextChapter)))
                )
            default:
                return .none
            }
        }
        
        Scope(
            state: \.audioPlayerState,
            action: \.player
        ) {
            audioPlayerFeature
        }
        
        Scope(
            state: \.libraryState,
            action: \.library
        ) {
            libraryFeature
        }
    }
}

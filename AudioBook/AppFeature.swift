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
    private let detailsFeature = DetailsFeature()
    
    //MARK: - State
    public struct State: Equatable {

        var libraryState: LibraryFeature.State
        var audioPlayerState: AudioPlayerFeature.State
        var detailsState: DetailsFeature.State

        static let initial: Self = .init(
            libraryState: LibraryFeature.State(),
            audioPlayerState: AudioPlayerFeature.State(),
            detailsState: DetailsFeature.State()
        )
    }

    //MARK: - Action
    @CasePathable
    public enum Action: Equatable {
        case library(LibraryFeature.Action)
        case player(AudioPlayerFeature.Action)
        case details(DetailsFeature.Action)
        case setUpFirstBook
        case nextChapterTapped
        case previousChapterTapped
    }

    //MARK: - Reducer
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .setUpFirstBook:
                let book = state.libraryState.currentBook
                return .concatenate(
                    .send(.player(.setFirstBookToPlayer(book))),
                    .send(.details(.updateChapterDescription(book?.chapters.first)))
                    )
            case .previousChapterTapped:
                let previousChapter = state.libraryState.previousChapter
                if
                    state.libraryState.isFirstChapterInBook,
                    let previousBook = state.libraryState.previousBook {
                    return .concatenate(
                        .send(.library(.selectPrevious)),
                        .send(.player(.previousTapped(previousChapter))),
                        .send(.player(.updateBookData(previousBook))),
                        .send(.details(.updateChapterDescription(previousChapter)))
                    )
                } else {
                    return .concatenate(
                        .send(.library(.selectPrevious)),
                        .send(.player(.previousTapped(previousChapter))),
                        .send(.details(.updateChapterDescription(previousChapter)))
                    )
                }
            case .nextChapterTapped:
                let nextChapter = state.libraryState.nextChapter
                if
                    state.libraryState.isLastChapterInBook,
                    let nextBook = state.libraryState.nextBook {
                    return .concatenate(
                        .send(.library(.selectNext)),
                        .send(.player(.nextTapped(nextChapter))),
                        .send(.player(.updateBookData(nextBook))),
                        .send(.details(.updateChapterDescription(nextChapter)))
                    )
                } else {
                    return .concatenate(
                        .send(.library(.selectNext)),
                        .send(.player(.nextTapped(nextChapter))),
                        .send(.details(.updateChapterDescription(nextChapter)))
                    )
                }
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
        
        Scope(
            state: \.detailsState,
            action: \.details
        ) {
            detailsFeature
        }
    }
}

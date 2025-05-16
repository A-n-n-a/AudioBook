//
//  DetailsFeature.swift
//  AudioBook
//
//  Created by Anna on 5/13/25.
//


import Foundation
import ComposableArchitecture

public struct DetailsFeature: Reducer {
    //MARK: - State
    public struct State: Equatable {
        
        var chapterDescription: String?

        public init() {}

    }

    //MARK: - Action
    @CasePathable
    public enum Action: Equatable {
        case updateChapterDescription(Chapter?)
    }

    //MARK: - Reducer
    public func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .updateChapterDescription(let chapter):
            if let chapter {
                state.chapterDescription = chapter.description
            }
            return .none
        }
    }
}

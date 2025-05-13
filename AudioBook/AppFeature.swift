//
//  AppFeature.swift
//  AudioBook
//
//  Created by Anna on 5/13/25.
//

import ComposableArchitecture

public struct AppFeature: Reducer {
    
    private let audioPlayerFeature = AudioPlayerFeature()
    
    //MARK: - State
    public struct State: Equatable {
        public enum Route: Hashable {
            case details
        }

        var path: [Route] = []
        var audioPlayerState: AudioPlayerFeature.State
        var detailsState: DetailsFeature.State?

        static let initial: Self = .init(
            audioPlayerState: AudioPlayerFeature.State(),
            detailsState: .none
        )
    }

    //MARK: - Action
    @CasePathable
    public enum Action: Equatable {
        case player(AudioPlayerFeature.Action)
        case details(DetailsFeature.Action)
        case path([State.Route])
    }

    //MARK: - Reducer
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .player:
                
//                state.detailsState = .init(post: post)
//                state.path = [.details]
                return .none
            case .path(let newPath):
                state.path = newPath
                return .none
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
    }
}

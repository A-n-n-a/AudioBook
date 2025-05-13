//
//  AppView.swift
//  AudioBook
//
//  Created by Anna on 5/13/25.
//

import SwiftUI
import ComposableArchitecture

struct AppView: View {
    let store: StoreOf<AppFeature>
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }, removeDuplicates: ==) { viewStore in
            NavigationStack(
                path: viewStore.binding(
                    get: \.path,
                    send: .path([])
                )
            ) {
                AudioPlayerView(
                    store: store.scope(
                        state: \.audioPlayerState,
                        action: \.player
                    )
                )
                .navigationBarHidden(false)
                .onAppear {
                    viewStore.start()
                }
                .navigationDestination(for: AppFeature.State.Route.self) { route in
                    switch route {
                    case .details:

                        EmptyView()
                    }
                }
            }
        }
    }
}

fileprivate extension ViewStore<AppFeature.State, AppFeature.Action> {
    func start() {
        send(.player(AudioPlayerFeature.Action.onAppear))
    }
}

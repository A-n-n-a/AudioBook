//
//  DetailsView.swift
//  AudioBook
//
//  Created by Anna on 5/13/25.
//


import SwiftUI
import ComposableArchitecture

struct DetailsView: View {
    let store: StoreOf<DetailsFeature>

    var body: some View {
        WithViewStore(self.store, observe: { $0 }, removeDuplicates: ==) { viewStore in
            
            VStack(spacing: 20) {
                Text("Details")

//                HStack {
//                    Button("⏪ 15s") {
//                        viewStore.send(.backwardTapped)
//                    }
//
//                    Button(viewStore.isPlaying ? "⏸ Pause" : "▶️ Play") {
//                        viewStore.send(.playPauseTapped)
//                    }
//
//                    Button("15s ⏩") {
//                        viewStore.send(.forwardTapped)
//                    }
//                }
            }
            .padding()
//            .onAppear {
//                viewStore.send(.onAppear)
//            }
        }
    }
}


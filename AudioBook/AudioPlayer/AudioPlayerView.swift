//
//  AudioPlayerView.swift
//  AudioBook
//
//  Created by Anna on 5/13/25.
//


import SwiftUI
import ComposableArchitecture

struct AudioPlayerView: View {
    let store: StoreOf<AudioPlayerFeature>

    var body: some View {
        WithViewStore(self.store, observe: { $0 }, removeDuplicates: ==) { viewStore in
            
            VStack(spacing: 20) {
                Text("Time: \(formatTime(viewStore.currentTime)) / \(formatTime(viewStore.duration))")

                HStack {
                    Button("⏪ 15s") {
                        viewStore.send(.backwardTapped)
                    }

                    Button(viewStore.isPlaying ? "⏸ Pause" : "▶️ Play") {
                        viewStore.send(.playPauseTapped)
                    }

                    Button("15s ⏩") {
                        viewStore.send(.forwardTapped)
                    }
                }
            }
            .padding()
            .onAppear {
                viewStore.send(.onAppear)
            }
        }
    }

    func formatTime(_ time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}


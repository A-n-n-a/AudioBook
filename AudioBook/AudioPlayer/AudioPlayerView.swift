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
                    
                    Button {
                        appStore.send(.previousChapterTapped)
                    } label: {
                        Image(systemName: "backward.end.fill")
                            .font(.title)
                    }
                    
                    Button {
                        viewStore.send(.backwardTapped)
                    } label: {
                        Image(systemName: "5.arrow.trianglehead.counterclockwise")
                    }

                    Button() {
                        viewStore.send(.playPauseTapped)
                    } label: {
                        viewStore.isPlaying ? Image(systemName: "pause.fill") : Image(systemName: "playpause.fill")
                    }

                    Button {
                        viewStore.send(.forwardTapped)
                    } label: {
                        Image(systemName: "10.arrow.trianglehead.clockwise")
                    }
                    
                    Button {
                        appStore.send(.nextChapterTapped)
                    } label: {
                        Image(systemName: "forward.end.fill")
                            .font(.title)
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


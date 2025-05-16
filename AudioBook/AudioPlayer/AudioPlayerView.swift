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
    
    @State var selectedSpeed: Float = 1

    var body: some View {
        WithViewStore(self.store, observe: { $0 }, removeDuplicates: ==) { viewStore in
            ZStack {
                Color.lightBeige
                    .ignoresSafeArea()
                
                
                VStack(spacing: 20) {
                    
                    Image(viewStore.currentBook?.imageName ?? "placeholder")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 200, height: 300)
                        .cornerRadius(5)
                    
                    infoLabels(viewStore: viewStore)
                    
                    progressView(viewStore: viewStore)
                    
                    speedButton(viewStore: viewStore)
                    
                    playerControls(viewStore: viewStore)
                }
                .onAppear {
                    viewStore.send(.onAppear)
                }
            }
        }
    }
    
    private func infoLabels(viewStore: ViewStore<AudioPlayerFeature.State, AudioPlayerFeature.Action>) -> some View {
        VStack(spacing: 5) {
            
            Text("KEY POINT \(viewStore.chapterNumber) OF \(viewStore.numberOfChapters)")
                .foregroundColor(.gray)
            
            VStack(alignment: .center, spacing: 0) {
                Text(viewStore.currentChapter?.title ?? "")
                    .multilineTextAlignment(.center)
                Spacer()
            }
            .frame(height: 60)
        }
        .padding(.horizontal)
    }
    
    private func progressView(viewStore: ViewStore<AudioPlayerFeature.State, AudioPlayerFeature.Action>) -> some View {
        HStack(spacing: 8) {
            Text(formatTime(viewStore.currentTime))
                .foregroundColor(.gray)
                .font(.body)
                .frame(width: 50)
            
            AudioProgressView(
                value: viewStore.binding(
                    get: \.currentTime,
                    send: { newValue in AudioPlayerFeature.Action.rewindToTime(newValue) }
                ),
                range: 0...viewStore.duration
            )

            Text(formatTime(viewStore.duration))
                .foregroundColor(.gray)
                .font(.body)
                .frame(width: 50)
        }
        .padding(.horizontal)
    }
    
    private func speedButton(viewStore: ViewStore<AudioPlayerFeature.State, AudioPlayerFeature.Action>) -> some View {
        Menu {
            Button("x0.5") {
                selectedSpeed = 0.5
                viewStore.send(.changeRate(selectedSpeed))
            }
            Button("x1") {
                selectedSpeed = 1.0
                viewStore.send(.changeRate(selectedSpeed))
            }
            Button("x1.5") {
                selectedSpeed = 1.5
                viewStore.send(.changeRate(selectedSpeed))
            }
            Button("x2") {
                selectedSpeed = 2.0
                viewStore.send(.changeRate(selectedSpeed))
            }
        } label: {
            Text("Speed x\(formattedSpeed(selectedSpeed))")
        }
        .frame(width: 100, height: 30)
        .background(.gray.opacity(0.3))
        .cornerRadius(5)
        .foregroundColor(.black)
        .font(.body)
    }
    
    private func playerControls(viewStore: ViewStore<AudioPlayerFeature.State, AudioPlayerFeature.Action>) -> some View {
        HStack(spacing: 25) {
            
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
                    .font(.title)
            }

            Button {
                viewStore.send(.playPauseTapped)
            } label: {
                (viewStore.isPlaying
                    ? Image(systemName: "pause.fill")
                    : Image(systemName: "playpause.fill"))
                    .font(.largeTitle)
                    .frame(width: 40)
            }

            Button {
                viewStore.send(.forwardTapped)
            } label: {
                Image(systemName: "10.arrow.trianglehead.clockwise")
                    .font(.title)
            }

            Button {
                appStore.send(.nextChapterTapped)
            } label: {
                Image(systemName: "forward.end.fill")
                    .font(.title)
            }
        }
        .foregroundColor(.black)
        .padding(.vertical, 20)
    }
    
    private func formatTime(_ time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    private func formattedSpeed(_ speed: Float) -> String {
        if speed.truncatingRemainder(dividingBy: 1) == 0 {
            return String(format: "%.0f", selectedSpeed)
        } else {
            return String(format: "%.1f", selectedSpeed)
        }
    }
}


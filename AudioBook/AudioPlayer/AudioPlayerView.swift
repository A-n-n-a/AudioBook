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
            ZStack {
                Color(red: 254/255, green: 249/255, blue: 244/255)
                    .ignoresSafeArea()
                
                
                VStack(spacing: 20) {
                    
                    Image(viewStore.currentBook?.imageName ?? "placeholder")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 200, height: 300)
                        .cornerRadius(5)
                    
                    infoLabels(viewStore: viewStore)
                    
                    Text("Time: \(formatTime(viewStore.currentTime)) / \(formatTime(viewStore.duration))")
                    
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
                Spacer() // Pushes text to the top
            }
            .frame(height: 60)
        }
        .padding(.horizontal, 20)
    }
    
    private func playerControls(viewStore: ViewStore<AudioPlayerFeature.State, AudioPlayerFeature.Action>) -> some View {
        HStack(spacing: 20) {
            
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
}


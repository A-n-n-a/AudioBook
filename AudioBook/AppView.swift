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
    @State var selectedTab: Tab = .player
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }, removeDuplicates: ==) { viewStore in
            
            NavigationStack {
                ZStack(alignment: .bottom) {
                    content(viewStore: viewStore)
                    tabBar
                }
            }
            .onAppear {
                viewStore.send(.library(.onAppear))
                viewStore.send(.setUpFirstBook)
            }
            .alert(store: store.scope(state: \.$alert, action: \.alert))
        }
    }
    
    private func content(viewStore: ViewStoreOf<AppFeature>) -> some View {
        TabView(selection: $selectedTab) {
            AudioPlayerView(
                store: store.scope(
                    state: \.audioPlayerState,
                    action: \.player
                )
            )
            .tag(Tab.player)

            DetailsView(
                store: store.scope(
                    state: \.detailsState,
                    action: \.details
                )
            )
            .tag(Tab.details)
        }
    }
    
    private var tabBar: some View {
        ZStack {
            HStack {
                ForEach(Tab.allCases, id: \.self) { tab in
                    Button {
                        selectedTab = tab
                        triggerHapticFeedback()
                    } label: {
                        CustomTabItem(
                            imageName: tab.iconName,
                            isActive: selectedTab == tab
                        )
                    }
                }
            }
            .padding(6)
            .padding(.horizontal, 2)
        }
        .frame(height: 60)
        .background(.white)
        .cornerRadius(30)
        .overlay(
                RoundedRectangle(cornerRadius: 30)
                    .stroke(Color.gray.opacity(0.3), lineWidth: 0.5)
            )
    }
}

//fileprivate extension ViewStore<AppFeature.State, AppFeature.Action> {
//    func start() {
//        send(.player(AudioPlayerFeature.Action.onAppear))
//    }
//}

//TODO: CustomView
extension AppView{
    func CustomTabItem(imageName: String,  isActive: Bool) -> some View{
        HStack {
            Spacer()
            Image(systemName: imageName)
                .resizable()
                .scaledToFit()
                .foregroundColor(isActive ? .white: .black)
                .frame(width: 24, height: 24)
            Spacer()
        }
        .frame(width: 50, height: 50)
        .background(isActive ? .blue: .clear)
        .cornerRadius(25)
    }
}

enum Tab: CaseIterable {
    case player
    case details
    
    var iconName: String{
        switch self {
        case .player:
            return "headphones"
        case .details:
            return "text.alignleft"
        }
    }
}

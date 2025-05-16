//
//  AudioBookApp.swift
//  AudioBook
//
//  Created by Anna on 5/13/25.
//

import ComposableArchitecture
import SwiftUI

let appStore: StoreOf<AppFeature> = .init(
        initialState: .initial,
        reducer: AppFeature.init
    )

@main
struct AudioBookApp: App {
    
    init() {
            UITabBar.appearance().isHidden = true
        }
    
    var body: some Scene {
        WindowGroup {
            AppView(
                store: appStore
            )
        }
    }
}

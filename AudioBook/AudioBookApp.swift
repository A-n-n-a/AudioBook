//
//  AudioBookApp.swift
//  AudioBook
//
//  Created by Anna on 5/13/25.
//

import SwiftUI

@main
struct AudioBookApp: App {
    
    var body: some Scene {
        WindowGroup {
            AppView(
                store: .init(
                    initialState: .initial,
                    reducer: AppFeature.init
                )
            )
        }
    }
}

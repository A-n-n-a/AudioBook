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
            
            VStack {
                HTMLTextView(htmlContent: String(viewStore.chapterDescription ?? "No Available Description"))
                    .id(viewStore.chapterDescription ?? "No Available Description")
                    .padding(.horizontal)
                Spacer()
            }
            .padding()
            .background(Color.lightBeige)
        }
    }
}


//
//  DetailsFeature.swift
//  AudioBook
//
//  Created by Anna on 5/13/25.
//


import Foundation
import ComposableArchitecture

public struct DetailsFeature: Reducer {
    //MARK: - State
    public struct State: Equatable {
        private let text: String

        public init(text: String) {
            self.text = text
        }

        var title: String {
            ""//post.titleRendered.title.removeHTMLTags()
        }

        var imageUrl: URL? {
            nil//post.featuredMedia.flatMap { URL(string: $0.fullSizeUrl) }
        }

        var date: String {
            ""//post.date
        }

        var content: String {
            ""//post.contentRendered.content.removeHTMLTags()
        }
    }

    //MARK: - Action
    @CasePathable
    public enum Action: Equatable {}

    //MARK: - Reducer
    public var body: some ReducerOf<Self> {
        EmptyReducer()
    }
}

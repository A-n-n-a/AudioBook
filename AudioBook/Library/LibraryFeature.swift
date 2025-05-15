//
//  LibraryFeature.swift
//  AudioBook
//
//  Created by Anna on 5/15/25.
//

import ComposableArchitecture
import Foundation

public struct LibraryFeature: Reducer {
    public struct State: Equatable {
        var books: [Book] = []
        var currentBook: Book?
        var currentChapter: Chapter?
        
        var isSwitchToNextAvailable: Bool {
            if isLastChapterInBook && isLastBookInLibrary {
                return false
            }
            return true
        }
        
        var isSwitchToPreviousAvailable: Bool {
            if isFirstChapterInBook && isFirstBookInLibrary {
                return false
            }
            return true
        }
        
        var isFirstChapterInBook: Bool {
            guard let chapterIndex else {
                return true
            }
            return chapterIndex == 0
        }
        
        var isLastChapterInBook: Bool {
            guard let chapterIndex else {
                return true
            }
            return chapterIndex == (currentBook?.chapters.count ?? 0) - 1
        }
        
        var isFirstBookInLibrary: Bool {
            guard let bookIndex else {
                return true
            }
            return bookIndex == 0
        }
        
        var isLastBookInLibrary: Bool {
            guard let bookIndex else {
                return true
            }
            return bookIndex == books.count - 1
        }
        
        var chapterIndex: Int? {
            guard
                let currentBook,
                let currentChapter,
                let currentIndex = currentBook.chapters.firstIndex(of: currentChapter) else {
                return nil
            }
            return currentIndex
        }
        
        var bookIndex: Int? {
            guard
                let currentBook,
                let currentIndex = books.firstIndex(of: currentBook) else {
                return nil
            }
            return currentIndex
        }
        
        var nextBook: Book? {
            if let bookIndex {
                return books[safe: bookIndex + 1]
            }
            return books.first
        }
        
        var previousBook: Book? {
            if let bookIndex {
                return books[safe: bookIndex - 1]
            }
            return nil
        }
        
        var nextChapter: Chapter? {
            if let chapterIndex {
                print("[Chapter index]", chapterIndex)
                return currentBook?.chapters[safe: chapterIndex + 1]
            }
            return books.first?.chapters.first
        }
        
        var previousChapter: Chapter? {
            if let chapterIndex {
                return currentBook?.chapters[safe: chapterIndex - 1]
            }
            return nil
        }
    }

    @CasePathable
    public enum Action: Equatable {
        case onAppear
        case selectBook(UUID)
        case selectChapter(UUID)
        case selectNext
        case selectPrevious
    }

    public func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .onAppear:
            state.books = Self.sampleBooks
            if state.currentBook == nil {
                state.currentBook = state.books.first
                print("[Current Book] 123", state.currentBook?.title ?? "nil")
                state.currentChapter = state.currentBook?.chapters.first
            }
            return .none

        case let .selectBook(bookId):
            state.currentBook = state.books.first(where: { $0.id == bookId })
            print("[Current Book] 129", state.currentBook?.title ?? "nil")
            state.currentChapter = state.currentBook?.chapters.first
            return .none
            
        case let .selectChapter(chapterId):
            state.currentChapter = state.currentBook?.chapters.first(where: { $0.id == chapterId })
            return .none
        case .selectNext:
            selectNextChapter(state: &state)
            return .none
        case .selectPrevious:
            selectPreviousChapter(state: &state)
            return .none
        }
    }
    
    private func selectNextChapter(state: inout State) {
        if state.isLastChapterInBook {
            state.currentBook = state.nextBook
            print("[Current Book] 148", state.currentBook?.title ?? "nil")
            state.currentChapter = state.currentBook?.chapters.first
        } else {
            state.currentChapter = state.nextChapter
        }
    }
    
    private func selectPreviousChapter(state: inout State) {
        if state.isFirstChapterInBook {
            state.currentBook = state.previousBook
            print("[Current Book] 158", state.currentBook?.title ?? "nil")
            state.currentChapter = state.currentBook?.chapters.first
        } else {
            state.currentChapter = state.previousChapter
        }
    }
}

extension LibraryFeature {
    static let sampleBooks: [Book] = [
        Book(
            id: UUID(),
            title: "Autumn Leaves",
            author: "Anne Wales Abbot",
            chapters: [
                Chapter(id: UUID(), title: "Chapter 1", fileName: "autumnleaves_01_abbot_64kb", fileExtension: "mp3"),
                Chapter(id: UUID(), title: "Chapter 2", fileName: "autumnleaves_02_abbot_64kb", fileExtension: "mp3"),
                Chapter(id: UUID(), title: "Chapter 3", fileName: "autumnleaves_03_abbot_64kb", fileExtension: "mp3")
            ]
        ),
        Book(
            id: UUID(),
            title: "Under the Gun",
            author: "Annie Wittenmyer",
            chapters: [
                Chapter(id: UUID(), title: "Chapter 1", fileName: "undertheguns_01_wittenmyer_64kb", fileExtension: "mp3"),
                Chapter(id: UUID(), title: "Chapter 2", fileName: "undertheguns_02_wittenmyer_64kb", fileExtension: "mp3"),
                Chapter(id: UUID(), title: "Chapter 3", fileName: "undertheguns_03_wittenmyer_64kb", fileExtension: "mp3")
            ]
        )
    ]
}

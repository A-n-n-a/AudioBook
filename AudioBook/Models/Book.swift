//
//  Book.swift
//  AudioBook
//
//  Created by Anna on 5/15/25.
//

import Foundation

struct Book: Equatable, Identifiable {
    let id: UUID
    let title: String
    let author: String
    let chapters: [Chapter]
}

//
//  Book.swift
//  AudioBook
//
//  Created by Anna on 5/15/25.
//

import Foundation

public struct Book: Equatable, Identifiable {
    public let id: UUID
    let imageName: String?
    let title: String
    let author: String
    let chapters: [Chapter]
}

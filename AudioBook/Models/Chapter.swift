//
//  Chapter.swift
//  AudioBook
//
//  Created by Anna on 5/15/25.
//

import Foundation

public struct Chapter: Equatable, Identifiable {
    public let id: UUID
    let title: String
    let fileName: String
    let fileExtension: String
    let description: String?
}

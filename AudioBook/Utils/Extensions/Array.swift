//
//  Array.swift
//  AudioBook
//
//  Created by Anna on 5/15/25.
//

extension Array {
    public subscript(safe index: Int) -> Element? {
        guard index >= 0, index < endIndex else { return nil }
        return self[index]
    }
}

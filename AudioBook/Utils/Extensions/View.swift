//
//  View.swift
//  AudioBook
//
//  Created by Anna on 5/14/25.
//

import SwiftUI

extension View {
    func triggerHapticFeedback(style: UIImpactFeedbackGenerator.FeedbackStyle = .light) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.prepare()
        generator.impactOccurred()
    }
}

//
//  AudioProgressView.swift
//  AudioBook
//
//  Created by Anna on 5/16/25.
//


import SwiftUI

struct AudioProgressView: View {
    @Binding var value: Double
    var range: ClosedRange<Double>

    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            let height: CGFloat = 4
            let thumbSize: CGFloat = 16
            
            let total = range.upperBound - range.lowerBound
            let progress = CGFloat((value - range.lowerBound) / total)
            let xPos = max(0, progress * (width - thumbSize))

            ZStack(alignment: .leading) {
                // Track
                Capsule()
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: height)

                // Progress
                Capsule()
                    .fill(Color.blue)
                    .frame(width: xPos + thumbSize / 2, height: height)

                // Thumb
                Circle()
                    .fill(Color.blue)
                    .frame(width: thumbSize, height: thumbSize)
                    .offset(x: xPos)
                    .gesture(
                        DragGesture()
                            .onChanged { gesture in
                                let dragX = gesture.location.x - thumbSize / 2
                                let clamped = min(max(0, dragX), width - thumbSize)
                                let percent = clamped / (width - thumbSize)
                                self.value = range.lowerBound + Double(percent) * total
                            }
                    )
            }
        }
        .frame(height: 20)
    }
}

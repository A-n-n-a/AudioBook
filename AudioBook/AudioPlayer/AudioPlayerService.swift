//
//  AudioPlayerService.swift
//  AudioBook
//
//  Created by Anna on 5/13/25.
//


import Foundation
import AVFoundation
import Combine

public protocol AudioPlayerServiceProtocol {
    func play()
    func pause()
    func seek(by seconds: TimeInterval)
    func duration() -> TimeInterval
    func timerPublisher() -> AsyncStream<TimeInterval> 
}

public class AudioPlayerService: AudioPlayerServiceProtocol {
    private var player: AVAudioPlayer?
    private var timerSubject = PassthroughSubject<TimeInterval, Never>()
    private let fileExtension = "mp3"
    private var timer: Timer?

    init(fileName: String) {
        if
            let url = Bundle.main.url(forResource: fileName, withExtension: fileExtension),
            let player = try? AVAudioPlayer(contentsOf: url) {
            self.player = player
        }
    }

    public func play() {
        player?.play()
        startTimer()
    }

    public func pause() {
        player?.pause()
        stopTimer()
    }

    public func seek(by seconds: TimeInterval) {
        player?.currentTime += seconds
    }

    public func duration() -> TimeInterval {
        player?.duration ?? 0
    }

    public func timerPublisher() -> AsyncStream<TimeInterval> {
        AsyncStream { continuation in
            DispatchQueue.main.async {
                self.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
                    continuation.yield(self.player?.currentTime ?? 0)
                }
                RunLoop.current.add(self.timer!, forMode: .common)
            }
        }
    }
    
    private func startTimer() {
        timer?.fire()
    }
    
    private func stopTimer() {
        timer?.invalidate()
    }
}

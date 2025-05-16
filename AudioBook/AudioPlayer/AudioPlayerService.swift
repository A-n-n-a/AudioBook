//
//  AudioPlayerService.swift
//  AudioBook
//
//  Created by Anna on 5/13/25.
//


import Foundation
import AVFoundation

public protocol AudioPlayerServiceProtocol {
    func play()
    func pause()
    func seek(by seconds: TimeInterval)
    func rewind(to time: TimeInterval)
    func duration() -> TimeInterval
    func setRate(rate: Float)
    func timerPublisher() -> AsyncStream<TimeInterval>
    func switchToChapter(_ chapter: Chapter, play: Bool)
}

public class AudioPlayerService: NSObject, AudioPlayerServiceProtocol {
    private var player: AVAudioPlayer?
    private var timer: Timer?

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
    
    public func rewind(to time: TimeInterval) {
        player?.currentTime = time
    }

    public func duration() -> TimeInterval {
        player?.duration ?? 0
    }
    
    public func setRate(rate: Float) {
        player?.rate = rate
    }
    
    public func switchToChapter(_ chapter: Chapter, play: Bool) {
        setChapter(chapter)
        if play {
            self.player?.play()
        }
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
    
    private func setChapter(_ chapter: Chapter) {
        if
            let url = Bundle.main.url(forResource: chapter.fileName, withExtension: chapter.fileExtension),
            let player = try? AVAudioPlayer(contentsOf: url) {
            self.player = player
            self.player?.delegate = self
            self.player?.enableRate = true
        }
    }
}

extension AudioPlayerService: AVAudioPlayerDelegate {
    public func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        appStore.send(.nextChapterTapped)
    }
}

//
//  AudioPlayerEnvironment.swift
//  AudioBook
//
//  Created by Anna on 5/13/25.
//


public struct AudioPlayerEnvironment {
    public let audioPlayerService: AudioPlayerServiceProtocol

    public init(audioPlayerService: AudioPlayerServiceProtocol) {
        self.audioPlayerService = audioPlayerService
    }
}

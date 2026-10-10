//
//  SoundManager.swift
//  Panda Jump
//
//  Created by Marc Vandehey on 9/28/16.
//  Copyright © 2016 Thirteen23. All rights reserved.
//

import AVFoundation
import SpriteKit

final class SoundManager: NSObject, AVAudioPlayerDelegate {
    static let shared = SoundManager()

    var isMusicEnabled: Bool {
        didSet {
            guard isMusicEnabled != oldValue else { return }
            GameData.isMusicEnabled = isMusicEnabled
            if isMusicEnabled {
                startPlaying()
            } else {
                audioPlayer?.stop()
            }
        }
    }

    var isSoundEffectsEnabled: Bool {
        didSet {
            guard isSoundEffectsEnabled != oldValue else { return }
            GameData.isSoundEffectsEnabled = isSoundEffectsEnabled
        }
    }

    private var audioPlayer: AVAudioPlayer?
    private var trackPosition: Int

    // Music: http://www.bensound.com/royalty-free-music
    private static let tracks = [
        "bensound-clearday",
        "bensound-jazzcomedy",
        "bensound-jazzyfrenchy",
        "bensound-littleidea"
    ]

    static let jumpSound = SKAction.playSoundFileNamed("jumping_sound.wav", waitForCompletion: false)
    static let coinSound = SKAction.playSoundFileNamed("coinSound.wav", waitForCompletion: false)

    private override init() {
        trackPosition = Int.random(in: 0..<SoundManager.tracks.count)
        isMusicEnabled = GameData.isMusicEnabled
        isSoundEffectsEnabled = GameData.isSoundEffectsEnabled
        super.init()
    }

    func play(_ sound: SKAction, on node: SKNode) {
        guard isSoundEffectsEnabled else { return }
        node.run(sound)
    }

    func startPlaying() {
        guard isMusicEnabled, audioPlayer?.isPlaying != true else { return }

        // Try each track once, so a missing file can't loop forever.
        for _ in SoundManager.tracks {
            let track = SoundManager.tracks[trackPosition]
            trackPosition = (trackPosition + 1) % SoundManager.tracks.count

            guard let url = Bundle.main.url(forResource: track, withExtension: "mp3"),
                  let player = try? AVAudioPlayer(contentsOf: url) else {
                continue
            }
            player.delegate = self
            player.volume = 0.5
            player.prepareToPlay()
            player.play()
            audioPlayer = player
            return
        }
    }

    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        startPlaying()
    }
}

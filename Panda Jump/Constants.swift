//
//  Constants.swift
//  Panda Jump
//
//  Created by Jack Darnell on 3/20/17.
//  Copyright © 2017 Jack Darnell. All rights reserved.
//

import SpriteKit
import UIKit

let SHADOW_GRAY: CGFloat = 120.0 / 255.0

let FloorCategory: UInt32 = 0x1 << 1
let BarrelCategory: UInt32 = 0x1 << 2
let WorldCategory: UInt32 = 0x1 << 3
let PlayerCategory: UInt32 = 0x1 << 4
let ScoreCategory: UInt32 = 0x1 << 5

let PixelFontName = "PixelDigivolve"
let CoinColor = SKColor(red: 0.99, green: 0.92, blue: 0.55, alpha: 1.0)

/// Shared by the floor and the boulders so they stay locked together on every screen size.
let ScrollSpeed: CGFloat = 195.0

// Set to true to show the banner ad. While false the ad SDK never starts and the
// game gets the full screen.
let AdsEnabled = false

// Google's public test IDs. Swap in your own AdMob IDs (here and in Info.plist) before shipping.
let BannerAdUnitID = "ca-app-pub-3940256099942544/2435281174"
let LeaderboardID = "grp.PandaJumnpTopScores"

// MARK: - Saved data

private let CoinsKey = "TOTAL_COINS"
private let ScoreKey = "HIGHSCORE"
private let MusicEnabledKey = "MUSIC_ENABLED"
private let SoundEffectsEnabledKey = "SOUND_EFFECTS_ENABLED"
/// Superseded by the two keys above, which split music from sound effects.
private let LegacyMuteKey = "APP_MUTED"
private let currentSkinIndexKey = "CURRENT_SKIN"

/// Everything the game persists between launches, in one place.
enum GameData {
    private static var defaults: UserDefaults { .standard }

    static var coins: Int {
        get { defaults.integer(forKey: CoinsKey) }
        set { defaults.set(newValue, forKey: CoinsKey) }
    }

    static var highScore: Int {
        get { defaults.integer(forKey: ScoreKey) }
        set { defaults.set(newValue, forKey: ScoreKey) }
    }

    /// Index into `skins`, clamped so a removed skin can never crash the app.
    static var currentSkinIndex: Int {
        get {
            let index = defaults.integer(forKey: currentSkinIndexKey)
            return skins.indices.contains(index) ? index : 0
        }
        set { defaults.set(newValue, forKey: currentSkinIndexKey) }
    }

    static var currentSkin: CharacterSkin { skins[currentSkinIndex] }

    static var isMusicEnabled: Bool {
        get { audioFlag(MusicEnabledKey) }
        set { defaults.set(newValue, forKey: MusicEnabledKey) }
    }

    static var isSoundEffectsEnabled: Bool {
        get { audioFlag(SoundEffectsEnabledKey) }
        set { defaults.set(newValue, forKey: SoundEffectsEnabledKey) }
    }

    /// Defaults to on, falling back to the old single mute flag so players who
    /// muted before music and effects were split stay muted.
    private static func audioFlag(_ key: String) -> Bool {
        guard defaults.object(forKey: key) != nil else {
            return !defaults.bool(forKey: LegacyMuteKey)
        }
        return defaults.bool(forKey: key)
    }

    static var isDevSkinEquipped: Bool { currentSkin.name == devSkin.name }
}

// MARK: - Character skins

/// Builds a walk cycle that plays the frames forwards and then back again.
private func pingPongFrames(_ names: [String]) -> [SKTexture] {
    let forward = names
    let backward = names.dropFirst().dropLast().reversed()
    return (forward + backward).map { SKTexture(imageNamed: $0) }
}

let normalPandaSkin = CharacterSkin(
    name: "Classic Panda",
    price: 0,
    description: "Classic Panda, with a backpack, cus why not.",
    imageName: "panda1",
    frames: pingPongFrames((1...6).map { "panda\($0)" }),
    ownedKey: "NORMAL_PANDA_OWNED_KEY")

let soundcloudRapperSkin = CharacterSkin(
    name: "Jetski",
    price: 30,
    description: "Ladies you have 30$ to build ur perfect man: \n$700 - Educated \n$500 - Rich\n$30 - Soundcloud Rapper\n$250 - Loyal",
    imageName: "soundcloudRapperV2_6",
    frames: pingPongFrames((2...6).map { "soundcloudRapperV2_\($0)" }) + [SKTexture(imageNamed: "soundcloudRapperV2_2"), SKTexture(imageNamed: "soundcloudRapperV2_1")],
    ownedKey: "SOUNDCLOUD_RAPPER_OWNED_KEY")

let gutePandaSkin = CharacterSkin(
    name: "Gute",
    price: 500,
    description: "They migrated to the United States from Mexico ages ago. In the U.S. one was captured and held in a zoo but it wouldnt eat any of the quality food it was given. After days of it not eating, one of the employees dropped a grilled cheese near the cage and Gute dove for it. From that day on Gute was kept on a strict diet of only grilled cheeses and grew to be a strong animal",
    imageName: "gutePanda1",
    frames: pingPongFrames((1...6).map { "gutePanda\($0)" }),
    ownedKey: "GUTE_OWNED_KEY")

let psychedelicSkin = CharacterSkin(
    name: "Psychedelic",
    price: 3000,
    description: "Wouldn't it be cool to be a caterpillar? You're walking around eating leaves, decide to take a long nap, and when you wake up you can fly",
    imageName: "Psychedelic1",
    frames: ["Psychedelic1", "Psychedelic2", "Psychedelic3small", "Psychedelic4small", "Psychedelic5small", "Psychedelic6",
             "Psychedelic1", "Psychedelic6", "Psychedelic5small", "Psychedelic4small", "Psychedelic3small", "Psychedelic2"]
        .map { SKTexture(imageNamed: $0) },
    ownedKey: "PSYCHEDELIC_OWNED_KEY")

let devSkin = CharacterSkin(
    name: "Dev",
    price: 100000,
    description: "RESTART GAME FOR FULL EFFECT",
    imageName: "redCircle",
    frames: [SKTexture(imageNamed: "redCircle")],
    ownedKey: "DEV_OWNED_KEY")

/// All skins, in shop order. Only append new skins: the saved current skin is an index into this array.
let skins = [
    normalPandaSkin,
    soundcloudRapperSkin,
    gutePandaSkin,
    psychedelicSkin,
    devSkin
]

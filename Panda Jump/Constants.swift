//
//  Constants.swift
//  Panda Jump
//
//  Created by Jack Darnell on 3/20/17.
//  Copyright © 2017 Jack Darnell. All rights reserved.
//


//TODO FOR GAME:
/*
     make a sound button for turning on and off the sound
*/



import Foundation
import SpriteKit
import UIKit

let SHADOW_GRAY: CGFloat = 120.0 / 255.0

let FloorCategory    : UInt32 = 0x1 << 1
let BarrelCategory : UInt32 = 0x1 << 2
let WorldCategory : UInt32 = 0x1 << 3
let PlayerCategory : UInt32 = 0x1 << 4
let ScoreCategory : UInt32 = 0x1 << 5


let CoinsKey = "TOTAL_COINS"
let ScoreKey = "HIGHSCORE"
let MuteKey = "APP_MUTED"

let lessThanTen = "🤢"
let lessThanTwenty = "😐"
let lessThanThirty = "🤓"
let lessThanForty = "🤠"
let lessThanFifty = "😎"
let lessThanSixty = "😉"
let SixtyNine = "🍑"
let lessThanSeventy = "😄"
let lessThan90 = "👾"
let over100 = "🤑"

//KEYS FOR CHARACTER SKINS
//CURRENT SKIN KEY
let currentSkinIndexKey = "CURRENT_SKIN"
//NORMAL PANDA:
let normalPandaPurchasedKey = "NORMAL_PANDA_PURCHASED"
let normalPandaEquipedKey = "NORMAL_PANDA_EQUIPED"
//CHARACTER SKINS


//NORMAL PANDA:
private let pandaWalkFrames = [
    SKTexture(imageNamed: "panda1"),
    SKTexture(imageNamed: "panda2"),
    SKTexture(imageNamed: "panda3"),
    SKTexture(imageNamed: "panda4"),
    SKTexture(imageNamed: "panda5"),
    SKTexture(imageNamed: "panda6"),
    SKTexture(imageNamed: "panda5"),
    SKTexture(imageNamed: "panda4"),
    SKTexture(imageNamed: "panda3"),
    SKTexture(imageNamed: "panda2")
]


let normalPandaSkin: CharacterSkin = CharacterSkin(name: "Classic Panda", price: 0, description: "Classic Panda, with a backpack, cus why not.", image: UIImage(named: "panda1")!, frames: pandaWalkFrames, owned: true, ownedKey: "true")

//GUTE
let guteOwnedKey = "GUTE_OWNED_KEY"

private let guteWalkFrames = [
    SKTexture(imageNamed: "gutePanda1"),
    SKTexture(imageNamed: "gutePanda2"),
    SKTexture(imageNamed: "gutePanda3"),
    SKTexture(imageNamed: "gutePanda4"),
    SKTexture(imageNamed: "gutePanda5"),
    SKTexture(imageNamed: "gutePanda6"),
    SKTexture(imageNamed: "gutePanda5"),
    SKTexture(imageNamed: "gutePanda4"),
    SKTexture(imageNamed: "gutePanda3"),
    SKTexture(imageNamed: "gutePanda2")
]

let gutePandaSkin: CharacterSkin = CharacterSkin(name: "Gute", price: 500, description: "They migrated to the United States from Mexico ages ago. In the U.S. one was captured and held in a zoo but it wouldnt eat any of the quality food it was given. After days of it not eating, one of the employees dropped a grilled cheese near the cage and Gute dove for it. From that day on Gute was kept on a strict diet of only grilled cheeses and grew to be a strong animal", image: UIImage(named: "gutePanda1")!, frames: guteWalkFrames, owned: UserDefaults.standard.bool(forKey: guteOwnedKey), ownedKey: guteOwnedKey)

//SOUNDCLOUD RAPPER
let soundcloudRapperOwnedKey = "SOUNDCLOUD_RAPPER_OWNED_KEY"

private let soundcloudRapperWalkFrames = [
    //SKTexture(imageNamed: "soundcloudRapperV2_1"),
    SKTexture(imageNamed: "soundcloudRapperV2_2"),
    SKTexture(imageNamed: "soundcloudRapperV2_3"),
    SKTexture(imageNamed: "soundcloudRapperV2_4"),
    SKTexture(imageNamed: "soundcloudRapperV2_5"),
    SKTexture(imageNamed: "soundcloudRapperV2_6"),
    SKTexture(imageNamed: "soundcloudRapperV2_5"),
    SKTexture(imageNamed: "soundcloudRapperV2_4"),
    SKTexture(imageNamed: "soundcloudRapperV2_3"),
    SKTexture(imageNamed: "soundcloudRapperV2_2"),
    SKTexture(imageNamed: "soundcloudRapperV2_1")
]

let soundcloudRapperSkin: CharacterSkin = CharacterSkin(name: "Jetski", price: 30, description: "Ladies you have 30$ to build ur perfect man: \n$700 - Educated \n$500 - Rich\n$30 - Soundcloud Rapper\n$250 - Loyal", image: UIImage(named: "soundcloudRapperV2_6")!, frames: soundcloudRapperWalkFrames, owned: UserDefaults.standard.bool(forKey: soundcloudRapperOwnedKey), ownedKey: soundcloudRapperOwnedKey)


//DEV SKIN
let devSkinOwnedKey = "DEV_OWNED_KEY"

private let devWalkFrames = [
    SKTexture(imageNamed: "redCircle")
]

let devSkin: CharacterSkin = CharacterSkin(name: "Dev", price: 100000, description: "RESTART GAME FOR FULL EFFECT", image: UIImage(named: "redCircle")!, frames: devWalkFrames, owned: UserDefaults.standard.bool(forKey: devSkinOwnedKey), ownedKey: devSkinOwnedKey)
//
//let queerioSkinOwnedKey = "QUEERIO_OWNED_KEY"
//
//private let queerioWalkFrames = [
//    SKTexture(imageNamed: "QueerioPNG"),
//    SKTexture(imageNamed: "QueerioPNG2"),
//    SKTexture(imageNamed: "QueerioPNG3"),
//    SKTexture(imageNamed: "QueerioPNG4"),
//    SKTexture(imageNamed: "QueerioPNG5"),
//    SKTexture(imageNamed: "QueerioPNG6"),
//    SKTexture(imageNamed: "QueerioPNG5"),
//    SKTexture(imageNamed: "QueerioPNG4"),
//    SKTexture(imageNamed: "QueerioPNG3"),
//    SKTexture(imageNamed: "QueerioPNG2"),
//]
//
//let queerioSkin: CharacterSkin = CharacterSkin(name: "Queerio", price: 400, description: "When life gives you lemons, beat it with a plunger.", image: UIImage(named: "QueerioPNG")!, frames: queerioWalkFrames, owned: UserDefaults.standard.bool(forKey: queerioSkinOwnedKey), ownedKey: queerioSkinOwnedKey)
//
//let trumpSkinOwnedKey = "TRUMP_OWNED_KEY"
//
//private let trumpWalkFrames = [
//    SKTexture(imageNamed: "TrumpPNG"),
//    SKTexture(imageNamed: "Trump2"),
//    SKTexture(imageNamed: "Trump3"),
//    SKTexture(imageNamed: "Trump4"),
//    SKTexture(imageNamed: "Trump5"),
//    SKTexture(imageNamed: "Trump6"),
//    SKTexture(imageNamed: "TrumpPNG"),
//    SKTexture(imageNamed: "Trump6"),
//    SKTexture(imageNamed: "Trump5"),
//    SKTexture(imageNamed: "Trump4"),
//    SKTexture(imageNamed: "Trump3"),
//    SKTexture(imageNamed: "Trump2")
//]
//

//
//let trumpSkin: CharacterSkin = CharacterSkin(name: "Trump", price: 2000, description: "Stud", image: UIImage(named: "TrumpPNG")!, frames: trumpWalkFrames, owned: UserDefaults.standard.bool(forKey: trumpSkinOwnedKey), ownedKey: trumpSkinOwnedKey)

let psychedelicSkinOwnedKey = "PSYCHEDELIC_OWNED_KEY"

private let psychedelicWalkFrames = [
    SKTexture(imageNamed: "Psychedelic1"),
    SKTexture(imageNamed: "Psychedelic2"),
    SKTexture(imageNamed: "Psychedelic3small"),
    SKTexture(imageNamed: "Psychedelic4small"),
    SKTexture(imageNamed: "Psychedelic5small"),
    SKTexture(imageNamed: "Psychedelic6"),
    SKTexture(imageNamed: "Psychedelic1"),
    SKTexture(imageNamed: "Psychedelic6"),
    SKTexture(imageNamed: "Psychedelic5small"),
    SKTexture(imageNamed: "Psychedelic4small"),
    SKTexture(imageNamed: "Psychedelic3small"),
    SKTexture(imageNamed: "Psychedelic2"),
]

let psychedelicSkin: CharacterSkin = CharacterSkin(name: "Psychedelic", price: 3000, description: "Wouldn't it be cool to be a caterpillar? You're walking around eating leaves, decide to take a long nap, and when you wake up you can fly", image: UIImage(named: "Psychedelic1")!, frames: psychedelicWalkFrames, owned: UserDefaults.standard.bool(forKey: psychedelicSkinOwnedKey), ownedKey: psychedelicSkinOwnedKey)

//ALL SKINS IN AN ARRAY
let skins = [
    normalPandaSkin,
    //queerioSkin,
    soundcloudRapperSkin,
    gutePandaSkin,
    //trumpSkin,
    psychedelicSkin,
    devSkin
]

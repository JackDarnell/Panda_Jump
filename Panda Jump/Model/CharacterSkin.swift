//
//  CharacterSkin.swift
//  Panda Jump
//
//  Created by Jack Darnell on 7/16/17.
//  Copyright © 2017 Jack Darnell. All rights reserved.
//

import SpriteKit
import UIKit

struct CharacterSkin {
    let name: String
    let price: Int
    let description: String
    let imageName: String
    let frames: [SKTexture]
    let ownedKey: String

    var image: UIImage? { UIImage(named: imageName) }

    var index: Int? { skins.firstIndex { $0.name == name } }

    /// Read from UserDefaults every time so there is a single source of truth.
    var isOwned: Bool { price == 0 || UserDefaults.standard.bool(forKey: ownedKey) }

    var isEquipped: Bool { index == GameData.currentSkinIndex }

    /// Spends coins on this skin. Returns false if the player can't afford it.
    func purchase() -> Bool {
        guard !isOwned else { return true }
        guard GameData.coins >= price else { return false }
        GameData.coins -= price
        UserDefaults.standard.set(true, forKey: ownedKey)
        return true
    }

    func equip() {
        guard isOwned, let index = index else { return }
        GameData.currentSkinIndex = index
    }
}

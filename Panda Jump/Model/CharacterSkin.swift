//
//  CharacterSkin.swift
//  Panda Jump
//
//  Created by Jack Darnell on 7/16/17.
//  Copyright © 2017 Jack Darnell. All rights reserved.
//
import Foundation
import UIKit
import SpriteKit

class CharacterSkin {
    
    private var _name: String!
    private var _price: Int!
    private var _description: String!
    private var _image: UIImage!
    private var _frames: Array<SKTexture>!
    private var _owned: Bool!
    private var _ownedKey: String!
    private var _equipped: Bool!
    
    var name: String {
        return _name
    }
    
    var price: Int {
        return _price
    }
    
    var description: String {
        return _description
    }
    
    var image: UIImage {
        return _image
    }
    
    var frames: Array<SKTexture> {
        return _frames
    }
    
    var owned: Bool {
        return _owned
    }
    
    var equipped: Bool {
        return _equipped
    }
    
    var ownedKey: String {
        return _ownedKey
    }
    
    init(name: String, price: Int, description: String, image: UIImage, frames: Array<SKTexture>, owned: Bool, ownedKey: String) {
        self._name = name
        self._price = price
        self._description = description
        self._image = image
        self._frames = frames
        self._owned = owned
        self._equipped = false
        self._ownedKey = ownedKey
    }
    
    func equip() {
        _equipped = true
    }
    
    func undoEquip() {
        _equipped = false
    }
    
    func purchaseSkin() {
        self._owned = true
        UserDefaults.standard.set(true, forKey: ownedKey)
    }
    
 /*
    func adjustFlags(addFlag: Bool) {
        if addFlag {
            _flags = _flags + 1
        } else {
            _flags = _flags - 1
        }
      
    }
 */

}


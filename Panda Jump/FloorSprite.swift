//
//  FloorSprite.swift
//  Panda Jump
//
//  Created by Jack Darnell on 3/25/17.
//  Copyright © 2017 Jack Darnell. All rights reserved.
//

import SpriteKit

class FloorSprite: SKSpriteNode {

    static func newInstance(sceneSize: CGSize) -> FloorSprite {
        let floorSprite = FloorSprite(imageNamed: "floor3")
        floorSprite.size = CGSize(width: 1000, height: sceneSize.height * 0.22)
        floorSprite.anchorPoint = .zero
        floorSprite.position = .zero
        floorSprite.zPosition = 2
        return floorSprite
    }
}

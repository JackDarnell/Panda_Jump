//
//  FloorSprite.swift
//  Panda Jump
//
//  Created by Jack Darnell on 3/25/17.
//  Copyright © 2017 Jack Darnell. All rights reserved.
//

import SpriteKit

class FloorSprite: SKSpriteNode {

    /// Spacing between tiles, and the distance each one scrolls before wrapping.
    static let tileWidth: CGFloat = 1000
    /// Tiles are drawn a touch wider than they are spaced, so no gap shows at the seam.
    private static let seamOverlap: CGFloat = 2

    static func newInstance(sceneSize: CGSize) -> FloorSprite {
        let floorSprite = FloorSprite(imageNamed: "floor3")
        floorSprite.size = CGSize(width: tileWidth + seamOverlap, height: sceneSize.height * 0.22)
        floorSprite.anchorPoint = .zero
        floorSprite.position = .zero
        floorSprite.zPosition = 2
        return floorSprite
    }
}

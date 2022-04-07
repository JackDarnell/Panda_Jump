//
//  FloorSprite.swift
//  Panda Jump
//
//  Created by Jack Darnell on 3/25/17.
//  Copyright © 2017 Jack Darnell. All rights reserved.
//

import SpriteKit

class FloorSprite : SKSpriteNode {
    public static func newInstance() -> FloorSprite {
        let dirtSize = CGSize(width: 1000, height: UIScreen.main.bounds.size.height * 0.22)
        /*
         let dirtNode = SKShapeNode(rect: CGRect(origin: CGPoint(), size: dirtSize))
         dirtNode.fillColor = SKColor(red:0.64, green:0.46, blue:0.39, alpha:1.0)
         dirtNode.strokeColor = SKColor.clear
         dirtNode.zPosition = 2
         */
        
        
        
        let floorSprite = FloorSprite(imageNamed: "floor3")
        floorSprite.size = dirtSize
        floorSprite.position = CGPoint(x: 0, y: 0)
        floorSprite.anchorPoint = CGPoint(x: 0, y: 0)
        floorSprite.zPosition = 2
        
        
        
        return floorSprite
    }

    func animate() {
        
    }
}

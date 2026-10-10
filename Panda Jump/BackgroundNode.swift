//
//  BackgroundNode.swift
//  Panda Jump
//
//  Created by Jack Darnell on 3/21/17.
//  Copyright © 2017 Jack Darnell. All rights reserved.
//

import SpriteKit

class BackgroundNode: SKNode {

    func setup(size: CGSize) {
        // The ground the player and boulders sit on.
        let yPos = size.height * 0.22
        physicsBody = SKPhysicsBody(edgeFrom: CGPoint(x: -300, y: yPos), to: CGPoint(x: size.width + 300, y: yPos))
        physicsBody?.restitution = 0
        physicsBody?.categoryBitMask = FloorCategory

        let skyNode = SKSpriteNode(color: UIColor(red: 0.42, green: 0.80, blue: 0.98, alpha: 1.0), size: size)
        skyNode.anchorPoint = .zero
        skyNode.position = .zero
        skyNode.zPosition = 0
        addChild(skyNode)
    }
}

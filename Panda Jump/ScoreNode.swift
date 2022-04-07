//
//  ScoreNode.swift
//  Panda Jump
//
//  Created by Jack Darnell on 3/23/17.
//  Copyright © 2017 Jack Darnell. All rights reserved.
//

import SpriteKit

//THIS NODE WILL BE AN INVISIBLE LINE IN THE CENTER OF EVERY BARREL SO WHENEVER YOU HIT IT IT WILL GIVE YOU A POINT LOOK ON FLOPPY BIRD IN SCORE NODE AND HOW IT WORKS WITH LOG AND LOG CONTROLLER

class ScoreNode : SKShapeNode {
    public static func newInstance() -> ScoreNode {
        
        let scoreNodeSize = CGSize(width: 1, height: UIScreen.main.bounds.size.height)
        let scoreNode = ScoreNode(rect: CGRect(origin: CGPoint(), size: scoreNodeSize))
        scoreNode.fillColor = SKColor.black
        scoreNode.zPosition = 8
        scoreNode.physicsBody = SKPhysicsBody(rectangleOf: scoreNodeSize)
        //scoreNode.physicsBody?.isDynamic = false
        scoreNode.physicsBody?.affectedByGravity = false
        scoreNode.physicsBody?.categoryBitMask = ScoreCategory
        scoreNode.physicsBody?.contactTestBitMask = PlayerCategory | WorldCategory
        //scoreNode.alpha = 0.0

        return scoreNode
    }

    
    
}

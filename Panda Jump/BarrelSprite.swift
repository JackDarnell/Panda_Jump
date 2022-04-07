//
//  BarrelSprite.swift
//  Panda Jump
//
//  Created by Jack Darnell on 3/21/17.
//  Copyright © 2017 Jack Darnell. All rights reserved.
//

import SpriteKit

public class BarrelSprite : SKSpriteNode {
    
    public static func newInstance() -> BarrelSprite {
        //let circleRadius : CGFloat = 10 //TODO CHANGE THIS TO FACTOR IN WIDTH OF THE SCREEN FOR MULTIPLE SCREEN SIZES
        var circle = BarrelSprite(imageNamed: "rock")
        if UserDefaults.standard.integer(forKey: currentSkinIndexKey) == 3 {
            circle = BarrelSprite(imageNamed: "redCircle")
        } else {
            circle = BarrelSprite(imageNamed: "rock")
        }
        //let circle = BarrelSprite(imageNamed: "rock")
        
        //let circle1 = SKShapeNode(circleOfRadius: circleRadius)
        
        
        
        circle.physicsBody = SKPhysicsBody(circleOfRadius: circle.size.width / 2)
        circle.physicsBody?.isDynamic = true
        circle.physicsBody?.restitution = 0 //restitution determines bounciness of the barrel
        circle.zPosition = 4
        
        return circle
    }
    
    
    
    
}

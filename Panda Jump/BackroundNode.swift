//
//  BackroundNode.swift
//  Panda Jump
//
//  Created by Jack Darnell on 3/21/17.
//  Copyright © 2017 Jack Darnell. All rights reserved.
//
import SpriteKit

public class BackgroundNode : SKNode {
    
    public func setup(size : CGSize) {
        let yPos : CGFloat = size.height * 0.22
        let startPoint = CGPoint(x: -300, y: yPos)
        let endPoint = CGPoint(x: size.width + 300, y: yPos)
        
        
        
        physicsBody = SKPhysicsBody(edgeFrom: startPoint, to: endPoint)
        physicsBody?.restitution = 0
        physicsBody?.categoryBitMask = FloorCategory //distinguishes the floor from other nodes
        
        let color = UIColor(red:0.42, green:0.80, blue:0.98, alpha:1.0)
        let skyNode = SKSpriteNode(color: color, size: CGSize(width: size.width, height: size.height))
        skyNode.size = CGSize(width: size.width, height: size.height)
        skyNode.anchorPoint = CGPoint(x: 0, y: 0)
        skyNode.position = CGPoint(x: 0, y: 0)
        //skyNode.fillColor = SKColor(red:0.15, green:0.77, blue:0.97, alpha:1.0)
        //skyNode.strokeColor = SKColor.clear
        skyNode.zPosition = 0
        
        let groundSize = CGSize(width: size.width, height: size.height * 0.25)
        let groundNode = SKShapeNode(rect: CGRect(origin: CGPoint(), size: groundSize))
        groundNode.fillColor = SKColor(red:0.2, green:0.86, blue:0.37, alpha:1.0)
        groundNode.strokeColor = SKColor.clear
        groundNode.zPosition = 1
        
        
        let dirtSize = CGSize(width: 1000, height: size.height * 0.22)
        /*
        let dirtNode = SKShapeNode(rect: CGRect(origin: CGPoint(), size: dirtSize))
        dirtNode.fillColor = SKColor(red:0.64, green:0.46, blue:0.39, alpha:1.0)
        dirtNode.strokeColor = SKColor.clear
        dirtNode.zPosition = 2
         */
        let floorSprite = SKSpriteNode(imageNamed: "floor")
        floorSprite.size = dirtSize
        floorSprite.position = CGPoint(x: 500, y: size.height * 0.11)
        floorSprite.zPosition = 2
        
        //addChild(floorSprite)
        addChild(skyNode)
        //addChild(groundNode)
        
        //let moveLeft = SKAction.moveBy(x: -(size.width), y: 0, duration: 5)
        //floorSprite.run(moveLeft)
        
    }
    
   
    
}

//
//  ComputerPlayingStartScene.swift
//  Panda Jump
//
//  Created by Jack Darnell on 3/24/17.
//  Copyright © 2017 Jack Darnell. All rights reserved.
//

//Computer should play the game first and then


//MAKE IT SO THAT NO BARRELS SPAWN
import SpriteKit


class ComputerPlayingStartScene: SKScene, SKPhysicsContactDelegate {
    
    private var lastUpdateTime : TimeInterval = 0
    private var currentBarrelSpawnTime : TimeInterval = 00
    private var barrelSpawnRate : TimeInterval = 0.5
    private let backroundNode = BackgroundNode()
    //private let hudNode = HudNode()
    private let titleNode = SKLabelNode(fontNamed: "PixelDigivolve")
    private let instructionNode = SKLabelNode(fontNamed: "PixelDigivolve")

    private var playerNode : PlayerSprite!
    
    private var playerAbleToJump = true
    
    override func sceneDidLoad() {
        self.physicsWorld.contactDelegate = self
        titleNode.text = "Panda Jump"
        titleNode.fontSize = 50
        titleNode.position = CGPoint(x: size.width / 2, y: size.height - 200)
        addChild(titleNode)
        
        instructionNode.text = "tap anywhere to jump"
        instructionNode.fontSize = 20
        instructionNode.position = CGPoint(x: size.width / 2, y: size.height - 300)
        addChild(instructionNode)
        //  hudNode.setup(size: size)
        /*
        hudNode.playButtonAction = {
            let transition = SKTransition.fade(with: UIColor.black, duration: 1)
            
            let gameScene = GameScene(size: self.size)
            gameScene.scaleMode = self.scaleMode
            
            self.view?.presentScene(gameScene, transition: transition)
            
            self.hudNode.playButtonAction = nil
        }
        */
        backroundNode.setup(size: size)
        addChild(backroundNode)
        //addChild(hudNode)
        
        var worldFrame = frame //creates frame
        worldFrame.origin.x -= 100
        worldFrame.origin.y -= 100
        worldFrame.size.height += 200
        worldFrame.size.width += 200
        
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: worldFrame)
        self.physicsBody?.categoryBitMask = WorldCategory
        spawnPlayer()
        print("scene did load")
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touchPoint = touches.first?.location(in: self)
        
        if playerAbleToJump == true {
            playerNode.jump()
        }
        if let point = touchPoint {
           // hudNode.touchBeganAtPoint(point: point)
        }
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touchPoint = touches.first?.location(in: self)
        
        if let point = touchPoint {
            //hudNode.touchMovedToPoint(point: point)
        }
        
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touchPoint = touches.first?.location(in: self)
        
        if let point = touchPoint {
            let transition = SKTransition.fade(with: UIColor.black, duration: 0.5)
            
            let gameScene = GameScene(size: self.size)
            gameScene.scaleMode = self.scaleMode
            
            self.view?.presentScene(gameScene, transition: transition)
            
            
        }
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        // Initialize _lastUpdateTime if it has not already been
        if (self.lastUpdateTime == 0) {
            self.lastUpdateTime = currentTime
        }
        
        
        
        // Calculate time since last update
        //let dt = currentTime - self.lastUpdateTime
        
        // Update the Spawn Timer
        
        let dt = currentTime - self.lastUpdateTime
        
        // Update the Spawn Timer
        currentBarrelSpawnTime += dt
        
        if currentBarrelSpawnTime > barrelSpawnRate {
            var rate = CGFloat(Float(arc4random()) / Float(UINT32_MAX))
            if rate < 0.495 {
                rate = 0.495
            }
            barrelSpawnRate = TimeInterval(rate * 1.6)
            currentBarrelSpawnTime = 0
            spawnBarrel()
        }
        
        //rint("Barrel position.x: \(barrelNode?.position.x)")
        
        if playerNode.physicsBody?.velocity.dy == 0 {
            playerAbleToJump = true
        } else {
            playerAbleToJump = false
        }
        
        
        self.lastUpdateTime = currentTime
    }
    
    
    
    
    
    func didBegin(_ contact: SKPhysicsContact) {
        //make sure to use contactBitMask on nodes so that this is triggered when they hit something
        if contact.bodyA.categoryBitMask == PlayerCategory || contact.bodyB.categoryBitMask == PlayerCategory {
            handlePlayerCollision(contact: contact)
            
            return
        }
        
        
        
        if contact.bodyA.categoryBitMask == WorldCategory {
            contact.bodyB.node?.removeFromParent()
            contact.bodyB.node?.physicsBody = nil
            contact.bodyB.node?.removeAllActions()
        } else if contact.bodyB.categoryBitMask == WorldCategory {
            contact.bodyA.node?.removeFromParent()
            contact.bodyA.node?.physicsBody = nil
            contact.bodyA.node?.removeAllActions()
        }
        
    }
    func spawnPlayer() {
        if let currentPlayer = playerNode, children.contains(currentPlayer) {
            playerNode.removeFromParent()
            playerNode.removeAllActions()
            playerNode.physicsBody = nil
        }
        //hudNode.resetPoints() //TODO PROGRAM HUDNODE.RESETPOINTS
        playerNode = PlayerSprite.newInstance()
        playerNode.position = CGPoint(x: size.width / 2, y: size.height * 0.22 + (playerNode.size.height / 2))
        
        
        addChild(playerNode)
    }
    
    
    
    private func spawnBarrel() {
        //let dirtSize = CGSize(width: size.width, height: size.height * 0.22)
        //let turn : SKAction =
        let barrelNode = BarrelSprite(imageNamed: "redCircle")
        //let scoreNode = ScoreNode()
        let xPosition = size.width + 70
        let yPosition = size.height * 0.22
        
        let scoreNodeSize = CGSize(width: 1, height: UIScreen.main.bounds.size.height)
        let scoreNode = SKNode()
        scoreNode.physicsBody = SKPhysicsBody(rectangleOf: scoreNodeSize)
        //scoreNode.fillColor = SKColor.black
        scoreNode.zPosition = 8
        //scoreNode.physicsBody = SKPhysicsBody(rectangleOf: scoreNodeSize)
        
        scoreNode.physicsBody?.allowsRotation = false
        scoreNode.physicsBody?.isDynamic = false
        scoreNode.physicsBody?.affectedByGravity = false
        scoreNode.physicsBody?.categoryBitMask = ScoreCategory
        scoreNode.physicsBody?.collisionBitMask = 0
        scoreNode.physicsBody?.contactTestBitMask = PlayerCategory
        //scoreNode.alpha = 0.0
        
        let moveLeft = SKAction.moveBy(x: -(size.width + barrelNode.size.width), y: 0, duration: 7.1)
        
        barrelNode.size = CGSize(width: 50, height: 50)
        //let circle1 = SKShapeNode(circleOfRadius: circleRadius)
        
        
        
        barrelNode.position = CGPoint(x: xPosition, y: yPosition)
        scoreNode.position = CGPoint(x: xPosition - (barrelNode.size.width), y: size.height / 2)
        
        barrelNode.physicsBody = SKPhysicsBody(circleOfRadius: barrelNode.size.width / 2)
        barrelNode.physicsBody?.isDynamic = true
        barrelNode.physicsBody?.restitution = 0 //restitution determines bounciness of the barrel
        
        
        barrelNode.zPosition = 4
        
        
        
        
        barrelNode.physicsBody?.categoryBitMask = BarrelCategory
        barrelNode.physicsBody?.contactTestBitMask = WorldCategory //TODO: add character catagory to this
        barrelNode.physicsBody?.collisionBitMask = PlayerCategory | FloorCategory
        barrelNode.physicsBody?.density = 0.5
        
        
        
        addChild(barrelNode)
        addChild(scoreNode)
        barrelNode.run(moveLeft)
        scoreNode.run(moveLeft)
    }
    
    func handlePlayerCollision(contact: SKPhysicsContact) {
        var playerBody : SKPhysicsBody
        var otherBody : SKPhysicsBody
        
        if(contact.bodyA.categoryBitMask == PlayerCategory) {
            otherBody = contact.bodyB
            playerBody = contact.bodyA
        } else {
            otherBody = contact.bodyA
            playerBody = contact.bodyB
        }
        
        
        switch otherBody.categoryBitMask {
        case BarrelCategory:
            //TODO end the game
            print("The computer touched a barrel")
            //hudNode.gameOver()
            
            //self.isPaused = true
            // let transition = SKTransition.reveal(with: .up, duration: 0.75)
            
            //let startScene = StartScene(size: self.size)
            // startScene.scaleMode = self.scaleMode
            
            //self.view?.presentScene(startScene, transition: transition)
            
            //print("the player touched a barrel")
        //fallthrough //figure out what fallthrough is
        case ScoreCategory:
            //print("The player touched the score node")
            //TODO INCREMENT SCORE
            otherBody.node?.removeFromParent()
            otherBody.node?.physicsBody = nil
            otherBody.node?.removeAllActions()
            playerNode.jump()
            //hudNode.addPoint()
            
        default: break
            
            //print("something else touched the player")
        }
        
        
    }
    
    func gameOver() {
        
    }
    
    
    
}

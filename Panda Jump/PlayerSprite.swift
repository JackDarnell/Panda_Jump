//
//  PlayerSprite.swift
//  Panda Jump
//
//  Created by Jack Darnell on 3/22/17.
//  Copyright © 2017 Jack Darnell. All rights reserved.
//

import SpriteKit

class PlayerSprite : SKSpriteNode {
    
    //private var isGameOver: Bool!
    
    private let walkingActionKey = "action_walking"
    
    //MAKE CURRENT SKIN PULL FROM THE KEYCHAIN SO IT SAVES PERSISTENTLY
    
    
    var currentSkin = skins[UserDefaults.standard.integer(forKey: currentSkinIndexKey)]
    
    let jumpSound = SKAction.playSoundFileNamed("jumping_sound.wav", waitForCompletion: false)
    
    //let jumpTexture = SKTexture(imageNamed: "jumpingPanda")
    let pandaTexture = SKTexture(imageNamed: "panda2")
    
    
    public static func newInstance() -> PlayerSprite {
        let player = PlayerSprite(imageNamed: "panda2")
        
        player.name = "PlayerSprite"
        //emitter?.emissionAngle = 0
        
        player.size = CGSize(width: 50, height: 50)
        
        player.zPosition = 6
        player.physicsBody = SKPhysicsBody(circleOfRadius: player.size.width / 2)
        player.physicsBody?.categoryBitMask = PlayerCategory
        player.physicsBody?.contactTestBitMask = BarrelCategory
        player.physicsBody?.isDynamic = true
        player.physicsBody?.restitution = 0
        player.physicsBody?.allowsRotation = false
        player.physicsBody?.contactTestBitMask = BarrelCategory | ScoreCategory
        player.physicsBody?.collisionBitMask = BarrelCategory | FloorCategory
       // player.addChild(emitter!)
        return player
    }
    
    public func update(deltaTime : TimeInterval, isNotJumping: Bool, isGameOver: Bool) {
        //self.isGameOver = isGameOver
        //print(isNotJumping)
        //timeSinceLastHit += deltaTime
        if isNotJumping == false {
            if let action = action(forKey: walkingActionKey) {
                action.speed = 0
                zRotation = CGFloat(1 * (Double.pi / 7))
                

            }
        } else {
            if isNotJumping == true {
                if let action = action(forKey: walkingActionKey) {
                    action.speed = 1
                    zRotation = 0
                }
            }
        }
        
        if action(forKey: walkingActionKey) == nil{
            zRotation = 0
            let walkingAction = SKAction.repeatForever(
                SKAction.animate(with: currentSkin.frames,
                                 timePerFrame: 0.08,
                                 resize: false,
                                 restore: true))
            
            run(walkingAction, withKey:walkingActionKey)
            
            
        }

        
    }
    
    public func jump() {
        //zRotation = CGFloat(1 * (Double.pi / 4))
        //texture = jumpTexture
        //playSound(soundVariable: jumpSound)
        print("JUMPING")
        let jump = SKAction.applyImpulse(CGVector(dx: 0.0, dy: 50.0), duration: 0.1)
        run(jump)
        
    }
    func playSound(soundVariable : SKAction)
    {
        if UserDefaults.standard.bool(forKey: MuteKey) == false {
            run(soundVariable)
            print("PLAYING SOUND AFTER JUMP")
        }
        
    }

}

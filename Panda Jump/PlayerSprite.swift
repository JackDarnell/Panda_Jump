//
//  PlayerSprite.swift
//  Panda Jump
//
//  Created by Jack Darnell on 3/22/17.
//  Copyright © 2017 Jack Darnell. All rights reserved.
//

import SpriteKit

class PlayerSprite: SKSpriteNode {

    static let nodeName = "PlayerSprite"
    private let walkingActionKey = "action_walking"
    private let skin = GameData.currentSkin

    static func newInstance() -> PlayerSprite {
        let player = PlayerSprite(imageNamed: "panda2")
        player.name = nodeName
        player.size = CGSize(width: 50, height: 50)
        player.zPosition = 6

        let body = SKPhysicsBody(circleOfRadius: player.size.width / 2)
        body.categoryBitMask = PlayerCategory
        body.contactTestBitMask = BarrelCategory | ScoreCategory
        body.collisionBitMask = BarrelCategory | FloorCategory
        body.isDynamic = true
        body.restitution = 0
        body.allowsRotation = false
        player.physicsBody = body
        return player
    }

    /// Runs the walk cycle while on the ground and tilts the player while in the air.
    func update(isOnGround: Bool) {
        if let walking = action(forKey: walkingActionKey) {
            walking.speed = isOnGround ? 1 : 0
            zRotation = isOnGround ? 0 : .pi / 7
        } else {
            zRotation = 0
            let walking = SKAction.repeatForever(
                SKAction.animate(with: skin.frames, timePerFrame: 0.08, resize: false, restore: true))
            run(walking, withKey: walkingActionKey)
        }
    }

    func jump() {
        run(SKAction.applyImpulse(CGVector(dx: 0, dy: 50), duration: 0.1))
        SoundManager.shared.play(SoundManager.jumpSound, on: self)
    }
}

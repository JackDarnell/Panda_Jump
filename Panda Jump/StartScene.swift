//
//  StartScene.swift
//  Panda Jump
//
//  Created by Jack Darnell on 3/24/17.
//  Copyright © 2017 Jack Darnell. All rights reserved.
//

import SpriteKit

class StartScene : SKScene {
    
    let startButtonTexture = SKTexture(imageNamed: "button_start")
    let startButtonPressedTexture = SKTexture(imageNamed: "button_start_pressed")
    let soundButtonTexture = SKTexture(imageNamed: "speaker_on")
    let soundButtonTextureOff = SKTexture(imageNamed: "speaker_off")
    
    let logoSprite = SKSpriteNode(imageNamed: "logo")
    var startButton : SKSpriteNode! = nil
    var soundButton : SKSpriteNode! = nil
    
    let highScoreNode = SKLabelNode(fontNamed: "PixelDigivolve")
    
    var selectedButton : SKSpriteNode?
    
    override func sceneDidLoad() {
        backgroundColor = SKColor(red:0.30, green:0.81, blue:0.89, alpha:1.0)
        
        //Set up logo - sprite initialized earlier
        logoSprite.position = CGPoint(x: size.width / 2, y: size.height / 2 + 100)
        
        //addChild(logoSprite)
        
        //Set up start button
        startButton = SKSpriteNode(texture: startButtonTexture)
        startButton.position = CGPoint(x: size.width / 2, y: size.height / 2 - startButton.size.height / 2)
        
        addChild(startButton)
        
        let edgeMargin : CGFloat = 25
        
        //Set up sound button
        soundButton = SKSpriteNode(texture: soundButtonTexture)
        soundButton.position = CGPoint(x: size.width - soundButton.size.width / 2 - edgeMargin, y: soundButton.size.height / 2 + edgeMargin)
        
        addChild(soundButton)
        
        //Set up high-score node
        let defaults = UserDefaults.standard
        
        let highScore = defaults.integer(forKey: ScoreKey)
        
        highScoreNode.text = "\(highScore)"
        highScoreNode.fontSize = 90
        highScoreNode.verticalAlignmentMode = .top
        highScoreNode.position = CGPoint(x: size.width / 2, y: startButton.position.y - startButton.size.height / 2 - 50)
        highScoreNode.zPosition = 1
        
        addChild(highScoreNode)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            if selectedButton != nil {
                handleStartButtonHover(isHovering: false)
                handleSoundButtonHover(isHovering: false)
            }
            
            // Check which button was clicked (if any)
            if startButton.contains(touch.location(in: self)) { //if the touch is in start button
                selectedButton = startButton
                handleStartButtonHover(isHovering: true)
            } else if soundButton.contains(touch.location(in: self)) { //if the touch is in the sound button
                selectedButton = soundButton
                handleSoundButtonHover(isHovering: true)
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            
            // Check which button was clicked (if any)
            if selectedButton == startButton {
                handleStartButtonHover(isHovering: (startButton.contains(touch.location(in: self))))
            } else if selectedButton == soundButton {
                handleSoundButtonHover(isHovering: (soundButton.contains(touch.location(in: self))))
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            
            if selectedButton == startButton {
                // Start button clicked
                handleStartButtonHover(isHovering: false)
                
                if (startButton.contains(touch.location(in: self))) {
                    handleStartButtonClick()
                }
                
            } else if selectedButton == soundButton {
                // Sound button clicked
                handleSoundButtonHover(isHovering: false)
                
                if (soundButton.contains(touch.location(in: self))) {
                    handleSoundButtonClick()
                }
            }
        }
        
        selectedButton = nil
    }
    
    /// Handles start button hover behavior
    func handleStartButtonHover(isHovering : Bool) {
        if isHovering {
            startButton.texture = startButtonPressedTexture
        } else {
            startButton.texture = startButtonTexture
        }
    }
    
    /// Handles sound button hover behavior
    func handleSoundButtonHover(isHovering : Bool) {
        if isHovering {
            soundButton.alpha = 0.5
        } else {
            soundButton.alpha = 1.0
        }
    }
    
    /// Stubbed out start button on click method
    func handleStartButtonClick() {
        let transition = SKTransition.reveal(with: .down, duration: 0.75)
        let gameScene = GameScene(size: size)
        gameScene.scaleMode = scaleMode
        view?.presentScene(gameScene, transition: transition)
    }
    
    /// Stubbed out sound button on click method
    func handleSoundButtonClick() {
        //if SoundManager.sharedInstance.toggleMute() {
        //Is muted
        //    soundButton.texture = soundButtonTextureOff
        //} else {
        //Is not muted
        //  soundButton.texture = soundButtonTexture
        //}
        print("Sount Button Pressed")
    }
    
}


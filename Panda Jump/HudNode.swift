//
//  HudNode.swift
//  Panda Jump
//
//  Created by Jack Darnell on 3/21/17.
//  Copyright © 2017 Jack Darnell. All rights reserved.
//

import SpriteKit

class HudNode : SKNode {
    
    private let scoreNode = SKLabelNode(fontNamed: "PixelDigivolve") //TODO import pixel digivolve font into assets
    private let coinsNode = SKLabelNode(fontNamed: "PixelDigivolve")
    private(set) var score : Int = 0
    private var highScore : Int = 0
    private var showingHighScore = false
    //private var playNode = SKLabelNode(fontNamed: "PixelDigivolve")
    private var playNode = SKSpriteNode(imageNamed: "png_play_button")
    private var checkLeaderboardNode = SKSpriteNode(imageNamed: "png_leaderboards_button")
    private var customizeNode = SKSpriteNode(imageNamed: "png_customize_button")
    //private var checkLeaderboardNode = SKLabelNode(fontNamed: "PixelDigivolve")
    private var leaderboardsNode : SKSpriteNode!
    private var leaderBoardNode : SKSpriteNode!
    private var gameOverNode = SKLabelNode(fontNamed: "PixelDigivolve")
    private var bestScoreNode = SKLabelNode(fontNamed: "PixelDigivolve")
    private var finishedScoreNode = SKLabelNode(fontNamed: "PixelDigivolve")
    private var emojiRewardNode = SKLabelNode()
    //private var muteButtonNode = SKSpriteNode(imageNamed: ")
    var gameIsOver: Bool!
    var playButtonAction : (() -> ())?
    var checkLeaderboardAction : (() -> ())?
    let emitter = SKEmitterNode(fileNamed: "fire.sks")
    let GameVC = GameViewController()

    let soundButtonTexture = SKTexture(imageNamed: "speaker_on")
    let soundButtonTextureOff = SKTexture(imageNamed: "speaker_off")
    var soundButton : SKSpriteNode! = nil
    //var coinSound = NSURL(fileURLWithPath:Bundle.mainBundle().pathForResource("coinSound", ofType: "wav")!)
    let coinSound = SKAction.playSoundFileNamed("coinSound.wav", waitForCompletion: false)
    //let jumpSound = SKAction.playSoundFileNamed("jumping_sound.wav", waitForCompletion: false)
    //TODO: GET BROWN BACKROUND ASSET WITH MEDAL SCORE AND BEST FROM ALEX OR MAKE IT MYSELF
    
    
    public func setup(size: CGSize) {
        let defaults = UserDefaults.standard
        removeAllChildren()
        gameIsOver = false
        //defaults.set(3000, forKey: CoinsKey)
        highScore = defaults.integer(forKey: ScoreKey)
        coinsNode.text = "\(defaults.integer(forKey: CoinsKey))ƒ"
        gameOverNode.text = "Game Over"
        scoreNode.name = "ScoreNode"
        //playNode.text = "Play Again"
        //checkLeaderboardNode.text = "Leaderboard"
        //playNode!.isHidden = false
        
        //THESE FIX THE USABLE INVISIBLE BUTTONS
        
        gameOverNode.position = CGPoint(x: UIScreen.main.bounds.size.width / 2, y: UIScreen.main.bounds.size.height + 100)
        bestScoreNode.position = CGPoint(x: UIScreen.main.bounds.size.width / 2, y: UIScreen.main.bounds.size.height + 75)
        playNode.position = CGPoint(x: UIScreen.main.bounds.size.width * 2 + playNode.size.width + 10, y: UIScreen.main.bounds.size.height - 400)
        checkLeaderboardNode.position = CGPoint(x: UIScreen.main.bounds.size.width * 2, y: UIScreen.main.bounds.size.height - 400)
        customizeNode.position = CGPoint(x: UIScreen.main.bounds.size.width * 40 - customizeNode.size.width - 10, y: UIScreen.main.bounds.size.height - 400)
        
 
        //END OF BUTTONS GLITCH FIX
        
        customizeNode.zPosition = 10
        checkLeaderboardNode.zPosition = 10
        
        coinsNode.zPosition = 10
        coinsNode.fontSize = 25
        coinsNode.fontColor = SKColor(red:0.99, green:0.92, blue:0.55, alpha:1.0)
        coinsNode.position = CGPoint(x: UIScreen.main.bounds.size.width - coinsNode.frame.width, y: UIScreen.main.bounds.size.height - 75)
        
        scoreNode.text = "\(score)"
        //scoreNode.fontColor = UIColor.darkText
        scoreNode.fontSize = 70
        scoreNode.position = CGPoint(x: size.width / 2, y: size.height - 150)
        scoreNode.zPosition = 10
                //emitter?.xAcceleration = -500
        soundButton = SKSpriteNode(texture: SoundManager.sharedInstance.isMuted ?
            soundButtonTextureOff : self.soundButtonTexture)
        
        soundButton.zPosition = 20
        soundButton.position = CGPoint(x: UIScreen.main.bounds.size.width * 4, y: UIScreen.main.bounds.size.width * 2)
        
        addChild(soundButton)
        addChild(scoreNode)
        addChild(coinsNode)
        //scoreNode.addChild(emitter!)
        
    }
    
    public func addPoint() {
        score += 1
        //print(highScore)
        emitter?.particleScale = 0.2
        emitter?.targetNode = scoreNode
        emitter?.particleColor = UIColor.purple
                //emitter?.particleSize = CGSize(width: 40.1, height: 40.1)
        //emitter?.run(SKAction.fadeOut(withDuration: 1))
        //if score % 10 == 0 {
            var coins = UserDefaults.standard.integer(forKey: CoinsKey)
            coins += 1
            UserDefaults.standard.set(coins, forKey: CoinsKey)
          
            
        //} else {
            //make coin sound
            //run(SKAction.playSoundFileNamed("coinSound.wav", waitForCompletion: false))
        
        playSound(soundVariable: coinSound)
       
        
        
        //}
        
        updateScoreboard()
        
        
    //UserDefaults.standard.set(0, forKey: ScoreKey)
        
        if score > highScore {
            
            highScore = score
            let defaults = UserDefaults.standard
            
            defaults.set(score, forKey: ScoreKey)
            
            
            //MAKE SURE THIS CODE IS EFFICIENT:
            
            GameVC.uploadHighScore(score: highScore)
            //MAKE SURE CODE ABOVE IS EFFICIENT
            
            /* I think this code adds the flames when you get a highscore, cant be sure though lol
            if scoreNode.children.contains(emitter!) == false {
                scoreNode.addChild(emitter!)
            }
            */
           // print(defaults.integer(forKey: scoreKey))
            //print("\(score)")
            
            if !showingHighScore {
                showingHighScore = true
                
                scoreNode.run(SKAction.scale(to: 1.5, duration: 0.25))
                scoreNode.fontColor = UIColor(red:0.87, green:0.89, blue:0.29, alpha:1.0)//SKColor(red:0.99, green:0.92, blue:0.55, alpha:1.0)
            }
        }
    }

    public func resetPoints() {
        score = 0
        
        updateScoreboard()
        
        if showingHighScore {
            showingHighScore = false
            scoreNode.removeAllChildren()
            scoreNode.run(SKAction.scale(to: 0.75, duration: 0.25))
            scoreNode.fontColor = SKColor.white
        }
    }
    
    /// Updates the score label to show the current score.
    private func updateScoreboard() {
        coinsNode.text = "\(UserDefaults.standard.integer(forKey: CoinsKey))ƒ"
        scoreNode.text = "\(score)"
        //print("\(score)")
    }
    
    func touchBeganAtPoint(point: CGPoint) {
        if soundButton.contains(point) {
            handleSoundButtonHover(isHovering: true)
        }
    }
    
    func touchMovedToPoint(point: CGPoint) {
        if soundButton.contains(point) {
            handleSoundButtonHover(isHovering: true)
        }
    }
    
    func touchEndedAtPoint(point: CGPoint) {
        
        
        if playNode.contains(point) {
            if playNode.contains(point) && playButtonAction != nil {
                playButtonAction!()
            }
        } 
        
        
        if checkLeaderboardNode.contains(point) {
            GameVC.checkLeaderboard()
        }
        
        if customizeNode.contains(point) {
            GameVC.goToCustomizeVC()
        }
        
        if soundButton.contains(point) {
            handleSoundButtonClick()
        }
    }

    
    public func gameOver() {
        
        let movePlayNode = SKAction.move(to: CGPoint(x: UIScreen.main.bounds.size.width / 2 + playNode.size.width + 15, y: 285), duration: 0.5)
        let moveCheckLeaderboardsNode = SKAction.move(to: CGPoint(x: UIScreen.main.bounds.size.width / 2, y: 285), duration: 0.5)
        let moveCustomizeNode = SKAction.move(to: CGPoint(x: UIScreen.main.bounds.size.width / 2 - playNode.size.width - 15, y: 285), duration: 0.5)
        let moveScoreNode = SKAction.move(to: CGPoint(x: UIScreen.main.bounds.size.width / 2, y: 365), duration: 0.5)
        let moveGameOverNode = SKAction.move(to: CGPoint(x: UIScreen.main.bounds.size.width / 2, y: 485), duration: 0.5)
        let moveBestScoreNode = SKAction.move(to: CGPoint(x: UIScreen.main.bounds.size.width / 2, y: 450), duration: 0.5)
        
        if showingHighScore == true {
            scoreNode.fontColor = SKColor(red:0.99, green:0.92, blue:0.55, alpha:1.0)
        }
        scoreNode.removeAllChildren()
        gameIsOver = true
        gameOverNode.text = "Game Over"
        //playNode.text = "Play Again"
        
        playNode.isPaused = false
        bestScoreNode.text = "Best: \(highScore)"
        bestScoreNode.fontSize = 20
        //playNode.position = CGPoint(x: UIScreen.main.bounds.size.width / 2, y: UIScreen.main.bounds.size.height - 325)
        //gameOverNode.position = CGPoint(x: UIScreen.main.bounds.size.width / 2, y: UIScreen.main.bounds.size.height - 150)
        //playNode.position = CGPoint(x: UIScreen.main.bounds.size.width / 2, y: UIScreen.main.bounds.size.height - 300)
        
        //playNode.fontColor = SKColor(red:0.99, green:0.92, blue:0.55, alpha:1.0)
        bestScoreNode.zPosition = 9
        playNode.zPosition = 9
        playNode.size = CGSize(width: 70, height: 70)
        checkLeaderboardNode.size = CGSize(width: 70, height: 70)
        customizeNode.size = CGSize(width: 70, height: 70)
        //checkLeaderboardNode.fontSize = 25
        //checkLeaderboardNode.fontColor = SKColor(red:0.99, green:0.92, blue:0.55, alpha:1.0)
        //gameOverNode.position = CGPoint(x: UIScreen.main.bounds.size.width / 2, y: 485)
        //bestScoreNode.position = CGPoint(x: UIScreen.main.bounds.size.width / 2, y: gameOverNode.position.y - 25)
        playNode.position = CGPoint(x: UIScreen.main.bounds.size.width / 2 + playNode.size.width + 10, y: 0 - playNode.size.height * 2)
        //playNode.position = CGPoint(x: UIScreen.main.bounds.size.width / 2 + playNode.size.width + 10, y: 250)
        checkLeaderboardNode.position = CGPoint(x: UIScreen.main.bounds.size.width / 2, y: 0 - checkLeaderboardNode.size.height * 2)
        customizeNode.position = CGPoint(x: UIScreen.main.bounds.size.width / 2 - customizeNode.size.width, y: 0 - checkLeaderboardNode.size.height * 2)
        //customizeNode.position = CGPoint(x: UIScreen.main.bounds.size.width / 2 - customizeNode.size.width - 10, y: 0 - customizeNode.size.height * 2)
        soundButton.position = CGPoint(x: UIScreen.main.bounds.size.width - soundButton.size.width, y: soundButton.size.height)
        
        
        
        
        addChild(gameOverNode)
        addChild(playNode)
        addChild(bestScoreNode)
        addChild(checkLeaderboardNode)
        addChild(customizeNode)
        playNode.run(movePlayNode)
        checkLeaderboardNode.run(moveCheckLeaderboardsNode)
        customizeNode.run(moveCustomizeNode)
        scoreNode.run(moveScoreNode)
        gameOverNode.run(moveGameOverNode)
        bestScoreNode.run(moveBestScoreNode)
        //emitter?.run(SKAction.fadeOut(withDuration: 1))
        //emitter?.isPaused = false
    }
    
    public func hideScoreNode() {
        scoreNode.isHidden = true
    }
    public func unHideScoreNode() {
        scoreNode.isHidden = false
    }
    public func getIfGameIsOver() -> Bool {
        return gameIsOver
    }
    
    func playSound(soundVariable : SKAction)
    {
        if UserDefaults.standard.bool(forKey: MuteKey) == false {
            run(soundVariable)
        }
        
    }
    
    func handleSoundButtonHover(isHovering : Bool) {
        if isHovering {
            soundButton.alpha = 0.5
        } else {
            soundButton.alpha = 1.0
        }
    }
    
    func handleSoundButtonClick() {
        if SoundManager.sharedInstance.toggleMute() {
            //Is muted
            soundButton.texture = soundButtonTextureOff
        } else {
            //Is not muted
            soundButton.texture = soundButtonTexture
        }
    }
}

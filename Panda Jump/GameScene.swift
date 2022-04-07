//
//  GameScene.swift
//  Panda Jump
//
//  Created by Jack Darnell on 3/20/17.
//  Copyright © 2017 Jack Darnell. All rights reserved.
//
//HAVE PANDA RUNNING BUT NO BARRELS SPAWNING AND WHEN YOU TAP THE SCREEN IT WILL JUMP TO SHOW YOU HOW TO PLAY AND THEN BARRELS WILL START SPAWNING
//THEN THERE WILL BE NO START SCENE
//

import SpriteKit
import GoogleMobileAds
import GameKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var viewController: GameViewController!
    var bannerView: GADBannerView!
    private var lastUpdateTime : TimeInterval = 0
    private var currentBarrelSpawnTime : TimeInterval = 00
    private var barrelSpawnRate : TimeInterval = 0.5
    private let backroundNode = BackgroundNode()
    private let hudNode = HudNode()
    private var floorSprite : FloorSprite!
    private var floorSprite1 : FloorSprite!
    private var playerNode : PlayerSprite!
    private var gameStarted = false
    private let titleNode = SKLabelNode(fontNamed: "PixelDigivolve")
    private let instructionNode = SKLabelNode(fontNamed: "PixelDigivolve")
    private let positiveReinforcmentNode = SKLabelNode(fontNamed: "PixelDigivolve")
    private let positiveReinforcementArray = ["Great Job!", "Keep It Up!", "Way to Go!", "Wow", "Quise", "Good Work!", "Groovy", "Perservere!", "Impressive", "10/10 IGN", "Tuff", "Lit", "Ballin", "Savage", "Swish", "Swagtastic", "Supercilious", "Flip that", "Next Level", "Lotion", "CHIEF KEEF", "Gucci Gang", "navuzimetro", "Love Sosa", "I dont want friends I want Audi's", "D Rose D Rose D Rose", "Craaazzy Gooood!!", "Ricktacular", "^_^", "Does Starbucks Deliver?", "Live Más"]
    private var gameRunning = true
    private let coinSound = SKAudioNode(fileNamed: "coinSound.mp3")
    let jumpSound = SKAction.playSoundFileNamed("jumping_sound.wav", waitForCompletion: false)
    //let characterDyingAction = SKAction.moveBy(x: -30, y: 20, duration: 0.2)
    let goToGround = SKAction.move(to: CGPoint(x: (UIScreen.main.bounds.size.width / 2) - 40, y: UIScreen.main.bounds.size.height * 0.25), duration: 0.2)
    let rotateCharacterAction = SKAction.rotate(byAngle: 90, duration: 0.2)
    var combinedActions : SKAction!
    //let soundButtonTexture = SKTexture(imageNamed: "speaker_on")
    //let soundButtonTextureOff = SKTexture(imageNamed: "speaker_off")
    //var soundButton : SKSpriteNode! = nil
    //private let highScoreNode = SKLabelNode(fontNamed: "PixelDigivolve")
    
    private var playerAbleToJump = true
   
    override func sceneDidLoad() {
        self.physicsWorld.contactDelegate = self
        gameRunning = true
        hudNode.setup(size: size)
        hudNode.playButtonAction = {
            let transition = SKTransition.fade(with: UIColor.black, duration: 0.5)
            
            let gameScene = GameScene(size: self.size)
            gameScene.scaleMode = self.scaleMode
            
            self.view?.presentScene(gameScene, transition: transition)
            
            self.hudNode.playButtonAction = nil
            
            
        }
        combinedActions = SKAction.group([goToGround, rotateCharacterAction])
        
        /*
        soundButton = SKSpriteNode(texture: SoundManager.sharedInstance.isMuted ?
            soundButtonTextureOff : self.soundButtonTexture)
        soundButton.position = CGPoint(x: self.size.width - soundButton.size.width, y: soundButton.size.height)
        soundButton.zPosition = 20
        
        addChild(soundButton)
        */
        titleNode.text = "Panda Jump"
        //titleNode.fontColor = UIColor.green
        titleNode.zPosition = 5
        titleNode.fontSize = 50
        titleNode.position = CGPoint(x: size.width / 2, y: size.height - 200)
        addChild(titleNode)
        
        instructionNode.text = "tap anywhere to jump"
        instructionNode.fontSize = 20
        instructionNode.position = CGPoint(x: size.width / 2, y: size.height - 300)
        addChild(instructionNode)

        
        backroundNode.setup(size: size)
        //floorSprite.position = CGPoint(x: 0, y: 0)
        floorSprite = FloorSprite.newInstance()
        floorSprite1 = FloorSprite.newInstance()
        floorSprite1.position = CGPoint(x: floorSprite1.size.width - 10, y: 0)
        /*
        for i in 0 ... 1 {
            floorSprite.position = CGPoint(x: (floorSprite.size.width * CGFloat(i)) - CGFloat(1 * i), y: 100)
            addChild(floorSprite)
        }
 */
        addChild(floorSprite1)
        addChild(floorSprite)
        let moveLeft = SKAction.moveBy(x: -floorSprite.size.width, y: 0, duration: 5.129)
        let moveReset = SKAction.moveBy(x: floorSprite.size.width, y: 0, duration: 0)
        let moveLoop = SKAction.sequence([moveLeft, moveReset])
        let moveForever = SKAction.repeatForever(moveLoop)
        
        floorSprite.run(moveForever)
        floorSprite1.run(moveForever)
            
        addChild(backroundNode)
        addChild(hudNode)
        hudNode.hideScoreNode()
        
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
        gameStarted = true
        titleNode.isHidden = true
        instructionNode.isHidden = true
        hudNode.unHideScoreNode()
        
        if playerAbleToJump == true {
            playerNode.jump()
        }
        
        
        if let point = touchPoint {
            hudNode.touchBeganAtPoint(point: point)
        }

    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touchPoint = touches.first?.location(in: self)
        
        
        
        if let point = touchPoint {
            hudNode.touchMovedToPoint(point: point)
        }

        

        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touchPoint = touches.first?.location(in: self)
        
        
        
        if let point = touchPoint {
            hudNode.touchEndedAtPoint(point: point)
        }
        
        
        
       

        
    }
    
    override func didMove(to view: SKView) {
        if bannerView == nil {
            initializeBanner()
        }
        loadRequest()
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        // Initialize _lastUpdateTime if it has not already been
        if (self.lastUpdateTime == 0) {
            self.lastUpdateTime = currentTime
        }
        let dt = currentTime - self.lastUpdateTime
        
        // Update the Spawn Timer
        if gameStarted == true {
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
        
        }
        
        
        //floorSprite.update(delta: dt)
        
        if playerNode.physicsBody?.velocity.dy == 0 {
            playerAbleToJump = true
            
        } else {
            playerAbleToJump = false
        }

        playerNode.update(deltaTime: dt, isNotJumping: playerAbleToJump, isGameOver: hudNode.gameIsOver)

        
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
        
        if gameRunning == true {
            let barrelNode: SKSpriteNode// = SKSpriteNode(imageNamed: "ball")
            
            if skins[UserDefaults.standard.integer(forKey: currentSkinIndexKey)].name == devSkin.name {
                barrelNode = SKSpriteNode(imageNamed: "redCircle")
            } else {
                barrelNode = SKSpriteNode(imageNamed: "ball")
            }
            //let barrelNode = SKSpriteNode(imageNamed: "ball")
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
            
            //original 7.2
            //print(barrelNode.size.width)
            if skins[UserDefaults.standard.integer(forKey: currentSkinIndexKey)].name == devSkin.name {
                barrelNode.size = CGSize(width: 50, height: 50)
            } else {
                barrelNode.size = CGSize(width: 54, height: 54)
            }
            //barrelNode.size = CGSize(width: 54, height: 54)
            //let circle1 = SKShapeNode(circleOfRadius: circleRadius)
            let moveLeft = SKAction.moveBy(x: -(size.width + 1000), y: 0, duration: 7.2)
            
            barrelNode.position = CGPoint(x: xPosition, y: yPosition)
            scoreNode.position = CGPoint(x: xPosition + (barrelNode.size.width * 1.5), y: size.height / 2)
            
            barrelNode.physicsBody = SKPhysicsBody(circleOfRadius: 48 / 2)
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
            floorSprite.isPaused = true
            floorSprite1.isPaused = true
            for child in self.children {
                print(child)
                //child.isPaused = true
                if child.position.x > -500 && child.position.x < size.width + 500 && child.position.y > 0 && child.position.y < size.height && child.name != "PlayerSprite" && child.name != "ScoreNode"{
                    
                    child.isPaused = true
                    
                } else if child.name == "PlayerSprite" {
                    print("RUNNING DYING ACTION")
                    //let die = SKAction.applyImpulse(CGVector(dx: -20.0, dy: 10.0), duration: 0.1)
                    //child.removeAllActions()
                    child.isPaused = true
                    //child.run(combinedActions)
                    //child.run(die)
                    //child.physicsBody?.applyForce(CGVector(dx: -300, dy: 300))
                } else if child.name == "ScoreNode" {
                    print("FOUND SCORE NODE")
                }
            }
            gameRunning = false
            hudNode.gameOver()
            positiveReinforcmentNode.removeFromParent()
            scene?.physicsWorld.speed = 0
            
            //self.isPaused = true
            //playerNode.isPaused = true
            
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
            hudNode.addPoint()
            //positiveReinforcmentNode.text = positiveReinforcementArray[4]
            positiveReinforcmentNode.text = positiveReinforcementArray[Int(arc4random_uniform(UInt32(positiveReinforcementArray.count)))]
            positiveReinforcmentNode.position = CGPoint(x: CGFloat(arc4random_uniform(UInt32(size.width / 2)) + UInt32(size.width / 4)), y: CGFloat(arc4random_uniform(UInt32(size.height / 2)) + UInt32(size.height / 4)))
            positiveReinforcmentNode.zPosition = 20
            positiveReinforcmentNode.fontSize = 20
            //let color = randomColor()//UIColor.init(red: CGFloat(arc4random_uniform(100)), green: CGFloat(arc4random_uniform(100)), blue: CGFloat(arc4random_uniform(100)), alpha: 0)
            positiveReinforcmentNode.fontColor = randomColor()//SKColor(red:0.99, green:0.92, blue:0.55, alpha:1.0)
            let fade = SKAction.fadeAlpha(to: 1, duration: 0.6)
            addChild(positiveReinforcmentNode)
            positiveReinforcmentNode.run(fade,
                completion: {
                    self.positiveReinforcmentNode.removeFromParent()
                }
            )
            
            
        default: break
            
            //print("something else touched the player")
        }

        
    }
    
    func gameOver() {
        gameRunning = false
        //playerNode.isPaused = true
        
    }
    
    func randomColor() -> SKColor{
        let blue = SKColor.blue
        let red = SKColor.red
        let green = SKColor.green
        let yellow = SKColor.yellow
        let colors = [blue, red, green, yellow]
        let color = colors[Int(arc4random_uniform(UInt32(colors.count)))]
        return color
    }
    
    func initializeBanner() {
        // Create a banner ad and add it to the view hierarchy.
        bannerView = GADBannerView(adSize: kGADAdSizeSmartBannerPortrait)
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        bannerView.rootViewController = viewController
        bannerView.frame = CGRect(x: 0, y: 0, width: size.width, height: 50)
        bannerView.clipsToBounds = true
        
        view!.addSubview(bannerView)
    }
    func loadRequest() {
        let request = GADRequest()
        //request.testDevices = [kGADSimulatorID, "22ed9df524b90565f5e15t23ad232415"]
        bannerView.load(request)
    }
    
    func playSound(soundVariable : SKAction)
    {
        if UserDefaults.standard.bool(forKey: MuteKey) == false {
            run(soundVariable)
        }
        
    }
    
   
}


    
    


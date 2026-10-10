//
//  GameScene.swift
//  Panda Jump
//
//  Created by Jack Darnell on 3/20/17.
//  Copyright © 2017 Jack Darnell. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {

    weak var gameViewController: GameViewController?

    /// Space at the top taken by the notch and the banner ad.
    var topInset: CGFloat = 0
    /// Space at the bottom taken by the home indicator.
    var bottomInset: CGFloat = 0

    private static let barrelName = "barrel"
    private static let scoreGateName = "scoreGate"

    private var lastUpdateTime: TimeInterval = 0
    private var currentBarrelSpawnTime: TimeInterval = 0
    private var barrelSpawnRate: TimeInterval = 0.5
    private let backgroundNode = BackgroundNode()
    private let hudNode = HudNode()
    private var floorSprites: [FloorSprite] = []
    private var playerNode: PlayerSprite!
    private var gameStarted = false
    private var gameRunning = true
    private let titleNode = SKLabelNode(fontNamed: PixelFontName)
    private let instructionNode = SKLabelNode(fontNamed: PixelFontName)
    private let positiveReinforcementNode = SKLabelNode(fontNamed: PixelFontName)
    private let positiveReinforcementArray = ["Great Job!", "Keep It Up!", "Way to Go!", "Wow", "Quise", "Good Work!", "Groovy", "Persevere!", "Impressive", "10/10 IGN", "Tuff", "Lit", "Ballin", "Savage", "Swish", "Swagtastic", "Supercilious", "Flip that", "Next Level", "navuzimetro", "I dont want friends I want Audi's", "D Rose D Rose D Rose", "Craaazzy Gooood!!", "Ricktacular", "^_^", "Does Starbucks Deliver?", "Live Más"]
    private let reinforcementColors: [SKColor] = [.blue, .red, .green, .yellow]

    // Built in didMove(to:) rather than sceneDidLoad() so the safe-area insets are known.
    private var isSetUp = false

    override func didMove(to view: SKView) {
        guard !isSetUp else { return }
        isSetUp = true

        physicsWorld.contactDelegate = self

        hudNode.setup(size: size, topInset: topInset, bottomInset: bottomInset)
        hudNode.playButtonAction = { [weak self] in self?.gameViewController?.startNewGame() }
        hudNode.leaderboardAction = { [weak self] in self?.gameViewController?.showLeaderboard() }
        hudNode.customizeAction = { [weak self] in self?.gameViewController?.showCustomize() }
        hudNode.setScoreHidden(true)

        titleNode.text = "Panda Jump"
        titleNode.fontSize = 50
        titleNode.zPosition = 5
        titleNode.position = CGPoint(x: size.width / 2, y: size.height * 0.70)
        addChild(titleNode)

        instructionNode.text = "tap anywhere to jump"
        instructionNode.fontSize = 20
        instructionNode.zPosition = 5
        instructionNode.position = CGPoint(x: size.width / 2, y: size.height * 0.55)
        addChild(instructionNode)

        positiveReinforcementNode.fontSize = 20
        positiveReinforcementNode.zPosition = 20

        backgroundNode.setup(size: size)

        // Two floor tiles spaced exactly one tile apart, so the seam stays invisible as they wrap.
        let floor = FloorSprite.newInstance(sceneSize: size)
        let floor1 = FloorSprite.newInstance(sceneSize: size)
        floor1.position = CGPoint(x: FloorSprite.tileWidth, y: 0)
        let scrollDuration = TimeInterval(FloorSprite.tileWidth / ScrollSpeed)
        let moveLeft = SKAction.moveBy(x: -FloorSprite.tileWidth, y: 0, duration: scrollDuration)
        let moveReset = SKAction.moveBy(x: FloorSprite.tileWidth, y: 0, duration: 0)
        let moveForever = SKAction.repeatForever(SKAction.sequence([moveLeft, moveReset]))
        floorSprites = [floor, floor1]
        for sprite in floorSprites {
            addChild(sprite)
            sprite.run(moveForever)
        }

        addChild(backgroundNode)
        addChild(hudNode)

        // Boulders that touch this edge (100pt outside the screen) get removed.
        let worldFrame = frame.insetBy(dx: -100, dy: -100)
        physicsBody = SKPhysicsBody(edgeLoopFrom: worldFrame)
        physicsBody?.categoryBitMask = WorldCategory

        spawnPlayer()
    }

    // MARK: - Touches

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let point = touches.first?.location(in: self) else { return }

        if gameRunning {
            if !gameStarted {
                gameStarted = true
                titleNode.isHidden = true
                instructionNode.isHidden = true
                hudNode.setScoreHidden(false)
            }
            if isPlayerOnGround {
                playerNode.jump()
            }
        }
        hudNode.touchBegan(at: point)
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let point = touches.first?.location(in: self) else { return }
        hudNode.touchMoved(to: point)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let point = touches.first?.location(in: self) else { return }
        hudNode.touchEnded(at: point)
    }

    // MARK: - Game loop

    private var isPlayerOnGround: Bool {
        playerNode.physicsBody?.velocity.dy == 0
    }

    override func update(_ currentTime: TimeInterval) {
        if lastUpdateTime == 0 {
            lastUpdateTime = currentTime
        }
        // Clamp so coming back from the background doesn't count as one giant frame.
        let dt = min(currentTime - lastUpdateTime, 1.0 / 15.0)
        lastUpdateTime = currentTime

        if gameStarted && gameRunning {
            currentBarrelSpawnTime += dt
            if currentBarrelSpawnTime > barrelSpawnRate {
                barrelSpawnRate = max(Double.random(in: 0...1), 0.495) * 1.6
                currentBarrelSpawnTime = 0
                spawnBarrel()
            }
        }

        playerNode.update(isOnGround: isPlayerOnGround)
    }

    // MARK: - Spawning

    private func spawnPlayer() {
        playerNode = PlayerSprite.newInstance()
        playerNode.position = CGPoint(x: size.width / 2, y: size.height * 0.22 + playerNode.size.height / 2)
        addChild(playerNode)
    }

    private func spawnBarrel() {
        let isDev = GameData.isDevSkinEquipped
        let barrelNode = SKSpriteNode(imageNamed: isDev ? "redCircle" : "ball")
        barrelNode.name = GameScene.barrelName
        barrelNode.size = isDev ? CGSize(width: 50, height: 50) : CGSize(width: 54, height: 54)
        barrelNode.zPosition = 4

        let xPosition = size.width + 70
        barrelNode.position = CGPoint(x: xPosition, y: size.height * 0.22)

        let barrelBody = SKPhysicsBody(circleOfRadius: 24)
        barrelBody.isDynamic = true
        barrelBody.restitution = 0
        barrelBody.density = 0.5
        barrelBody.categoryBitMask = BarrelCategory
        barrelBody.contactTestBitMask = WorldCategory
        barrelBody.collisionBitMask = PlayerCategory | FloorCategory
        barrelNode.physicsBody = barrelBody

        // An invisible vertical line just behind the boulder; the player scores by touching it.
        let scoreGate = SKNode()
        scoreGate.name = GameScene.scoreGateName
        scoreGate.position = CGPoint(x: xPosition + barrelNode.size.width * 1.5, y: size.height / 2)
        let gateBody = SKPhysicsBody(rectangleOf: CGSize(width: 1, height: size.height))
        gateBody.isDynamic = false
        gateBody.affectedByGravity = false
        gateBody.allowsRotation = false
        gateBody.categoryBitMask = ScoreCategory
        gateBody.collisionBitMask = 0
        gateBody.contactTestBitMask = PlayerCategory
        scoreGate.physicsBody = gateBody

        // The gate is static, so it can't hit the world edge; remove it once its move finishes.
        let travel = size.width + 1000
        let moveLeft = SKAction.moveBy(x: -travel, y: 0, duration: TimeInterval(travel / ScrollSpeed))
        addChild(barrelNode)
        addChild(scoreGate)
        barrelNode.run(moveLeft)
        scoreGate.run(SKAction.sequence([moveLeft, .removeFromParent()]))
    }

    // MARK: - Physics contacts

    func didBegin(_ contact: SKPhysicsContact) {
        if contact.bodyA.categoryBitMask == PlayerCategory || contact.bodyB.categoryBitMask == PlayerCategory {
            let otherBody = contact.bodyA.categoryBitMask == PlayerCategory ? contact.bodyB : contact.bodyA
            handlePlayerCollision(with: otherBody)
            return
        }

        // A boulder reached the edge of the world: clean it up.
        let otherBody: SKPhysicsBody?
        if contact.bodyA.categoryBitMask == WorldCategory {
            otherBody = contact.bodyB
        } else if contact.bodyB.categoryBitMask == WorldCategory {
            otherBody = contact.bodyA
        } else {
            otherBody = nil
        }
        otherBody?.node?.removeAllActions()
        otherBody?.node?.removeFromParent()
    }

    private func handlePlayerCollision(with otherBody: SKPhysicsBody) {
        // Several contacts can arrive in one frame; only react while the game is running.
        guard gameRunning else { return }

        switch otherBody.categoryBitMask {
        case BarrelCategory:
            endGame()
        case ScoreCategory:
            otherBody.node?.removeAllActions()
            otherBody.node?.removeFromParent()
            hudNode.addPoint()
            showPositiveReinforcement()
        default:
            break
        }
    }

    private func showPositiveReinforcement() {
        // Reset first: adding a node that already has a parent crashes.
        positiveReinforcementNode.removeAllActions()
        positiveReinforcementNode.removeFromParent()

        positiveReinforcementNode.text = positiveReinforcementArray.randomElement()
        positiveReinforcementNode.fontColor = reinforcementColors.randomElement()
        positiveReinforcementNode.position = CGPoint(x: CGFloat.random(in: size.width / 4...size.width * 3 / 4),
                                                     y: CGFloat.random(in: size.height / 4...size.height * 3 / 4))
        positiveReinforcementNode.alpha = 1
        addChild(positiveReinforcementNode)
        positiveReinforcementNode.run(SKAction.sequence([
            .wait(forDuration: 0.3),
            .fadeOut(withDuration: 0.3),
            .removeFromParent()
        ]))
    }

    private func endGame() {
        gameRunning = false
        physicsWorld.speed = 0

        floorSprites.forEach { $0.isPaused = true }
        playerNode.isPaused = true
        enumerateChildNodes(withName: GameScene.barrelName) { node, _ in node.isPaused = true }
        enumerateChildNodes(withName: GameScene.scoreGateName) { node, _ in node.isPaused = true }
        positiveReinforcementNode.removeAllActions()
        positiveReinforcementNode.removeFromParent()

        hudNode.gameOver()
        if hudNode.isNewHighScore {
            gameViewController?.submitHighScore(hudNode.score)
        }
    }
}

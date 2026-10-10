//
//  HudNode.swift
//  Panda Jump
//
//  Created by Jack Darnell on 3/21/17.
//  Copyright © 2017 Jack Darnell. All rights reserved.
//

import SpriteKit

class HudNode: SKNode {

    private let scoreNode = SKLabelNode(fontNamed: PixelFontName)
    private let coinsNode = SKLabelNode(fontNamed: PixelFontName)
    private let gameOverNode = SKLabelNode(fontNamed: PixelFontName)
    private let bestScoreNode = SKLabelNode(fontNamed: PixelFontName)
    private let playNode = SKSpriteNode(imageNamed: "png_play_button")
    private let leaderboardNode = SKSpriteNode(imageNamed: "png_leaderboards_button")
    private let customizeNode = SKSpriteNode(imageNamed: "png_customize_button")
    private var musicButton: ToggleButtonNode!
    private var soundEffectsButton: ToggleButtonNode!
    /// Left-to-right order, which the bottom-right layout reverses.
    private var audioButtons: [ToggleButtonNode] { [musicButton, soundEffectsButton] }

    private(set) var score = 0
    private(set) var isNewHighScore = false
    private(set) var gameIsOver = false
    private var highScore = 0
    private var size = CGSize.zero
    private var bottomInset: CGFloat = 0

    var playButtonAction: (() -> Void)?
    var leaderboardAction: (() -> Void)?
    var customizeAction: (() -> Void)?

    /// `topInset` is the space taken by the notch and the banner ad; `bottomInset` is the home indicator.
    func setup(size: CGSize, topInset: CGFloat, bottomInset: CGFloat) {
        removeAllChildren()
        self.size = size
        self.bottomInset = bottomInset
        highScore = GameData.highScore
        let topY = size.height - topInset

        coinsNode.fontSize = 25
        coinsNode.fontColor = CoinColor
        coinsNode.horizontalAlignmentMode = .right
        coinsNode.position = CGPoint(x: size.width - 16, y: topY - 40)
        coinsNode.zPosition = 10

        scoreNode.fontSize = 70
        scoreNode.position = CGPoint(x: size.width / 2, y: topY - 110)
        scoreNode.zPosition = 10

        musicButton = ToggleButtonNode(onTexture: SKTexture(imageNamed: "music_on"),
                                       offTexture: SKTexture(imageNamed: "music_off"),
                                       isOn: SoundManager.shared.isMusicEnabled)
        musicButton.onToggle = { SoundManager.shared.isMusicEnabled = $0 }

        soundEffectsButton = ToggleButtonNode(onTexture: SKTexture(imageNamed: "speaker_on"),
                                              offTexture: SKTexture(imageNamed: "speaker_off"),
                                              isOn: SoundManager.shared.isSoundEffectsEnabled)
        soundEffectsButton.onToggle = { SoundManager.shared.isSoundEffectsEnabled = $0 }

        for button in audioButtons {
            button.zPosition = 20
        }

        updateScoreboard()
        addChild(scoreNode)
        addChild(coinsNode)
    }

    func addPoint() {
        score += 1
        GameData.coins += 1
        SoundManager.shared.play(SoundManager.coinSound, on: self)
        updateScoreboard()

        if score > highScore {
            highScore = score
            GameData.highScore = score

            if !isNewHighScore {
                isNewHighScore = true
                scoreNode.run(SKAction.scale(to: 1.5, duration: 0.25))
                scoreNode.fontColor = UIColor(red: 0.87, green: 0.89, blue: 0.29, alpha: 1.0)
            }
        }
    }

    private func updateScoreboard() {
        coinsNode.text = "\(GameData.coins)ƒ"
        scoreNode.text = "\(score)"
    }

    func setScoreHidden(_ hidden: Bool) {
        scoreNode.isHidden = hidden
    }

    func gameOver() {
        guard !gameIsOver else { return }
        gameIsOver = true

        let midX = size.width / 2
        let buttonSize = CGSize(width: 70, height: 70)
        let buttonY = size.height * 0.427

        if isNewHighScore {
            scoreNode.fontColor = CoinColor
        }

        gameOverNode.text = "Game Over"
        gameOverNode.zPosition = 9
        gameOverNode.position = CGPoint(x: midX, y: size.height + 100)

        bestScoreNode.text = "Best: \(highScore)"
        bestScoreNode.fontSize = 20
        bestScoreNode.zPosition = 9
        bestScoreNode.position = CGPoint(x: midX, y: size.height + 75)

        // Buttons slide up from below the screen: customize, leaderboard, play.
        let buttons = [customizeNode, leaderboardNode, playNode]
        for (i, button) in buttons.enumerated() {
            button.size = buttonSize
            button.zPosition = 10
            button.position = CGPoint(x: midX, y: -buttonSize.height * 2)
            addChild(button)
            let x = midX + CGFloat(i - 1) * (buttonSize.width + 15)
            button.run(SKAction.move(to: CGPoint(x: x, y: buttonY), duration: 0.5))
        }

        let margin: CGFloat = 12
        let spacing: CGFloat = 8
        var right = size.width - margin
        for button in audioButtons.reversed() {
            button.position = CGPoint(x: right - button.size.width / 2,
                                      y: bottomInset + margin + button.size.height / 2)
            addChild(button)
            right -= button.size.width + spacing
        }
        addChild(gameOverNode)
        addChild(bestScoreNode)

        scoreNode.run(SKAction.move(to: CGPoint(x: midX, y: size.height * 0.547), duration: 0.5))
        gameOverNode.run(SKAction.move(to: CGPoint(x: midX, y: size.height * 0.727), duration: 0.5))
        bestScoreNode.run(SKAction.move(to: CGPoint(x: midX, y: size.height * 0.675), duration: 0.5))
    }

    // MARK: - Touches

    /// A button only responds once it is on screen, i.e. after game over.
    private func isTouching(_ button: SKNode, at point: CGPoint) -> Bool {
        button.parent != nil && button.contains(point)
    }

    private func updatePressedButton(at point: CGPoint?) {
        for button in audioButtons {
            button.setPressed(point.map { isTouching(button, at: $0) } ?? false)
        }
    }

    func touchBegan(at point: CGPoint) {
        updatePressedButton(at: point)
    }

    func touchMoved(to point: CGPoint) {
        updatePressedButton(at: point)
    }

    func touchEnded(at point: CGPoint) {
        updatePressedButton(at: nil)

        if isTouching(playNode, at: point) {
            playButtonAction?()
        } else if isTouching(leaderboardNode, at: point) {
            leaderboardAction?()
        } else if isTouching(customizeNode, at: point) {
            customizeAction?()
        } else if let button = audioButtons.first(where: { isTouching($0, at: point) }) {
            button.toggle()
        }
    }
}

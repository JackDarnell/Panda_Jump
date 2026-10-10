//
//  GameViewController.swift
//  Panda Jump
//
//  Created by Jack Darnell on 3/20/17.
//  Copyright © 2017 Jack Darnell. All rights reserved.
//

import GameKit
import GoogleMobileAds
import SpriteKit
import UIKit

class GameViewController: UIViewController, GKGameCenterControllerDelegate {

    private var skView: SKView { view as! SKView }
    private var bannerView: BannerView?
    private var hasPresentedFirstScene = false

    override func viewDidLoad() {
        super.viewDidLoad()
        skView.ignoresSiblingOrder = true

        let center = NotificationCenter.default
        center.addObserver(self, selector: #selector(appWillResignActive), name: UIApplication.willResignActiveNotification, object: nil)
        center.addObserver(self, selector: #selector(appDidBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)

        // UI tests skip Game Center so its sign-in sheet can't cover the game.
        if !ProcessInfo.processInfo.arguments.contains("-UITesting") {
            authenticateLocalPlayer()
        }
        SoundManager.shared.startPlaying()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // Wait for the first layout so the view size and safe-area insets are real.
        guard !hasPresentedFirstScene, view.bounds.width > 0 else { return }
        hasPresentedFirstScene = true
        // Exceeding 60 also needs CADisableMinimumFrameDuration in Info.plist.
        skView.preferredFramesPerSecond = view.window?.windowScene?.screen.maximumFramesPerSecond ?? 60
        setUpBanner()
        startNewGame(transition: nil)
    }

    override var prefersStatusBarHidden: Bool { true }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask { .portrait }

    // MARK: - Game

    /// Space at the top of the screen the game should keep clear (notch + banner ad).
    private var topInset: CGFloat {
        view.safeAreaInsets.top + (bannerView?.adSize.size.height ?? 0)
    }

    func startNewGame(transition: SKTransition? = SKTransition.fade(with: .black, duration: 0.5)) {
        let scene = GameScene(size: view.bounds.size)
        scene.scaleMode = .aspectFill
        scene.gameViewController = self
        scene.topInset = topInset
        scene.bottomInset = view.safeAreaInsets.bottom

        // The Dev skin turns on SpriteKit's debug overlays.
        let debug = GameData.isDevSkinEquipped
        skView.showsPhysics = debug
        skView.showsFPS = debug
        skView.showsNodeCount = debug

        if let transition = transition {
            skView.presentScene(scene, transition: transition)
        } else {
            skView.presentScene(scene)
        }
    }

    @objc private func appWillResignActive() {
        skView.isPaused = true
    }

    @objc private func appDidBecomeActive() {
        skView.isPaused = false
    }

    // MARK: - Ads

    private func setUpBanner() {
        guard AdsEnabled else { return }

        let banner = BannerView(adSize: largeAnchoredAdaptiveBanner(width: view.bounds.width))
        banner.adUnitID = BannerAdUnitID
        banner.rootViewController = self
        banner.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(banner)
        NSLayoutConstraint.activate([
            banner.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            banner.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        banner.load(Request())
        bannerView = banner
    }

    // MARK: - Customize screen

    func showCustomize() {
        guard presentedViewController == nil else { return }
        performSegue(withIdentifier: "showCustomizeSegue", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Since iOS 13 modals default to a card that can be swiped away; the game expects full screen.
        segue.destination.modalPresentationStyle = .fullScreen
    }

    // MARK: - Game Center

    private func authenticateLocalPlayer() {
        GKLocalPlayer.local.authenticateHandler = { [weak self] loginViewController, error in
            if let loginViewController = loginViewController {
                self?.present(loginViewController, animated: true)
            } else if let error = error {
                print("Game Center unavailable: \(error.localizedDescription)")
            }
        }
    }

    func submitHighScore(_ score: Int) {
        guard GKLocalPlayer.local.isAuthenticated else { return }
        GKLeaderboard.submitScore(score, context: 0, player: GKLocalPlayer.local, leaderboardIDs: [LeaderboardID]) { error in
            if let error = error {
                print("Failed to submit score: \(error.localizedDescription)")
            }
        }
    }

    func showLeaderboard() {
        guard presentedViewController == nil else { return }
        guard GKLocalPlayer.local.isAuthenticated else {
            let alert = UIAlertController(title: "Game Center",
                                          message: "Sign in to Game Center in the Settings app to see the leaderboard.",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
            return
        }
        let gameCenterVC = GKGameCenterViewController(leaderboardID: LeaderboardID, playerScope: .global, timeScope: .allTime)
        gameCenterVC.gameCenterDelegate = self
        present(gameCenterVC, animated: true)
    }

    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true)
    }
}

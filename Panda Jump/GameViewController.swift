//
//  GameViewController.swift
//  Panda Jump
//
//  Created by Jack Darnell on 3/20/17.
//  Copyright © 2017 Jack Darnell. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit
import GameKit
import AVFoundation


class GameViewController: UIViewController, GKGameCenterControllerDelegate {
    
    @available(iOS 6.0, *)
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true, completion: nil)
    }

    let slideAnimation = SlideAnimationForward()
    var gcEnabled = Bool() // Check if the user has Game Center enabled
    var gcDefaultLeaderBoard = String() // Check the default leaderboardID
    
    var score = 0
    
    // IMPORTANT: replace the red string below with your own Leaderboard ID (the one you've set in iTunes Connect)
    let LEADERBOARD_ID = "grp.PandaJumnpTopScores"

    override func viewDidLoad() {
        super.viewDidLoad()
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.ambient)
            try AVAudioSession.sharedInstance().setActive(true)
        }
        catch let error as NSError {
            print(error)
        }
        authenticateLocalPlayer()
        
        
         //UserDefaults.standard.
        let index = UserDefaults.standard.integer(forKey: currentSkinIndexKey)
        skins[index].equip()
        
        let sceneNode = GameScene(size: view.frame.size) //this loads the menu scene as default
        sceneNode.viewController = self
        
        //UserDefaults.standard.set(1000, forKey: CoinsKey)
        
        if let view = self.view as? SKView? {
            if skins[UserDefaults.standard.integer(forKey: currentSkinIndexKey)].name == devSkin.name {
                view?.showsPhysics = true
                view?.showsFPS = true
                view?.showsNodeCount = true
                view?.showsFields = true
            } else {
                view?.showsPhysics = false
                view?.showsFPS = false
                view?.showsNodeCount = false
                view?.showsFields = false
            }
            view?.presentScene(sceneNode)
            view?.ignoresSiblingOrder = true
            //view.showsPhysics = true
            //view?.showsFPS = true
            //view?.showsNodeCount = true
        }

        
    }

    override var shouldAutorotate: Bool {
        return false
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    func authenticateLocalPlayer() {
        let localPlayer: GKLocalPlayer = GKLocalPlayer.local
        
        localPlayer.authenticateHandler = {(ViewController, error) -> Void in
            if((ViewController) != nil) {
                // 1. Show login if player is not logged in
                self.present(ViewController!, animated: true, completion: nil)
            } else if (localPlayer.isAuthenticated) {
                // 2. Player is already authenticated & logged in, load game center
                self.gcEnabled = true
                
                // Get the default leaderboard ID
                localPlayer.loadDefaultLeaderboardIdentifier(completionHandler: { (leaderboardIdentifer, error) in
                    if error != nil { print(error)
                    } else { self.gcDefaultLeaderBoard = leaderboardIdentifer! }
                })
                
            } else {
                // 3. Game center is not enabled on the users device
                self.gcEnabled = false
                print("Local player could not be authenticated!")
                print(error)
            }
        }
    }
    
    public func uploadHighScore(score: Int){
        print(score)
        let bestScoreInt = GKScore(leaderboardIdentifier: LEADERBOARD_ID)
        bestScoreInt.value = Int64(score)
        GKScore.report([bestScoreInt]) { (error) in
            if error != nil {
                print(error!.localizedDescription)
            } else {
                print("Best Score submitted to your Leaderboard!")
            }
        }

    }
    
    public func checkLeaderboard() {
        print("Checking Leaderboard")
        let gcVC = GKGameCenterViewController()
        gcVC.gameCenterDelegate = self
        gcVC.viewState = .leaderboards
        gcVC.leaderboardIdentifier = LEADERBOARD_ID
        //self.present(gcVC, animated: true, completion: nil)
        
        if let topController = UIApplication.shared.keyWindow?.rootViewController {
            print(topController)
            topController.present(gcVC, animated: true, completion: nil)
        }
        //let vc = self
       
        
        //vc.present(gcVC, animated: true, completion: nil)
        
    }
    
    /*
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination
        destination.transitioningDelegate = SlideAnimation()
    }
 */
    
    public func goToCustomizeVC() {
        
        
        if let topController = UIApplication.shared.keyWindow?.rootViewController {
            print(topController)
            topController.performSegue(withIdentifier: "showCustomizeSegue", sender: nil)
        }
    }
        
}

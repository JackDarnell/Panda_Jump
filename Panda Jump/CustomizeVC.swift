//
//  upgradesVC.swift
//  Panda Jump
//
//  Created by Jack Darnell on 6/20/17.
//  Copyright © 2017 Jack Darnell. All rights reserved.
//

import UIKit

class CustomizeVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var coinsLabel: UILabel!
    
    let slideAnimation = SlideAnimationForward()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        coinsLabel.text = "\(UserDefaults.standard.integer(forKey: CoinsKey))ƒ"

        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
        coinsLabel.text = "\(UserDefaults.standard.integer(forKey: CoinsKey))ƒ"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return skins.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let skin = skins[indexPath.row]
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "CustomizeCell") as? CustomizeCell {
            print("JACK: returned cell")
            cell.configureCell(CharacterSkin: skin)
            return cell
        } else {
            print("JACK: else returned MyLevelCell()")
            return CustomizeCell()
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //var index = indexPath.row
        /*
         if interstitial.isReady == true {
         print("JACK: INTERSTITIAL IS READy")
         interstitial.present(fromRootViewController: self)
         
         } else {
         print("JACK: not ready")
         
         }
         */
        print(skins[indexPath.row])
        print("didselectrow at index path")
        if indexPath.row != skins.count {
            self.performSegue(withIdentifier: "goToCustomizeObjectVC", sender: skins[indexPath.row])
        }
        //print(levels.count)
        
        
        print("JACK: \(indexPath)")
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destination = segue.destination
        destination.transitioningDelegate = slideAnimation
        
        if let destination = segue.destination as? CustomizeObjectVC {
            if let chosenSkin = sender as? CharacterSkin {
                destination._skin = chosenSkin
            }
        }
        
    }
    
    
    @IBAction func closeButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

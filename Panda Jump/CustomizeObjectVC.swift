//
//  CustomizeObjectVC.swift
//  Panda Jump
//
//  Created by Jack Darnell on 7/19/17.
//  Copyright © 2017 Jack Darnell. All rights reserved.
//

import UIKit

class CustomizeObjectVC: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var purchaseButton: UIButton!
    @IBOutlet weak var moneyLabel: UILabel!
    
    var indexOfSkin: Int!
    
    private var skin: CharacterSkin!
    var _skin: CharacterSkin {
        get {
            return skin
        } set {
            skin = newValue
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //print("view did load")
        print("SKIN: \(skin)")
        imageView.image = self.skin.image
        nameLabel.text = self.skin.name
        descriptionTextView.text = self.skin.description
        purchaseButton.setTitle("\(self.skin.price)", for: .normal)
        moneyLabel.text = "\(UserDefaults.standard.integer(forKey: CoinsKey))"
        
        for (index, _skin) in skins.enumerated() {
            if skin.name == _skin.name {
                print(index)
                indexOfSkin = index
                //UserDefaults.standard.set(index, forKey: currentSkinIndexKey)
            }
        }
        
        if skin.owned == true && skin.equipped == false {
            purchaseButton.setTitle("Equip", for: .normal)
        } else if skin.owned == false {
            purchaseButton.setTitle("\(skin.price)$", for: .normal)
        } else if skin.equipped == true {
            purchaseButton.setTitle("Equipped", for: .normal)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func purchaseButtonPressed(_ sender: Any) {
        if skin.owned == true && skin.equipped == false {
            skins[UserDefaults.standard.integer(forKey: currentSkinIndexKey)].undoEquip()
            skin.equip()
            UserDefaults.standard.set(indexOfSkin, forKey: currentSkinIndexKey)
            purchaseButton.setTitle("Equipped", for: .normal)
        } else if skin.owned == false {
            //TODO PURCHASE SKIN CODE NEED TO BE BUILT
            if UserDefaults.standard.integer(forKey: CoinsKey) < skin.price {
                print("Dont have enough money for the skin") //TODO MAKE ALERT FOR THIS
            } else {
                let money = UserDefaults.standard.integer(forKey: CoinsKey) - skin.price
                UserDefaults.standard.set(money, forKey: CoinsKey)
                skin.purchaseSkin()
                purchaseButton.setTitle("Equip", for: .normal)
                moneyLabel.text = "\(UserDefaults.standard.integer(forKey: CoinsKey))"
            }
        } else if skin.equipped == true {
            //skin already equipped do nothing maybe show the alert saying already purchased or something
        }
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

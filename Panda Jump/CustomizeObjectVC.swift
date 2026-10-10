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

    var skin: CharacterSkin!

    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = skin.image
        nameLabel.text = skin.name
        descriptionTextView.text = skin.description
        refresh()
    }

    private func refresh() {
        moneyLabel.text = "\(GameData.coins)"

        let title: String
        if skin.isEquipped {
            title = "Equipped"
        } else if skin.isOwned {
            title = "Equip"
        } else {
            title = "\(skin.price)$"
        }
        purchaseButton.setTitle(title, for: .normal)
    }

    @IBAction func backButtonPressed(_ sender: Any) {
        dismiss(animated: true)
    }

    @IBAction func purchaseButtonPressed(_ sender: Any) {
        if skin.isEquipped {
            return
        } else if skin.isOwned {
            skin.equip()
        } else if !skin.purchase() {
            let alert = UIAlertController(title: "Not enough coins",
                                          message: "You need \(skin.price - GameData.coins) more coins for \(skin.name).",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        }
        refresh()
    }
}

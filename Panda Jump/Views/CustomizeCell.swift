//
//  CustomizeCell.swift
//  Panda Jump
//
//  Created by Jack Darnell on 7/16/17.
//  Copyright © 2017 Jack Darnell. All rights reserved.
//

import UIKit

class CustomizeCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var previewImageView: UIImageView!
    @IBOutlet weak var checkImageView: UIImageView!

    func configure(with skin: CharacterSkin) {
        nameLabel.text = skin.name
        priceLabel.text = "\(skin.price)"
        previewImageView.image = skin.image

        // Cells are reused, so set both states every time.
        checkImageView.isHidden = !skin.isOwned
        priceLabel.isHidden = skin.isOwned
    }
}

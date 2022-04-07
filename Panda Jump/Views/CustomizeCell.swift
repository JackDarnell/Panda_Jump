//
//  CustomizeCellTableViewCell.swift
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
    
    
    var skin: CharacterSkin!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(CharacterSkin: CharacterSkin) {
        self.skin = CharacterSkin
        checkImageView.isHidden = true
        nameLabel.text = skin.name
        priceLabel.text = "\(skin.price)"
        previewImageView.image = skin.image
        if UserDefaults.standard.bool(forKey: skin.ownedKey) == true || skin.owned == true {
            checkImageView.isHidden = false
            priceLabel.isHidden = true
        }
    }
 
    
}

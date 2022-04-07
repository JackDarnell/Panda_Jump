//
//  RoundButton.swift
//  Panda Jump
//
//  Created by Jack Darnell on 7/19/17.
//  Copyright © 2017 Jack Darnell. All rights reserved.
//

import UIKit

class RoundButton: UIButton {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.shadowColor = UIColor(red: SHADOW_GRAY, green: SHADOW_GRAY, blue: SHADOW_GRAY, alpha: 0.6).cgColor
        layer.shadowOpacity = 0.8
        layer.shadowRadius = 5
        layer.shadowOffset = CGSize(width: 1, height: 1)
        imageView?.contentMode = .scaleAspectFit
        //height of frame hasnt been calculated so dont use this for making the button round
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = self.frame.height / 2
    }
    
}


//
//  BoolItemTableViewCell.swift
//  Configuration
//
//  Created by michael dunn on 2/6/19.
//  Copyright © 2019 michael dunn. All rights reserved.
//

import UIKit

class BoolItemTableViewCell: ItemTableViewCell {
    
    override func configure(item: Item) {
        nameLabel.text = item.key
        boolSwitch.isOn = item.boolValue ?? false
        boolSwitch.addTarget(self, action: #selector(switchChanged), for: UIControl.Event.valueChanged)
    }
    

    @IBOutlet weak var boolSwitch: UISwitch!
    @IBOutlet weak var nameLabel: UILabel!
    

    @objc func switchChanged(mySwitch: UISwitch) {
        changeDelegate?.valueDidChange()
    }
   
}

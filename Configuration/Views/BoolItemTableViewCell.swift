//
//  BoolItemTableViewCell.swift
//  Configuration
//
//  Created by michael dunn on 2/6/19.
//  Copyright © 2019 michael dunn. All rights reserved.
//

import UIKit

class BoolItemTableViewCell: ItemTableViewCell {
    
    var item: SectionItem?
    override func configure(item: SectionItem) {
        self.item = item
        nameLabel.text = item.key?.localized
        boolSwitch.isOn = item.boolValue == true
        boolSwitch.addTarget(self, action: #selector(switchChanged), for: UIControl.Event.valueChanged)
    }
    

    @IBOutlet weak var boolSwitch: UISwitch!
    @IBOutlet weak var nameLabel: UILabel!
    

    @objc func switchChanged(mySwitch: UISwitch) {
        item?.boolValue = boolSwitch.isOn
        changeDelegate?.valueDidChange()
    }
   
}

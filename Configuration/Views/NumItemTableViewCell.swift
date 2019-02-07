//
//  NumItemTableViewCell.swift
//  Configuration
//
//  Created by michael dunn on 2/6/19.
//  Copyright © 2019 michael dunn. All rights reserved.
//

import UIKit

class NumItemTableViewCell: ItemTableViewCell {
    
    override func configure(item: SectionItem) {
        nameLabel.text = item.key?.localized
        valueTextField.text = String(item.numValue)
    }
    

    @IBOutlet weak var valueTextField: UITextField!
    @IBOutlet weak var nameLabel: UILabel!
   

}

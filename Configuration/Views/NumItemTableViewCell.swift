//
//  NumItemTableViewCell.swift
//  Configuration
//
//  Created by michael dunn on 2/6/19.
//  Copyright © 2019 michael dunn. All rights reserved.
//

import UIKit

class NumItemTableViewCell: ItemTableViewCell {
    
    override func configure(item: Item) {
        if let val = item.numValue {
            valueTextField.text = String(val)
        }
    }
    

    @IBOutlet weak var valueTextField: UITextField!
    @IBOutlet weak var nameLabel: UILabel!
   

}

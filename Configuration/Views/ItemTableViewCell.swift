//
//  ItemTableViewCell.swift
//  Configuration
//
//  Created by michael dunn on 2/7/19.
//  Copyright © 2019 michael dunn. All rights reserved.
//

import UIKit

//
// ItemTableViewCell: base class for the three types of cells (text, number, bool)
//      common keyboard handler when return button is tapped on text field keyboards
//      item - represents the core data item being displayed

class ItemTableViewCell: UITableViewCell {
    var item: SectionItem?
    
    func configure(item: SectionItem) {
        self.item = item
    }
}

extension ItemTableViewCell: UITextFieldDelegate {
   
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

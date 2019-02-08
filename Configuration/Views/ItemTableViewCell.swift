//
//  ItemTableViewCell.swift
//  Configuration
//
//  Created by michael dunn on 2/7/19.
//  Copyright © 2019 michael dunn. All rights reserved.
//

import UIKit


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

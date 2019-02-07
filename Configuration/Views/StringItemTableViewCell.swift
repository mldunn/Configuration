//
//  StringItemTableViewCell.swift
//  Configuration
//
//  Created by michael dunn on 2/6/19.
//  Copyright © 2019 michael dunn. All rights reserved.
//

import UIKit


class StringItemTableViewCell: ItemTableViewCell {
    
    override func configure(item: Item) {
        nameLabel.text = item.stringValue
        valueTextField.text = item.stringValue
        valueTextField.delegate = self
    }
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var valueTextField: UITextField!

}


extension StringItemTableViewCell: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        changeDelegate?.valueDidChange()
    }
}

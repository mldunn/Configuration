//
//  NumItemTableViewCell.swift
//  Configuration
//
//  Created by michael dunn on 2/6/19.
//  Copyright © 2019 michael dunn. All rights reserved.
//

import UIKit

//
// NumItemTableViewCell - cell for numerical inputs, displays a numeric keypad 
//

class NumItemTableViewCell: ItemTableViewCell {
    
    override func awakeFromNib() {
        valueTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)

    }
    
    override func configure(item: SectionItem) {
        
        super.configure(item: item)
        
        nameLabel.text = item.key?.localized
        nameLabel.adjustsFontForContentSizeCategory = true
        if let sVal = item.stringvalue, !sVal.isEmpty {
            valueTextField.text = String(item.numValue)
        }
        valueTextField.delegate = self
        valueTextField.adjustsFontForContentSizeCategory = true
        valueTextField.addDoneCancelToolbar()
        valueTextField.accessibilityIdentifier = item.identifier
    }
    
    @objc func textDidChange(_ textField: UITextField) {
        LogService.log("textDidChange \(String(describing: textField.text))")
        
        if let text = textField.text {
            
            if let numVal = Int64(text) {
                item?.numValue = Int64(numVal)
                item?.stringvalue = textField.text
            }
            else if text.isEmpty {
                item?.stringvalue = ""
                item?.numValue = 0
            }
        }
    }

    @IBOutlet weak var valueTextField: UITextField!
    @IBOutlet weak var nameLabel: UILabel!

    
    
}


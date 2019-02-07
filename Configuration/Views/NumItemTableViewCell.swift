//
//  NumItemTableViewCell.swift
//  Configuration
//
//  Created by michael dunn on 2/6/19.
//  Copyright © 2019 michael dunn. All rights reserved.
//

import UIKit

class NumItemTableViewCell: ItemTableViewCell {
    
    override func awakeFromNib() {
        valueTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
    }
    
    override func configure(item: SectionItem) {
        
        super.configure(item: item)
        
        nameLabel.text = item.key?.localized
        nameLabel.adjustsFontForContentSizeCategory = true
        valueTextField.text = item.stringvalue
        valueTextField.delegate = self
        valueTextField.adjustsFontForContentSizeCategory = true
        
    }
    
     @objc func textDidChange(_ textField: UITextField) {
        item?.stringvalue = textField.text
        changeDelegate?.valueDidChange()
    }

    @IBOutlet weak var valueTextField: UITextField!
    @IBOutlet weak var nameLabel: UILabel!
   

}


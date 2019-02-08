//
//  StringItemTableViewCell.swift
//  Configuration
//
//  Created by michael dunn on 2/6/19.
//  Copyright © 2019 michael dunn. All rights reserved.
//

import UIKit


class StringItemTableViewCell: ItemTableViewCell {
    
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
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var valueTextField: UITextField!

    
    @objc func textDidChange(_ textField: UITextField) {
        item?.stringvalue = textField.text
    }
}

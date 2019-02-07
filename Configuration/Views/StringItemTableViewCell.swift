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
    
    var item: SectionItem?
    override func configure(item: SectionItem) {
        nameLabel.text = item.key?.localized
        valueTextField.text = item.stringvalue
        valueTextField.delegate = self
        self.item = item
    }
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var valueTextField: UITextField!

    
    @objc func textDidChange(_ textField: UITextField) {
        item?.stringvalue = textField.text
        changeDelegate?.valueDidChange()
    }
}


extension StringItemTableViewCell: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        changeDelegate?.valueDidChange()
    }
}

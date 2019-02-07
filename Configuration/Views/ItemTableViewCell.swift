//
//  ItemTableViewCell.swift
//  Configuration
//
//  Created by michael dunn on 2/7/19.
//  Copyright © 2019 michael dunn. All rights reserved.
//

import UIKit


protocol ItemTableViewCellDelegate: class {
    func valueDidChange()
}

class ItemTableViewCell: UITableViewCell {
    var item: SectionItem?
    
    func configure(item: SectionItem) {
        self.item = item
    }
    weak var changeDelegate: ItemTableViewCellDelegate?
}

extension ItemTableViewCell: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        changeDelegate?.valueDidChange()
    }
}

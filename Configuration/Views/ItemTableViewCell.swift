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
   
    //
    // check for valid integer
    //
    func textField(_ textField: UITextField, shouldChangCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard let type = item?.dataType, (type == ItemType.int.rawValue) else { return true }
        
        LogService.log("NumItemTableViewCell.shouldChangeCharactersInstring \(string)")
        
        if string.isEmpty {
            return true
        }
        
        if let newText = textField.text as NSString? {
            let newString = newText.replacingCharacters(in: range, with: string)
            LogService.log("NumItemTableViewCell.shouldChangeCharactersInstring - newString=\(newString)")
            
            if let _ = Int64(newString) {
                return true
            }
            else if textField.text?.isEmpty ?? true {
                return true
            }
        }
        return false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

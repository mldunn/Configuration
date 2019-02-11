//
//  SectionItem+Extension.swift
//  Configuration
//
//  Created by michael dunn on 2/7/19.
//  Copyright © 2019 michael dunn. All rights reserved.
//

import Foundation


extension SectionItem {
    
    var details: String {
        
        var detail = key ?? ""
        if let type = ItemType(rawValue: dataType ?? "") {
            switch type {
            case .bool:
                detail.append(": \(boolValue) -")
            case .int:
                 detail.append(": \(numValue) -")
            case .text:
                detail.append(":  \(stringvalue ?? "") -")
            }
            detail.append(type.rawValue)
            
        }
        else {
            detail.append(":  \(stringvalue ?? "") -err")
        }
        
        return detail
    }
    
    var identifier: String {
        if let key = key, let section = section?.name {
            return section + "." + key
        }
        return "undefined"
    }
}

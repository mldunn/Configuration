//
//  EditType.swift
//  Configuration
//
//  Created by michael dunn on 2/11/19.
//  Copyright © 2019 michael dunn. All rights reserved.
//

import Foundation

enum EditType: String {
    case email
    case configuration
    
    var segueIdentifier: String {
        switch self {
        case .email:
            return "editEmail"
        case .configuration:
            return "editConfiguration"
        }
    }
    
    var rootKey: String {
        return rawValue
    }
    
    var bundleFile: String {
        return rawValue
    }
}

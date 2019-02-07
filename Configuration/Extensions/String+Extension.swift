//
//  String+Extension.swift
//  Configuration
//
//  Created by michael dunn on 2/7/19.
//  Copyright © 2019 michael dunn. All rights reserved.
//

import Foundation

extension String {
    var nameFromCamelCase: String {
        get {
            var name = ""
            for c in self {
                let s = String(c)
                if name.isEmpty {
                    name.append(s.uppercased())
                }
                else if s == s.uppercased() {
                    name.append(" ")
                    name.append(s)
                }
                else {
                    name.append(s)
                }
            }
            return name
        }
        
    }
    
    var localized: String {
        get {
          return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: self.nameFromCamelCase, comment: self)
        }
    }
    
   
}

//
//  Section+Extension.swift
//  Configuration
//
//  Created by michael dunn on 2/7/19.
//  Copyright © 2019 michael dunn. All rights reserved.
//

import Foundation

extension Section {
    
    var itemCount: Int {
        return items?.count ?? 0
    }
    
    var sectionItems: [SectionItem] {
        if let allVals = items?.array as? [SectionItem] {
           return allVals
        }
        return []
    }
}

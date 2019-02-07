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
}

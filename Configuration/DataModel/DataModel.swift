//
//  DataModel.swift
//  Configuration
//
//  Created by michael dunn on 2/7/19.
//  Copyright © 2019 michael dunn. All rights reserved.
//

import Foundation




struct DummySectionItem {
    var name: String
    var id: UUID?
    
}

struct Item {
    var key: String
    var type: ItemType
    var boolValue: Bool?
    var numValue: Int?
    var stringValue: String?
    var id: UUID?
}

var types: [ItemType] = [.string,.bool,.number]
var items =  [String:[Item]]()




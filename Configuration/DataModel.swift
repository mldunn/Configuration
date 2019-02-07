//
//  DataModel.swift
//  Configuration
//
//  Created by michael dunn on 2/7/19.
//  Copyright © 2019 michael dunn. All rights reserved.
//

import Foundation


enum ItemType: String, CaseIterable {
    case string
    case bool
    case num
    
    var cellIdentifier: String {
        return rawValue + "Cell"
    }
}

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

var types: [ItemType] = [.string,.bool,.num]
var items =  [String:[Item]]()
var sections: [DummySectionItem] = [DummySectionItem(name: "hello", id: nil),DummySectionItem(name: "world", id: nil)]




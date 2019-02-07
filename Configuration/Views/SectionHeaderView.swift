//
//  SectionHeaderView.swift
//  Configuration
//
//  Created by michael dunn on 2/7/19.
//  Copyright © 2019 michael dunn. All rights reserved.
//

import UIKit

class SectionHeaderView: UITableViewHeaderFooterView {

    var id: UUID?
    
    func configure(id: UUID?, name: String?) {
        self.id = id
        
        let bgView = UIView()
        bgView.backgroundColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
        backgroundView = bgView
        if let text = name?.localized {
            textLabel?.text = "    " + text
            textLabel?.adjustsFontForContentSizeCategory = true
            textLabel?.textAlignment = .left
            textLabel?.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            textLabel?.center.y = contentView.center.y
        }
        
    }

}

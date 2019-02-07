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
        textLabel?.text = name?.localized
        
        let bgView = UIView()
        bgView.backgroundColor = .cyan
        backgroundView = bgView
    }

}

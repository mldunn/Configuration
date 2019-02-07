//
//  SectionHeaderView.swift
//  Configuration
//
//  Created by michael dunn on 2/7/19.
//  Copyright © 2019 michael dunn. All rights reserved.
//

import UIKit

class SectionHeaderView: UITableViewHeaderFooterView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    var id: UUID?
    
    func configure(id: UUID?, name: String) {
        self.id = id
        textLabel?.text = name
        
        let bgView = UIView()
        bgView.backgroundColor = .red
        backgroundView = bgView
        
       
    }

}

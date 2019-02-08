//
//  SectionHeaderView.swift
//  Configuration
//
//  Created by michael dunn on 2/7/19.
//  Copyright © 2019 michael dunn. All rights reserved.
//

import UIKit

class SectionHeaderView: UIView {

    var id: UUID?
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    
    func configure(id: UUID?, name: String?) {
        self.id = id
        titleLabel.textColor = .black
        titleLabel.text = name?.localized
        backgroundView.backgroundColor = UIColor.lightBlue
    }

}

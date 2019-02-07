//
//  ItemTableViewCell.swift
//  Configuration
//
//  Created by michael dunn on 2/7/19.
//  Copyright © 2019 michael dunn. All rights reserved.
//

import UIKit


protocol ItemTableViewCellDelegate: class {
    func valueDidChange()
}

class ItemTableViewCell: UITableViewCell {
    func configure(item: SectionItem) {}
    weak var changeDelegate: ItemTableViewCellDelegate?
}

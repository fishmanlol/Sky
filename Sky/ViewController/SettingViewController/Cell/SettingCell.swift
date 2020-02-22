//
//  SettingCell.swift
//  Sky
//
//  Created by Yi on 2020/2/21.
//  Copyright © 2020 tongyi. All rights reserved.
//

import UIKit

class SettingCell: UITableViewCell {
    static let identifier = "SettingCell"
    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
    }
}

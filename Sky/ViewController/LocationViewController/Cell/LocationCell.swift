//
//  LocationCell.swift
//  Sky
//
//  Created by Yi on 2020/2/21.
//  Copyright © 2020 tongyi. All rights reserved.
//

import UIKit

class LocationCell: UITableViewCell {
    static let identifier = "LocationCell"
    
    @IBOutlet weak var label: UILabel!
    
    func configure(with vm: LocationRepresentable) {
        label.text = vm.labelText
    }
    
    override func awakeFromNib() {
        label.text = ""
    }
    
    override func prepareForReuse() {
        label.text = ""
    }
}

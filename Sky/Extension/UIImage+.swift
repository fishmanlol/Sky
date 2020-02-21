//
//  UIImage+.swift
//  Sky
//
//  Created by tongyi on 2/17/20.
//  Copyright © 2020 tongyi. All rights reserved.
//

import UIKit

extension UIImage {
    static func weatherIcon(of name: String) -> UIImage? {
        return UIImage(named: name) ?? UIImage(named: "clear-day")
    }
}

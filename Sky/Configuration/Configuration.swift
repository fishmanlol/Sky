//
//  Configureation.swift
//  Sky
//
//  Created by tongyi on 2/13/20.
//  Copyright © 2020 tongyi. All rights reserved.
//

import Foundation

struct API {
    static let key = "29e86d538e80a61b5c119d4d1d503021"
    static let baseURL = URL(string: "https://api.darksky.net/forecast")!
    static let authenticatedURL = baseURL.appendingPathComponent(key)
}

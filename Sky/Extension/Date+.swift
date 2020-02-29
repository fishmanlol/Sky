//
//  Date.swift
//  Sky
//
//  Created by Yi Tong on 2/28/20.
//  Copyright © 2020 tongyi. All rights reserved.
//

import Foundation

extension Date {
    static func from(string: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyy-mm-dd"
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT+8:00")
        
        return dateFormatter.date(from: string) ?? Date()
    }
}

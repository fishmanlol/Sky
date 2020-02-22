//
//  ForecastData.swift
//  Sky
//
//  Created by Yi on 2020/2/20.
//  Copyright © 2020 tongyi. All rights reserved.
//

import Foundation

struct ForecastData: Codable, Equatable {
    let time: Date
    let temperatureLow: Double
    let temperatureHigh: Double
    let icon: String
    let humidity: Double
    
    static func ==(lhs: ForecastData, rhs: ForecastData) -> Bool {
        return lhs.time == rhs.time &&
            lhs.temperatureLow == rhs.temperatureLow &&
            lhs.icon == rhs.icon &&
            lhs.temperatureHigh == rhs.temperatureHigh &&
            lhs.humidity == rhs.humidity
    }
}

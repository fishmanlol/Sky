//
//  WeatherData.swift
//  Sky
//
//  Created by tongyi on 2/13/20.
//  Copyright © 2020 tongyi. All rights reserved.
//

import Foundation

struct WeatherData: Codable {
    let latitude: Double
    let longitude: Double
    let currently: CurrentWeather
    
    struct CurrentWeather: Codable, Equatable {
        let time: Date
        let summary: String
        let icon: String
        let temperature: Double
        let humidity: Double
        
        static func ==(lhs: CurrentWeather, rhs: CurrentWeather) -> Bool {
            return lhs.time == rhs.time &&
                lhs.summary == rhs.summary &&
                lhs.icon == rhs.icon &&
                lhs.temperature == rhs.temperature &&
                lhs.humidity == rhs.humidity
        }
    }
}

extension WeatherData: Equatable {
    static func ==(lhs: WeatherData, rhs: WeatherData) -> Bool {
        return lhs.latitude == rhs.latitude &&
            lhs.longitude == rhs.longitude &&
            lhs.currently == rhs.currently
            
    }
}

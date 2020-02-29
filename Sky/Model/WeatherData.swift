//
//  WeatherData.swift
//  Sky
//
//  Created by tongyi on 2/13/20.
//  Copyright © 2020 tongyi. All rights reserved.
//

import Foundation

struct WeatherData: Codable {
    //MARK: - static property
    static let empty = WeatherData(latitude: 0,
                                   longitude: 0,
                                   currently: CurrentWeather(time: Date(),
                                                             summary: "",
                                                             icon: "",
                                                             temperature: 0,
                                                             humidity: 0),
                                   daily: WeekWeatherData(data: []))
    
    static let invalid = WeatherData(latitude: 0,
                                     longitude: 0,
                                     currently: CurrentWeather(time: Date.from(string: "1970-01-01"), summary: "n/a", icon: "n/a", temperature: -274, humidity: -1),
                                     daily: WeekWeatherData(data: []))
    
    let latitude: Double
    let longitude: Double
    let currently: CurrentWeather
    let daily: WeekWeatherData
    
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
    
    struct WeekWeatherData: Codable, Equatable {
        let data: [ForecastData]
        
        static func == (lhs: WeekWeatherData, rhs: WeekWeatherData) -> Bool {
            return lhs.data == rhs.data
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

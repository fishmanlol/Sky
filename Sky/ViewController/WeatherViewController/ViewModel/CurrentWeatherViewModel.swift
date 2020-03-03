//
//  CurrentWeatherViewModel.swift
//  Sky
//
//  Created by tongyi on 2/17/20.
//  Copyright © 2020 tongyi. All rights reserved.
//

import Foundation
import UIKit

struct CurrentWeatherViewModel {
    //MARK: - static property
    static let empty = CurrentWeatherViewModel(weather: WeatherData.empty)
    static let invalid = CurrentWeatherViewModel(weather: WeatherData.invalid)
    
    //MARK: - store property
    var weather: WeatherData
    
    //MARK: - computed property
    var temperature: String {
        return UserDefaults.temperatureMode.format(temperatureInFahrenheit: weather.currently.temperature)
    }
    
    var humudity: String {
        return String(format: "%.1f %%", weather.currently.humidity * 100)
    }
    
    var summary: String {
        return weather.currently.summary
    }
    
    var date: String {
        let formatter = DateFormatter()
        formatter.dateFormat = UserDefaults.dateMode.format
        
        return formatter.string(from: weather.currently.time)
    }
    
    var weatherIcon: UIImage {
        return UIImage.weatherIcon(of: weather.currently.icon)!
    }
    
    var isEmpty: Bool {
        return weather == .empty
    }
    
    var isInvalid: Bool {
        return weather == .invalid
    }
}

extension CurrentWeatherViewModel: Equatable {
    static func ==(lhs: CurrentWeatherViewModel, rhs: CurrentWeatherViewModel) -> Bool {
        return lhs.weather == rhs.weather
    }
}

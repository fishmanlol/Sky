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
    //MARK: - Store property
    var isLocationReady = false
    var isWeatherReady = false
    
    var location: Location! {
        didSet {
            isLocationReady = location != nil
        }
    }
    
    var weather: WeatherData! {
        didSet {
            isWeatherReady = weather != nil
        }
    }
    
    //MARK: - Computed property
    var isUpdateReady: Bool {
        return isLocationReady && isWeatherReady
    }
    
    var city: String {
        return location.name
    }
    
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
}

//
//  WeekDayWeatherViewController.swift
//  Sky
//
//  Created by Yi on 2020/2/21.
//  Copyright © 2020 tongyi. All rights reserved.
//

import Foundation
import UIKit

struct WeekdayWeatherViewModel {
    let data: ForecastData
    
    private let dateFormatter = DateFormatter()
    
    var week: String {
        dateFormatter.dateFormat = "EEEE"
        
        return dateFormatter.string(from: data.time)
    }
    
    var date: String {
        dateFormatter.dateFormat = "MMMM d"
        
        return dateFormatter.string(from: data.time)
    }
    
    var temperature: String {
        let low = UserDefaults.temperatureMode.format(temperatureInFahrenheit: data.temperatureLow)
        let high = UserDefaults.temperatureMode.format(temperatureInFahrenheit: data.temperatureHigh)
        
        return low + " - " + high
    }
    
    var weatherIcon: UIImage? {
        return UIImage.weatherIcon(of: data.icon)
    }
    
    var humidity: String {
        return String(format: "%.0f %%", data.humidity * 100)
    }
}

extension WeekdayWeatherViewModel: WeekdayWeatherRepresentable {}

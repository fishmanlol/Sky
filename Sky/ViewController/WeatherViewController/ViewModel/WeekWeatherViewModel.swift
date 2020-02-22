//
//  WeekWeatherViewModel.swift
//  Sky
//
//  Created by Yi on 2020/2/20.
//  Copyright © 2020 tongyi. All rights reserved.
//
import UIKit
import Foundation

struct WeekWeatherViewModel {
    var weatherData: [ForecastData]!
    
    var isUpdateReady: Bool {
        return weatherData != nil
    }
    
    func weekdayWeatherViewModel(for index: Int) -> WeekdayWeatherViewModel {
        return WeekdayWeatherViewModel(data: weatherData[index])
    }
    
    var numberOfSections: Int {
        return 1
    }
    
    var numberOfDays: Int {
        return weatherData.count
    }
}

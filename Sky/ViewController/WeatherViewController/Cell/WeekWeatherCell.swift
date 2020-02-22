//
//  WeekWeatherCell.swift
//  Sky
//
//  Created by Yi on 2020/2/20.
//  Copyright © 2020 tongyi. All rights reserved.
//

import UIKit

class WeekWeatherCell: UITableViewCell {
    static let identifier = "WeekWeatherCell"
    
    @IBOutlet weak var weekdayLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var humidityLabel: UILabel!
    
    func configure(with vm: WeekdayWeatherRepresentable) {
        dateLabel.text = vm.date
        humidityLabel.text = vm.humidity
        temperatureLabel.text = vm.temperature
        weekdayLabel.text = vm.week
        weatherImageView.image = vm.weatherIcon
    }
}

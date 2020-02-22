//
//  WeekdayWeatherRepresentable.swift
//  Sky
//
//  Created by Yi on 2020/2/21.
//  Copyright © 2020 tongyi. All rights reserved.
//

import Foundation
import UIKit

protocol WeekdayWeatherRepresentable {
    var week: String { get }
    var date: String { get }
    var temperature: String { get }
    var weatherIcon: UIImage? { get }
    var humidity: String { get }
}

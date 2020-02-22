//
//  UserDedaults+.swift
//  Sky
//
//  Created by Yi on 2020/2/21.
//  Copyright © 2020 tongyi. All rights reserved.
//

import Foundation

enum DateMode: Int, CaseIterable {
    case text
    case digit
    
    var format: String {
        switch self {
        case .text:
            return "E, dd MMMM"
        case .digit:
            return "EEEE, MM/dd"
        }
    }
    
    var example: String {
        switch self {
        case .text:
            return "Fri, 01 December"
        case .digit:
            return "F, 12/01"
        }
    }
}

enum TemperatureMode: Int, CaseIterable {
    case celsius
    case fahrenheit
    
    func format(temperatureInFahrenheit: Double) -> String {
        switch self {
        case .celsius:
            return String(format: "%.1f ℃", FToC(f: temperatureInFahrenheit))
        case .fahrenheit:
            return String(format: "%.1f ℉", temperatureInFahrenheit)
        }
    }
    
    var fullName: String {
        switch self {
        case .celsius:
            return "Celsius"
        case .fahrenheit:
            return "Fahrenheit"
        }
    }
}

extension UserDefaults {
    static let dateModeKey = "dateMode"
    static let temperatureModeKey = "temperatureModeKey"
    static let locationsKey = "locationsKey"
    
    static var dateMode: DateMode {
        get {
            let value = UserDefaults.standard.integer(forKey: dateModeKey)
            return DateMode(rawValue: value)!
        }
        
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: dateModeKey)
        }
    }
    
    static var temperatureMode: TemperatureMode {
        get {
            let value = UserDefaults.standard.integer(forKey: temperatureModeKey)
            return TemperatureMode(rawValue: value)!
        }
        
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: temperatureModeKey)
        }
    }
    
    static var locations: [Location] {
        get {
            guard let data = UserDefaults.standard.data(forKey: locationsKey) else {
                print("locations not exist")
                return []
            }
            
            let decoder = PropertyListDecoder()
            var format = PropertyListSerialization.PropertyListFormat.binary
            
            do {
                let locations = try decoder.decode([Location].self, from: data, format: &format)
                return locations
            } catch {
                dump(error)
                return []
            }
        }
        
        set {
            let encoder = PropertyListEncoder()
            encoder.outputFormat = .binary
            
            do {
                let data = try encoder.encode(newValue)
                
                UserDefaults.standard.set(data, forKey: locationsKey)
            } catch {
                dump(error)
            }
        }
    }
    
    static func add(location: Location) {
        var _locations = locations
        guard !_locations.contains(location) else {
            print("location: \(location.name) already exist")
            return
        }
        
        _locations.append(location)
        locations = _locations
    }
    
    static func remove(location: Location) {
        var _locations = locations
        _locations.removeAll { $0 == location }
        locations = _locations
    }
}

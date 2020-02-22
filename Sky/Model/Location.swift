//
//  Location.swift
//  Sky
//
//  Created by tongyi on 2/13/20.
//  Copyright © 2020 tongyi. All rights reserved.
//

import Foundation
import CoreLocation

struct Location: Codable {
    //MARK: - store property
    private var _name: String?
    var latitude: Double
    var longitude: Double
    
    //MARK: - initialization
    init(name: String?, latitude: Double, longitude: Double) {
        self._name = name
        self.latitude = latitude
        self.longitude = longitude
    }
    
    //MARK: - computed property
    var name: String {
        if let _name = _name {
            return _name
        } else {
            return location.toString
        }
    }
    
    var location: CLLocation {
        return CLLocation(latitude: latitude, longitude: longitude)
    }
    
    //MARK: - coding key
    enum CodingKeys: String, CodingKey {
        case _name = "name"
        case latitude
        case longitude
    }
}

extension Location: Equatable {
    static func ==(lhs: Location, rhs: Location) -> Bool {
        return lhs.name == rhs.name &&
            lhs.latitude == rhs.latitude &&
            lhs.longitude == rhs.longitude
    }
}

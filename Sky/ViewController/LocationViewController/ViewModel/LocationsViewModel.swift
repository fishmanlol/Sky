//
//  LocationsViewModel.swift
//  Sky
//
//  Created by Yi on 2020/2/21.
//  Copyright © 2020 tongyi. All rights reserved.
//

import Foundation
import CoreLocation

struct LocationsViewModel {
    let currentLocation: Location?
    
    var locations: [Location] {
        return UserDefaults.locations
    }
    
    func numberOfRows(at section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return locations.count
        }
    }
    
    func numberOfSections() -> Int {
        return 2
    }
    
    func currentLocationVM() -> LocationViewModel? {
        guard let currentLocation = currentLocation else { return nil }
        return LocationViewModel(location: currentLocation)
    }
    
    func favoriteLocationVM(for index: Int) -> LocationViewModel {
        return LocationViewModel(location: locations[index])
    }
    
    func titleForHeaderInCurrentSection() -> String {
        return "Current location"
    }
    
    func titleForHeaderInFavoriteSection() -> String {
        return "Favorite location"
    }
    
    func current() -> Location? {
        return currentLocation
    }
    
    func favorite(for index: Int) -> Location {
        return locations[index]
    }
}


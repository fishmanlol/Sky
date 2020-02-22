//
//  LocationViewModel.swift
//  Sky
//
//  Created by Yi on 2020/2/21.
//  Copyright © 2020 tongyi. All rights reserved.
//

import Foundation
import CoreLocation

struct LocationViewModel {
    let location: Location
    
    var labelText: String {
        return location.name
    }
}

extension LocationViewModel: LocationRepresentable {}

protocol LocationRepresentable {
    var labelText: String { get }
}

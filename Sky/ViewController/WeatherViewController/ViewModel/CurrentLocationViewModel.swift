//
//  CurrentLocationViewModel.swift
//  Sky
//
//  Created by Yi Tong on 2/26/20.
//  Copyright © 2020 tongyi. All rights reserved.
//

import Foundation

struct CurrentLocationViewModel {
    //MARK: - static property
    static let empty = CurrentLocationViewModel(location: Location.empty)
    static let invalid = CurrentLocationViewModel(location: Location.invalid)
    
    //MARK: - property
    private var location: Location
    
    init(location: Location) {
        self.location = location
    }
    
    //MARK: - computed property
    var city: String {
        return location.name
    }
    
    var isEmpty: Bool {
        return location == .empty
    }
    
    var isInvalid: Bool {
        return location == .invalid
    }
}

extension CurrentLocationViewModel: Equatable {
    static func ==(lhs: CurrentLocationViewModel, rhs: CurrentLocationViewModel) -> Bool {
        return lhs.location == rhs.location
    }
}

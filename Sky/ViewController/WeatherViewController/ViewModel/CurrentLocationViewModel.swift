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
    
    //MARK: - property
    private var location: Location
    
    //MARK: - computed property
    var city: String {
        return location.name
    }
    
    var isEmpty: Bool {
        return location == .empty
    }
}

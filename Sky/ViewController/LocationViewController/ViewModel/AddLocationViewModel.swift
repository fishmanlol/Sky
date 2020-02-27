//
//  AddLocationViewModel.swift
//  Sky
//
//  Created by Yi Tong on 2/26/20.
//  Copyright © 2020 tongyi. All rights reserved.
//

import Foundation
import CoreLocation

class AddLocationViewModel {
    
    typealias QueryStatusHandler = (Bool) -> Void
    typealias LocationsHandler = ([Location]) -> Void
    
    //MARK: - property
    private let queue = OperationQueue()
    private let geocoder = CLGeocoder()
    
    var queryText: String = "" {
        didSet {
            geocode(address: queryText)
        }
    }
    
    private(set) var isQuerying = true {
        didSet {
            queryStatusDidChange?(isQuerying )
        }
    }
    
    private var locations: [Location] = [] {
        didSet {
            locationsDidChange?(locations)
        }
    }
    
    var queryStatusDidChange: QueryStatusHandler?
    var locationsDidChange: LocationsHandler?
    
    //MARK: - computed property
    var numberOfLocations: Int {
        return locations.count
    }
    
    var hasLocationsResult: Bool {
        return numberOfLocations > 0
    }
    
    //MARK: - public
    func location(at index: Int) -> Location {
        return locations[index]
    }
    
    func locationViewModel(at index: Int) -> LocationRepresentable {
        let loc = location(at: index)
        return LocationViewModel(location: loc)
    }
    
    //MARK: - helper
    private func geocode(address: String) {
        guard !address.isEmpty else {
            locations = []
            return
        }
        
        queue.addOperation(geocodeOperation(withAddress: address))
    }
    
    private func geocodeOperation(withAddress address: String) -> Operation {
        return BlockOperation { [weak self] in
            guard let strongSelf = self else { return }
            
            strongSelf.isQuerying = true
            
            let sm = DispatchSemaphore(value: 0)
            
            strongSelf.geocoder.geocodeAddressString(address) { [weak self] (placemarks, error) in
                defer { sm.signal() }
                
                strongSelf.isQuerying = false
                
                if let error = error {
                    self?.handleGeocodeOperationErrorResponse(error)
                    return
                }
                
                if let placemarks = placemarks {
                    self?.handleGeocodeOperationSuccessResponse(placemarks)
                    return
                }
            }
            
            sm.wait()
        }
    }
    
    private func handleGeocodeOperationErrorResponse(_ error: Error) {
        dump(error)
    }
    
    private func handleGeocodeOperationSuccessResponse(_ placemarks: [CLPlacemark]) {
        locations = placemarks.compactMap(Location.init)
    }
}

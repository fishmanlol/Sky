//
//  AddLocationViewController.swift
//  Sky
//
//  Created by Yi on 2020/2/21.
//  Copyright © 2020 tongyi. All rights reserved.
//

import UIKit
import CoreLocation

protocol AddLocationViewContronllerProtocol: class {
    func controller(_ controller: AddLocationViewContronller, didAddLocation location: Location)
}

class AddLocationViewContronller: UITableViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    
    private var locations: [Location] = []
    
    private lazy var geocoder = CLGeocoder()
    
    private lazy var operationQueue = OperationQueue()
    
    weak var delegate: AddLocationViewContronllerProtocol?
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        searchBar.becomeFirstResponder()
    }
}

//MARK: - Datasource
extension AddLocationViewContronller {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: LocationCell.identifier, for: indexPath) as? LocationCell else {
            fatalError("Location cell error")
        }
        
        let location = locations[indexPath.row]
        let viewModel = LocationViewModel(location: location)
        
        cell.configure(with: viewModel)
        
        return cell
    }
}

//MARK: - Delegate
extension AddLocationViewContronller {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let location = locations[indexPath.row]
        
        delegate?.controller(self, didAddLocation: location)
        
        navigationController?.popViewController(animated: true)
    }
}

//MARK: - UISearchBarDelegate
extension AddLocationViewContronller: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let geoOperation = geocodeOperation(withAddress: searchText)
        let queue = OperationQueue()
        queue.addOperation(geoOperation)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        locations.removeAll()
        tableView.reloadData()
    }
    
    func geocodeOperation(withAddress address: String) -> Operation {
        return BlockOperation { [weak self] in
            guard let strongSelf = self else { return }
            let sm = DispatchSemaphore(value: 0)
            strongSelf.geocoder.geocodeAddressString(address) { [weak self] (placemarks, error) in
                defer { sm.signal() }
                
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
        print(error.localizedDescription)
        locations.removeAll()
        tableView.reloadData()
    }
    
    private func handleGeocodeOperationSuccessResponse(_ placesmarks: [CLPlacemark]) {
        locations = placesmarks.compactMap(Location.init)
        tableView.reloadData()
    }
}

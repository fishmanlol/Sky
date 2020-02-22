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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
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

//MARK: -
extension AddLocationViewContronller: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let geoOperation = geocodeOperation(withAdress: searchText)
        let reloadOperation = reloadOperation()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        locations = []
        tableView.reloadData()
    }
    
    func geocodeOperation(withAddress address: String) -> Operation {
        return BlockOperation { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.geocoder.geocodeAddressString(<#T##addressString: String##String#>, completionHandler: <#T##CLGeocodeCompletionHandler##CLGeocodeCompletionHandler##([CLPlacemark]?, Error?) -> Void#>)
        }
    }
}

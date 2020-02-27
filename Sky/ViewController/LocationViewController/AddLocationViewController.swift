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
    
    //MARK: - property
    @IBOutlet weak var searchBar: UISearchBar!
    
    private let vm: AddLocationViewModel
    
    weak var delegate: AddLocationViewContronllerProtocol?

    //MARK: - initialization
    init?(coder: NSCoder, vm: AddLocationViewModel) {
        self.vm = vm
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    //MARK: - view life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        vm.locationsDidChange = { [unowned self] (_) in
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
        vm.queryStatusDidChange = { [unowned self] (isQuerying) in
            DispatchQueue.main.async {
                if isQuerying {
                    self.title = "Searching..."
                } else {
                    self.title = "Add a location"
                }
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        searchBar.becomeFirstResponder()
    }
}

//MARK: - Datasource
extension AddLocationViewContronller {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vm.numberOfLocations
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: LocationCell.identifier, for: indexPath) as? LocationCell else {
            fatalError("Location cell error")
        }
        
        let viewModel = vm.locationViewModel(at: indexPath.row)
        
        cell.configure(with: viewModel)
        
        return cell
    }
}

//MARK: - Delegate
extension AddLocationViewContronller {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let location = vm.location(at: indexPath.row)
        
        delegate?.controller(self, didAddLocation: location)
        
        navigationController?.popViewController(animated: true)
    }
}

//MARK: - UISearchBarDelegate
extension AddLocationViewContronller: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        vm.queryText = searchText
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        vm.queryText = ""
    }
}

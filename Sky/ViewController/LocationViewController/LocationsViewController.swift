//
//  LocationsViewController.swift
//  Sky
//
//  Created by Yi on 2020/2/21.
//  Copyright © 2020 tongyi. All rights reserved.
//

import UIKit

protocol LocationsViewControllerProtocol: class {
    func controller(_ controller: LocationsViewController, didSelectLocation location: Location)
}

class LocationsViewController: UITableViewController {
    var vm: LocationsViewModel
    
    weak var delegate: LocationsViewControllerProtocol?
    
    private let addLocationSegue = "AddLocationSegue"
    
    init?(coder: NSCoder, vm: LocationsViewModel) {
        self.vm = vm
        
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    @IBSegueAction
    func makeAddLocationViewController(coder: NSCoder) -> AddLocationViewContronller? {
        return AddLocationViewContronller(coder: coder, vm: AddLocationViewModel())
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }
        
        switch identifier {
        case addLocationSegue:
            guard let destination = segue.destination as? AddLocationViewContronller else {
                fatalError("AddLocationViewContronller config error")
            }
            
            destination.delegate = self
        default:
            break
        }
    }
}

//MARK: - Datasource
extension LocationsViewController {
    enum Section {
        static let current = 0
        static let favorite = 1
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return vm.numberOfSections()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vm.numberOfRows(at: section)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: LocationCell.identifier, for: indexPath) as? LocationCell else {
                fatalError("Location cell error")
        }
        
        let section = indexPath.section
        let row = indexPath.row
        
        if section == Section.current {
            if let viewModel = vm.currentLocationVM() {
                cell.configure(with: viewModel)
            }
        } else if section == Section.favorite {
            let viewModel = vm.favoriteLocationVM(for: row)
            cell.configure(with: viewModel)
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == Section.current {
            return vm.titleForHeaderInCurrentSection()
        } else if section == Section.favorite {
            return vm.titleForHeaderInFavoriteSection()
        } else {
            return nil
        }
    }
}

//MARK: - Delegate
extension LocationsViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = indexPath.section
        let row = indexPath.row
        
        var selectedLocation: Location?
        
        switch section {
        case Section.current:
            selectedLocation = vm.currentLocation
        case Section.favorite:
            selectedLocation = vm.favorite(for: row)
        default:
            break
        }
        
        if let location = selectedLocation {
            delegate?.controller(self, didSelectLocation: location)
            dismiss(animated: true, completion: nil)
        }
    }
}

//MARK: - AddLocationViewContronllerProtocol
extension LocationsViewController: AddLocationViewContronllerProtocol {
    func controller(_ controller: AddLocationViewContronller, didAddLocation location: Location) {
        UserDefaults.add(location: location)
        
        tableView.reloadData()
    }
}

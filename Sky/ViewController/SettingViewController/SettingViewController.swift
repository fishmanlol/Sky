//
//  SettingViewController.swift
//  Sky
//
//  Created by Yi on 2020/2/21.
//  Copyright © 2020 tongyi. All rights reserved.
//

import UIKit

protocol SettingViewControllerDelegate: class {
    func controllerDidChangeDateMode(controller: SettingViewController, to dateMode: DateMode)
    func controllerDidChangeTemperatureMode(controller: SettingViewController, to temperatureMode: TemperatureMode)
}

class SettingViewController: UITableViewController {
    weak var delegate: SettingViewControllerDelegate?
}

//MARK: - Datasource
extension SettingViewController {
    private enum Section: Int, CaseIterable {
        case date
        case temperature
        
        var numberofRows: Int {
            switch self {
            case .date:
                return DateMode.allCases.count
            case .temperature:
                return TemperatureMode.allCases.count
            }
        }
        
        var titleForHeader: String {
            switch self {
            case .date:
                return "Date format"
            case .temperature:
                return "Temperature unit"
            }
        }
        
        static var count: Int {
            return Self.allCases.count
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return Section.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sec = Section(rawValue: section) else {
            fatalError("Unexpected section index")
        }
        
        return sec.numberofRows
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let sec = Section(rawValue: section) else {
            fatalError("Unexpected section index")
        }
        
        return sec.titleForHeader
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: SettingCell.identifier, for: indexPath) as? SettingCell else {
                fatalError("Unexpected cell type")
        }
        
        guard let sec = Section(rawValue: indexPath.section) else {
            fatalError("Unexpected section index")
        }
        
        switch sec {
        case .date:
            guard let dateMode = DateMode(rawValue: indexPath.row) else {
                fatalError("Unexpected row index")
            }
            
            cell.label.text = dateMode.example
            
            if dateMode == UserDefaults.dateMode {
                cell.accessoryType = .checkmark
            } else {
                cell.accessoryType = .none
            }
        case .temperature:
            guard let temperatureMode = TemperatureMode(rawValue: indexPath.row) else {
                fatalError("Unexpected row index")
            }
            
            cell.label.text = temperatureMode.fullName
            
            if temperatureMode == UserDefaults.temperatureMode {
                cell.accessoryType = .checkmark
            } else {
                cell.accessoryType = .none
            }
        }
        
        return cell
    }
}

//MARK: - Delegate
extension SettingViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let sec = Section(rawValue: indexPath.section) else {
            fatalError("Unexpected section index")
        }
        
        switch sec {
        case .date:
            guard let dateMode = DateMode(rawValue: indexPath.row) else {
                fatalError("Unexpected row index")
            }
            
            UserDefaults.dateMode = dateMode
            
            delegate?.controllerDidChangeDateMode(controller: self, to: dateMode)
        case .temperature:
            guard let temperatureMode = TemperatureMode(rawValue: indexPath.row) else {
                fatalError("Unexpected row index")
            }
            
            UserDefaults.temperatureMode = temperatureMode
            
            delegate?.controllerDidChangeTemperatureMode(controller: self, to: temperatureMode)
        }
        
        let sections = IndexSet(integer: indexPath.section)
        tableView.reloadSections(sections, with: .none)
    }
}

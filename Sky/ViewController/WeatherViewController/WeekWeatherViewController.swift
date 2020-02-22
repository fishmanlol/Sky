//
//  WeekViewController.swift
//  Sky
//
//  Created by Yi on 2020/2/20.
//  Copyright © 2020 tongyi. All rights reserved.
//

import UIKit

class WeekWeatherViewController: WeatherViewController {

    @IBOutlet weak var weekWeatherTableView: UITableView!
    
    var vm: WeekWeatherViewModel {
        didSet {
            DispatchQueue.main.async {
                self.updateView()
            }
        }
    }
    
    //MARK: - Initialization
    init?(coder: NSCoder, vm: WeekWeatherViewModel) {
        self.vm = vm
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: - Helper
    func updateView() {
        if vm.isUpdateReady {
            updateWeatherDataContainer()
        } else {
            showLoadingFailure()
        }
    }
    
    private func updateWeatherDataContainer() {
        weatherContainerView.isHidden = false
        weekWeatherTableView.reloadData()
    }
}

//MARK: - UITableViewDataSource
extension WeekWeatherViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vm.numberOfDays
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: WeekWeatherCell.identifier, for: indexPath) as! WeekWeatherCell
        
        let weekdayWeatherVM = vm.weekdayWeatherViewModel(for: indexPath.row)
        cell.configure(with: weekdayWeatherVM)
        return cell
    }
}

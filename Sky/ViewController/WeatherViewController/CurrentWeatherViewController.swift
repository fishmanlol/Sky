//
//  CurrentWeatherViewController.swift
//  Sky
//
//  Created by tongyi on 2/16/20.
//  Copyright © 2020 tongyi. All rights reserved.
//

import UIKit

protocol CurrentWeatherViewControllerProtocol: class {
    func locationButtonTapped(controller: CurrentWeatherViewController)
    func settingButtonTapped(controller: CurrentWeatherViewController)
}

class CurrentWeatherViewController: WeatherViewController {
    //MARK: - Views
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    //MARK: - Properties
    weak var delegate: CurrentWeatherViewControllerProtocol?
    
    var vm: CurrentWeatherViewModel {
        didSet {
            DispatchQueue.main.async {
                self.updateView()
            }
        }
    }
    
    //MARK: - Initialization
    init(vm: CurrentWeatherViewModel) {
        self.vm = vm
        super.init(nibName: nil, bundle: nil)
    }
    
    init?(coder: NSCoder, vm: CurrentWeatherViewModel) {
        self.vm = vm
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    //MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: - Action
    @IBAction func locationBtTapped(_ sender: UIButton) {
        delegate?.locationButtonTapped(controller: self)
    }
    
    @IBAction func settingBtTapped(_ sender: UIButton) {
        delegate?.settingButtonTapped(controller: self)
    }
    
    //MARK: - Helper
    private func updateView() {
        activityIndicatorView.stopAnimating()
        
        if vm.isUpdateReady {
            updateWeatherContainer()
        } else {
            loadingFailedLabel.isHidden = false
            loadingFailedLabel.text = "Fetch weather/location failed"
        }
    }

    private func updateWeatherContainer() {
        weatherContainerView.isHidden = false
        
        locationLabel.text = vm.city
        
        temperatureLabel.text = vm.temperature
        
        weatherIcon.image = vm.weatherIcon
        
        summaryLabel.text = vm.summary
        
        dateLabel.text = vm.date
    }
}

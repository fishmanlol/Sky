//
//  CurrentWeatherViewController.swift
//  Sky
//
//  Created by tongyi on 2/16/20.
//  Copyright © 2020 tongyi. All rights reserved.
//

import UIKit
import RxSwift
import RxRelay

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
    
    private var weatherVM = BehaviorRelay(value: CurrentWeatherViewModel.empty)
    private var locationVM = BehaviorRelay(value: CurrentLocationViewModel.empty)
    private let bag = DisposeBag()
    
    
    //MARK: - Initialization
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    //MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        Observable<(CurrentWeatherViewModel, CurrentLocationViewModel)>.combineLatest(weatherVM, locationVM, resultSelector: { (v1, v2) -> (CurrentWeatherViewModel, CurrentLocationViewModel) in
            return (v1, v2)
        })
        .filter {
            let a = $0
            
            let (location, weather) = $0
            return !location.isEmpty && !weather.isEmpty
        }
        .observeOn(MainScheduler.instance)
        .subscribe(onNext: { [unowned self] in
            let
            }).disposed(by: bag)
        
    }
    
    //MARK: - Action
    @IBAction func locationBtTapped(_ sender: UIButton) {
        delegate?.locationButtonTapped(controller: self)
    }
    
    @IBAction func settingBtTapped(_ sender: UIButton) {
        delegate?.settingButtonTapped(controller: self)
    }
    
    //MARK: - Helper
    func updateView() {
        activityIndicatorView.stopAnimating()
        
        if vm.isUpdateReady {
            updateWeatherContainer()
        } else {
            showLoadingFailure()
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

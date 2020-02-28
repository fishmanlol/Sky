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
    
    var weatherVM = BehaviorRelay(value: CurrentWeatherViewModel.empty)
    var locationVM = BehaviorRelay(value: CurrentLocationViewModel.empty)
    private let bag = DisposeBag()
    
    
    //MARK: - Initialization
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    //MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        let viewModel = Observable.combineLatest(locationVM, weatherVM) { ($0, $1) }
            .filter {
                let (location, weather) = $0
                return !location.isEmpty && !weather.isEmpty
            }
            .share(replay: 1, scope: .whileConnected)
            .asDriver(onErrorJustReturn: (CurrentLocationViewModel.empty, CurrentWeatherViewModel.empty))
        
        viewModel.map { _ in false }.drive(self.activityIndicatorView.rx.isAnimating).disposed(by: bag)
        viewModel.map { _ in false }.drive(self.weatherContainerView.rx.isHidden).disposed(by: bag)
        
        viewModel.map { $0.0.city }.drive(self.locationLabel.rx.text).disposed(by: bag)
        
        viewModel.map { $0.1.date }.drive(self.dateLabel.rx.text).disposed(by: bag)
        viewModel.map { $0.1.summary }.drive(self.summaryLabel.rx.text).disposed(by: bag)
        viewModel.map { $0.1.humudity }.drive(self.humidityLabel.rx.text).disposed(by: bag)
        viewModel.map { $0.1.weatherIcon }.drive(self.weatherIcon.rx.image).disposed(by: bag)
        viewModel.map { $0.1.temperature }.drive(self.temperatureLabel.rx.text).disposed(by: bag)
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
        weatherVM.accept(weatherVM.value)
        locationVM.accept(locationVM.value)
    }
}

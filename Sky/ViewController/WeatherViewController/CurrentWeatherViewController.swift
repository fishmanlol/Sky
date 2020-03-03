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
    @IBOutlet weak var retryButton: UIButton!
    
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
        
        let state = Observable.combineLatest(locationVM, weatherVM)
            .share(replay: 1, scope: .whileConnected)
            .map { (self.decide(locationVM: $0, weatherVM: $1), $0, $1) }
        
        let success = state.filter { $0.0 == .success }.map { ($0.1, $0.2) }.asDriver(onErrorJustReturn: (.invalid, .invalid))
        let failure = state.filter { $0.0 == .failure }.map { _ in }.asDriver(onErrorJustReturn: ())
        let uncertain = state.filter { $0.0 == .uncertain }.map { _ in }.asDriver(onErrorJustReturn: ())
        
        success.map { _ in false }.drive(self.activityIndicatorView.rx.isAnimating).disposed(by: bag)
        success.map { _ in false }.drive(self.weatherContainerView.rx.isHidden).disposed(by: bag)
        success.map { $0.0.city }.drive(self.locationLabel.rx.text).disposed(by: bag)
        success.map { $0.1.date }.drive(self.dateLabel.rx.text).disposed(by: bag)
        success.map { $0.1.summary }.drive(self.summaryLabel.rx.text).disposed(by: bag)
        success.map { $0.1.humudity }.drive(self.humidityLabel.rx.text).disposed(by: bag)
        success.map { $0.1.weatherIcon }.drive(self.weatherIcon.rx.image).disposed(by: bag)
        success.map { $0.1.temperature }.drive(self.temperatureLabel.rx.text).disposed(by: bag)
        
        failure.asDriver(onErrorJustReturn: ())
            .map { _ in true }
            .drive(self.weatherContainerView.rx.isHidden)
            .disposed(by: bag)
        
        failure.asDriver(onErrorJustReturn: ())
            .map { _ in true }
            .drive(self.activityIndicatorView.rx.isHidden)
            .disposed(by: bag)
        
        failure.asDriver(onErrorJustReturn: ())
            .map { _ in "Something error..." }
            .drive(self.loadingFailedLabel.rx.text)
            .disposed(by: bag)
        
        failure.asDriver(onErrorJustReturn: ())
            .map { _ in false }
            .drive(self.loadingFailedLabel.rx.isHidden)
            .disposed(by: bag)
        
        failure.asDriver(onErrorJustReturn: ())
            .map { _ in false }
            .drive(self.retryButton.rx.isHidden)
            .disposed(by: bag)
        
        uncertain.asDriver(onErrorJustReturn: ())
            .map { _ in false }
            .drive(self.activityIndicatorView.rx.isHidden)
            .disposed(by: bag)
        
        uncertain.asDriver(onErrorJustReturn: ())
            .map { _ in true }
            .drive(self.weatherContainerView.rx.isHidden)
            .disposed(by: bag)
        
        uncertain.asDriver(onErrorJustReturn: ())
            .map { _ in true }
            .drive(self.loadingFailedLabel.rx.isHidden)
            .disposed(by: bag)
        
        uncertain.asDriver(onErrorJustReturn: ())
            .map { _ in true }
            .drive(self.retryButton.rx.isHidden)
            .disposed(by: bag)
        
        self.retryButton.rx.tap.subscribe(onNext: { _ in
            self.weatherVM.accept(.empty)
            self.locationVM.accept(.empty)
            
            (self.parent as? RootViewController)?.fetchCity()
            (self.parent as? RootViewController)?.fetchWeather()
        }).disposed(by: bag)
    }
    
    //MARK: - Public
    func updateView() {
        weatherVM.accept(weatherVM.value)
        locationVM.accept(locationVM.value)
    }
    
    //MARK: - Action
    @IBAction func locationBtTapped(_ sender: UIButton) {
        delegate?.locationButtonTapped(controller: self)
    }
    
    @IBAction func settingBtTapped(_ sender: UIButton) {
        delegate?.settingButtonTapped(controller: self)
    }
}

//MARK: - Helper
fileprivate extension CurrentWeatherViewController {
    func decide(locationVM: CurrentLocationViewModel, weatherVM: CurrentWeatherViewModel) -> State {
        if locationVM.isInvalid || weatherVM.isInvalid {
            return .failure
        } else if !locationVM.isEmpty && !weatherVM.isEmpty {
            return .success
        } else {
            return .uncertain
        }
    }
    
    enum State {
        case success
        case failure
        case uncertain
    }
}

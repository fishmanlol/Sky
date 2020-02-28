//
//  ViewController.swift
//  Sky
//
//  Created by tongyi on 2/13/20.
//  Copyright © 2020 tongyi. All rights reserved.
//

import UIKit
import CoreLocation
import RxSwift

class RootViewController: UIViewController {
    
    var currentWeatherViewController: CurrentWeatherViewController!
    var weekWeatherViewController: WeekWeatherViewController!
    
    private let currentWeatherSegue = "CurrentWeatherSegue"
    private let weekWeatherSegue = "WeekWeatherSegue"
    private let settingSegue = "SettingSegue"
    private let locationsSegue = "LocationsSegue"
    
    private var currentLocation: CLLocation? {
        didSet {
            fetchCity()
            fetchWeather()
        }
    }
    
    private var _currentLocation: Location?
    private let bag = DisposeBag()
    
    private lazy var locationManager: CLLocationManager = {
       let manager = CLLocationManager()
        manager.distanceFilter = 1000
        manager.desiredAccuracy = 1000
        return manager
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupActiveNotification()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }
        
        switch identifier {
        case currentWeatherSegue:
            guard let currentWeatherViewController = segue.destination as? CurrentWeatherViewController else {
                fatalError("CurrentWeatherViewController downcast error")
            }
            
            self.currentWeatherViewController = currentWeatherViewController
            self.currentWeatherViewController.delegate = self
        case weekWeatherSegue:
            guard let weekWeatherViewController = segue.destination as? WeekWeatherViewController else {
                fatalError("WeekWeatherViewController downcast error")
            }
            
            self.weekWeatherViewController = weekWeatherViewController
        case settingSegue:
            guard let navigationController = segue.destination as? UINavigationController,
                let settingViewController = navigationController.topViewController as? SettingViewController else {
                fatalError("SettingViewController downcast error")
            }

            settingViewController.delegate = self
        case locationsSegue:
            guard let navigationController = segue.destination as? UINavigationController,
                let locationsViewController = navigationController.topViewController as? LocationsViewController else {
                fatalError("LocationsViewController downcast error")
            }
        default:
            break
        }
    }
    
    @IBSegueAction
    func makeCurrentWeatherViewController(coder: NSCoder, sender: Any?, segueIdentifier: String?) -> CurrentWeatherViewController? {
        return nil
    }
    
    @IBSegueAction
    func makeWeekWeatherViewController(coder: NSCoder, sender: Any?, segueIdentifier: String?) -> WeekWeatherViewController? {
        return WeekWeatherViewController(coder: coder, vm: WeekWeatherViewModel(weatherData: []))
    }
    
    @IBSegueAction
    func makeLocationsViewController(coder: NSCoder) -> LocationsViewController? {
        return LocationsViewController(coder: coder, vm: LocationsViewModel(currentLocation: _currentLocation))
    }
    
    @IBAction func unwindToRootViewController(segue: UIStoryboardSegue) {}
    
    @objc func applicationDidBecomeActive(no: Notification) {
        //Request user's location
        requestLocation()
    }
    
    //MARK: - Helper
    private func fetchWeather() {
        guard let currentLocation = currentLocation else { return }
        
        let lat = currentLocation.coordinate.latitude
        let lon = currentLocation.coordinate.longitude
        
        let weather = WeatherDataManager.shared.weatherDataAt(latitude: lat, longitude: lon)
            .share(replay: 1, scope: .whileConnected)
            .observeOn(MainScheduler.instance)
        
        weather.map { CurrentWeatherViewModel(weather: $0) }
            .bind(to: self.currentWeatherViewController.weatherVM )
            .disposed(by: bag)
        
        weather.map { WeekWeatherViewModel(weatherData: $0.daily.data) }
            .subscribe(onNext: {
                self.weekWeatherViewController.vm = $0
            })
            .disposed(by: bag)
    }
    
    private func fetchCity() {
        guard let currentLocation = currentLocation else { return }
        
        CLGeocoder().reverseGeocodeLocation(currentLocation) { (placemarks, error) in
            if let error = error {
                dump(error)
            } else if let city = placemarks?.first?.locality {
                let location = Location(name: city, latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude)
                self._currentLocation = location
                self.currentWeatherViewController.locationVM.accept(CurrentLocationViewModel(location: location))
            }
        }
    }
    
    private func requestLocation() {
        locationManager.delegate = self
        
        guard CLLocationManager.authorizationStatus() == .authorizedWhenInUse else {
            locationManager.requestWhenInUseAuthorization()
            return
        }
        
        locationManager.startUpdatingLocation()
        locationManager.rx.didUpdateLocations
            .take(1)
            .map { $0.first }
            .subscribe(onNext: { self.currentLocation = $0 })
            .disposed(by: bag)
    }
    
    private func setupActiveNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
}

//MARK: - CLLocationManagerDelegate
extension RootViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            currentLocation = location
            manager.delegate = nil
            
            manager.stopUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            manager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}

//MARK: - CurrentWeatherViewControllerProtocol
extension RootViewController: CurrentWeatherViewControllerProtocol {
    func locationButtonTapped(controller: CurrentWeatherViewController) {
        performSegue(withIdentifier: locationsSegue, sender: nil)
    }
    
    func settingButtonTapped(controller: CurrentWeatherViewController) {
        performSegue(withIdentifier: settingSegue, sender: nil)
    }
}

//MARK: - SettingViewControllerDelegate
extension RootViewController: SettingViewControllerDelegate {
    func controllerDidChangeDateMode(controller: SettingViewController, to dateMode: DateMode) {
        reloadUI()
    }
    
    func controllerDidChangeTemperatureMode(controller: SettingViewController, to temperatureMode: TemperatureMode) {
        reloadUI()
    }
    
    private func reloadUI() {
        currentWeatherViewController.updateView()
        weekWeatherViewController.updateView()
    }
}

//MARK: -
extension RootViewController: LocationsViewControllerProtocol {
    func controller(_ controller: LocationsViewController, didSelectLocation location: Location) {
        
    }
}

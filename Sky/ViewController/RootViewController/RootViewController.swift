//
//  ViewController.swift
//  Sky
//
//  Created by tongyi on 2/13/20.
//  Copyright © 2020 tongyi. All rights reserved.
//

import UIKit
import CoreLocation

class RootViewController: UIViewController {
    
    var currentWeatherViewController: CurrentWeatherViewController!
    private let currentWeatherSegue = "CurrentWeatherSegue"
    
    private var currentLocation: CLLocation? {
        didSet {
            fetchCity()
            fetchWeather()
        }
    }
    
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
            currentWeatherViewController = segue.destination as? CurrentWeatherViewController
            currentWeatherViewController.delegate = self
        default:
            break
        }
    }
    
    @IBSegueAction
    func makeCurrentWeatherViewController(coder: NSCoder, sender: Any?, segueIdentifier: String?) -> CurrentWeatherViewController? {
        return CurrentWeatherViewController(coder: coder, vm: CurrentWeatherViewModel())
    }
    
    @objc func applicationDidBecomeActive(no: Notification) {
        //Request user's location
        requestLocation()
    }
    
    private func fetchWeather() {
        guard let currentLocation = currentLocation else { return }
        
        let lat = currentLocation.coordinate.latitude
        let lon = currentLocation.coordinate.longitude
        
        WeatherDataManager.shared.weatherDataAt(latitude: lat, longitude: lon) { (weather, error) in
            if let error = error {
                dump(error)
            } else if let weather = weather {
                self.currentWeatherViewController.vm.weather = weather
            }
        }
    }
    
    private func fetchCity() {
        guard let currentLocation = currentLocation else { return }
        
        CLGeocoder().reverseGeocodeLocation(currentLocation) { (placemarks, error) in
            if let error = error {
                dump(error)
            } else if let city = placemarks?.first?.locality {
                let location = Location(name: city, latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude)
                self.currentWeatherViewController.vm.location = location
            }
        }
    }
    
    private func requestLocation() {
        locationManager.delegate = self
        
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            locationManager.requestLocation()
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    private func setupActiveNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
}

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


extension RootViewController: CurrentWeatherViewControllerProtocol {
    func locationButtonTapped(controller: CurrentWeatherViewController) {
        print(#function)
    }
    
    func settingButtonTapped(controller: CurrentWeatherViewController) {
        print(#function)
    }
}

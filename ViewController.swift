//
//  ViewController.swift
//  WeatherApp
//
//  Created by Vadim Labun on 9/19/19.
//  Copyright © 2019 Vadim Labun. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet var LocationLable: UILabel!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var presureLeble: UILabel!
    @IBOutlet var humidityLable: UILabel!
    @IBOutlet var temperatyreLable: UILabel!
    @IBOutlet var appirentTemperatyreLablr: UILabel!
    @IBOutlet var refreshButton: UIButton!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    let locationManager = CLLocationManager()
    
    lazy var WeatherManager = APIWeatherManager(apiKey: "df84e1cdfd8b89110d2134c8b92a7870")
    let coordinate = Coordinates(latitude: 53.939603, longitude: 27.464110)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        getCurrentWeather()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation = locations.last! as CLLocation
        print("My location \(userLocation.coordinate.latitude), \(userLocation.coordinate.longitude) ")
    }
    
    func togglrActivityIndicator(on: Bool) {
        refreshButton.isHidden = on
        if on {
            activityIndicator.startAnimating()
        }else {
            activityIndicator.stopAnimating()
        }
    }
    
    func getCurrentWeather() {
        WeatherManager.fetchCurrentWeatherWith(coordinats: coordinate) { (result) in
            self.togglrActivityIndicator(on: false)
            switch result {
            case .Success(let currentWeather):
                self.updateUIWith(curretWather: currentWeather)
            case .Failure(let error as NSError):
                let alert = UIAlertController(title: "Unable get data", message: "\(error.localizedDescription)", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
            }
        }
    }

    @IBAction func refreshAktionButton(_ sender: Any) {
        togglrActivityIndicator(on: true)
        getCurrentWeather()
    }
    
    func updateUIWith(curretWather: CurrentWeather) {
        self.imageView.image = curretWather.icon
        self.presureLeble.text = curretWather.pressureString
        self.humidityLable.text = curretWather.humidityString
        self.temperatyreLable.text = curretWather.temperatureString
        self.appirentTemperatyreLablr.text = curretWather.appirentTemperatureString
    }
    
}

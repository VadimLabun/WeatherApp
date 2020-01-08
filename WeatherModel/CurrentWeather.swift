//
//  CurrentWeather.swift
//  WeatherApp
//
//  Created by Vadim Labun on 9/19/19.
//  Copyright © 2019 Vadim Labun. All rights reserved.
//

import Foundation
import UIKit

struct CurrentWeather {
    let temperature: Double
    let appearentTemperatura: Double
    let humiditi: Double
    let pressure: Double
    let icon: UIImage
}
extension CurrentWeather: JSONDecodoble {
    init?(JSON: [String : AnyObject]) {
        guard let temperature = JSON["temperature"] as? Double,
        let appearentTemperatura = JSON["apparentTemperature"] as? Double,
        let humiditi = JSON["humidity"] as? Double,
        let pressure = JSON["pressure"] as? Double,
            let iconString = JSON["icon"] as? String else {
                return nil
        }
        let icon = WeatherIconManager(rawValue: iconString).image
        self.temperature = temperature
        self.appearentTemperatura = appearentTemperatura
        self.humiditi = humiditi
        self.pressure = pressure
        self.icon = icon
    }
    
    
}

extension CurrentWeather {
    var pressureString: String {
        return "\(Int((pressure) * 0.75006375541921))mm"
    }
    var humidityString: String {
        return "\(Int(humiditi * 100))%"
    }
    var temperatureString: String {
        return "\(((Int(temperature) - 32) * 5/9))˚C"
    }
    var appirentTemperatureString: String {
        return "Feels like:\(((Int(appearentTemperatura) - 32) * 5/9))˚C"
    }
}


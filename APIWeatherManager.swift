//
//  APIWeatherManager.swift
//  WeatherApp
//
//  Created by Vadim Labun on 9/20/19.
//  Copyright © 2019 Vadim Labun. All rights reserved.
//

import Foundation

struct Coordinates {
    let latitude: Double
    let longitude: Double
}
enum ForecastType: FinalUrlPoint {
    var baseUrl: URL {
        return URL(string: "https://api.forecast.io")!
    }
    
    var patch: String {
        switch self {
        case .Current(let apiKey, let coordinats):
            return "/forecast/\(apiKey)/\(coordinats.latitude),\(coordinats.longitude)"
        }
    }
    
    var request: URLRequest {
        let url = URL(string: patch, relativeTo: baseUrl)
        return URLRequest(url: url!)
    }
    
    case Current(apiKey: String, coordinats: Coordinates)
}


final class APIWeatherManager: APIManager {
    
    var sessionConfiguration: URLSessionConfiguration
    lazy var session: URLSession = {
        return URLSession(configuration: self.sessionConfiguration)
    } ()
    
    var apiKey: String
    init(sessionConfiguration: URLSessionConfiguration, apiKey: String) {
        self.sessionConfiguration = sessionConfiguration
        self.apiKey = apiKey
    }
    convenience init(apiKey: String) {
        self.init(sessionConfiguration: URLSessionConfiguration.default, apiKey: apiKey)
    }
    
    func fetchCurrentWeatherWith(coordinats: Coordinates, completion: @escaping (APIResult<CurrentWeather>) -> Void) {
        let request = ForecastType.Current(apiKey: self.apiKey, coordinats: coordinats).request
        fetch(request: request, parse: { (json) -> CurrentWeather? in
            if let dictionari = json["currently"] as? [String:AnyObject] {
               return CurrentWeather(JSON: dictionari)
            }else {
                return nil
            }
        }, comrletionHandler: completion)
    }
    
}


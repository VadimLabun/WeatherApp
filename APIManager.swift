//
//  APIManager.swift
//  WeatherApp
//
//  Created by Vadim Labun on 9/20/19.
//  Copyright © 2019 Vadim Labun. All rights reserved.
//

import Foundation

typealias JSONTask = URLSessionDataTask
typealias JSONComrletionHandler = ([String:AnyObject]?,HTTPURLResponse?, Error?) -> Void

protocol JSONDecodoble {
    init?(JSON: [String:AnyObject])
}

protocol FinalUrlPoint {
    var baseUrl: URL { get }
    var patch: String { get }
    var request: URLRequest { get }
}

enum APIResult<T> {
    case Success(T)
    case Failure(Error)
}

protocol APIManager {
    var sessionConfiguration: URLSessionConfiguration { get }
    var session: URLSession { get }
    
    func JSONTaskWith(request: URLRequest, comrletionHandler: @escaping JSONComrletionHandler) -> JSONTask
    func fetch<T: JSONDecodoble>(request: URLRequest, parse: @escaping ([String:AnyObject]) -> T?, comrletionHandler: @escaping (APIResult<T>) -> Void )
    
}

extension APIManager {
    func JSONTaskWith(request: URLRequest, comrletionHandler: @escaping JSONComrletionHandler) -> JSONTask {
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            guard let HTTPResponse = response as? HTTPURLResponse else {
                let userInfo = [
                    NSLocalizedDescriptionKey:NSLocalizedString("Missing HTTP Response", comment: "")]
                
                let error = NSError(domain: SWINetworkingErrorDomain, code: 100, userInfo: userInfo)
                comrletionHandler(nil, nil, error)
                return
            }
            if data == nil {
                if let error = error {
                    comrletionHandler(nil, HTTPResponse, error)
                }
            } else {
                switch HTTPResponse.statusCode {
                case 200:
                    do {
                        let json = try JSONSerialization.jsonObject(with: data!, options: []) as? [String:AnyObject]
                        comrletionHandler(json, HTTPResponse, nil)
                    }catch let error as NSError {
                        comrletionHandler(nil, HTTPResponse, error)
                    }
                default:
                    print("We have got response status \(HTTPResponse.statusCode)")
                }
            }
        }
        return dataTask
    }
    
    func fetch<T>(request: URLRequest, parse: @escaping ([String:AnyObject]) -> T?, comrletionHandler: @escaping (APIResult<T>) -> Void ) {
        let dataTask = JSONTaskWith(request: request) { (json, response, error) in
            DispatchQueue.main.async {
                guard let json = json else {
                    if let error = error {
                        comrletionHandler(.Failure(error))
                    }
                    return
                }
                if let value = parse(json) {
                    comrletionHandler(.Success(value))
                }else {
                    let error = NSError(domain: SWINetworkingErrorDomain, code: 200, userInfo: nil)
                    comrletionHandler(.Failure(error))
                }
                
            }
        }
        dataTask.resume()
    }
}

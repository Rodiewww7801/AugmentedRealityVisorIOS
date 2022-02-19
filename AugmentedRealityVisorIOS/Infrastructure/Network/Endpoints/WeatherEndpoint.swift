//
//  WeatherEndpoint.swift
//  VirtualSupervisorIOS
//
//  Created by Rodion Hladchenko on 10.02.2022.
//

import Foundation
import Alamofire

enum WeatherEndpoint: Endpoint {
    case GetWeather(String)
    
    var path: String {
        switch self {
        case .GetWeather(let city): return "?q=\(city)" + Constants.apiKey
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .GetWeather(_): return .get
        }
    }
}

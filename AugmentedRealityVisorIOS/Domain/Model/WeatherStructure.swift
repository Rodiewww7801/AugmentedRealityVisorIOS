//
//  WeatherStructure.swift
//  VirtualSupervisorIOS
//
//  Created by Rodion Hladchenko on 10.02.2022.
//

import Foundation

struct WeatherStructure: Identifiable {
    let weatherMain: WeatherMain
    let weather: Weather?
    let city: String
    
    let id = UUID()
}

struct WeatherMain {
    let temp: Double
}

struct Weather {
    let main: String
}

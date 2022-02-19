//
//  WeatherDTO.swift
//  VirtualSupervisorIOS
//
//  Created by Rodion Hladchenko on 10.02.2022.
//

import Foundation

struct WeatherStructureDTO: Decodable {
    let weather: [WeatherDTO]
    let weatherMain: WeatherMainDTO
    let city: String
    
    private enum CodingKeys: String, CodingKey {
        case weather = "weather"
        case weatherMain = "main"
        case city = "name"
    }
}

struct WeatherMainDTO: Decodable {
    let temp: Double
    
    private enum CodingKeys: String, CodingKey {
        case temp = "temp"
    }
}

struct WeatherDTO: Decodable {
    let main: String
    
    private enum CodingKeys: String, CodingKey {
        case main = "main"
    }
}

extension WeatherStructureDTO {
    func toModel() -> WeatherStructure {
        return .init(weatherMain: weatherMain.toModel(),
                     weather: weather.first?.toModel(),
                     city: city)
    }
}

extension WeatherMainDTO {
    func toModel() -> WeatherMain {
        return .init(temp: temp)
    }
}

extension WeatherDTO {
    func toModel() -> Weather {
        return .init(main: main)
    }
}

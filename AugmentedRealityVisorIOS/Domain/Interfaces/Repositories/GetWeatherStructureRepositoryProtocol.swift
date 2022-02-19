//
//  GetWeatherStructureRepositoryProtocol.swift
//  VirtualSupervisorIOS
//
//  Created by Rodion Hladchenko on 10.02.2022.
//

import Foundation
import Combine

protocol GetWeatherStructureRepositoryProtocol {
    func getWeatherStructure(city: String) -> AnyPublisher<WeatherStructure, AppError>
}

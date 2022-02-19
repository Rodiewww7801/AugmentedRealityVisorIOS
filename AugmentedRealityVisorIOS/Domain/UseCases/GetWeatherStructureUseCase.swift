//
//  GetWeatherStructureUseCase.swift
//  VirtualSupervisorIOS
//
//  Created by Rodion Hladchenko on 19.02.2022.
//

import Foundation
import Combine

protocol GetWeatherStructureUseCaseProtocol {
    func execute(city: String) -> AnyPublisher<WeatherStructure, AppError>
}

final class GetWeatherStructureUseCase: GetWeatherStructureUseCaseProtocol {
    let getWeatherStructureRepository: GetWeatherStructureRepositoryProtocol
    
    init(getWeatherStructureRepository: GetWeatherStructureRepositoryProtocol) {
        self.getWeatherStructureRepository = getWeatherStructureRepository
    }
    
    func execute(city: String) -> AnyPublisher<WeatherStructure, AppError> {
        getWeatherStructureRepository.getWeatherStructure(city: city)
    }
}

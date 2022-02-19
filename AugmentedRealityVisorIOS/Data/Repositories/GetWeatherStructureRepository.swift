//
//  GetWeatherStructureRepository.swift
//  VirtualSupervisorIOS
//
//  Created by Rodion Hladchenko on 10.02.2022.
//

import Foundation
import Combine
import Alamofire

final class GetWeatherStructureRepository: GetWeatherStructureRepositoryProtocol {
    let networkService: PublishableNetworkServiceProtocol
    
    init(networkService: PublishableNetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    func getWeatherStructure(city: String) -> AnyPublisher<WeatherStructure, AppError> {
        let result: AnyPublisher<WeatherStructureDTO, AppError> =
        networkService.request(
            domain: Constants.serverURL,
            endpoint: WeatherEndpoint.GetWeather(city),
            headers: nil,
            parameters: nil,
            encoding: nil)
        
        return result.flatMap { dto -> Future<WeatherStructure, AppError> in
            Future<WeatherStructure, AppError> { promise in
                let weatherStructure = dto.toModel()
                promise(.success(weatherStructure))
            }
        }.eraseToAnyPublisher()
    }
}

//
//  WeatherViewFactory.swift
//  VirtualSupervisorIOS
//
//  Created by Rodion Hladchenko on 19.02.2022.
//

import Foundation
import SwiftUI

final class WeatherViewFactory {
    //MARK: - Services
    private let networkService: PublishableNetworkServiceProtocol = NetworkService.shared
    
    //MARK: - Repositories
    private func makeGetWeatherStructureRepository() -> GetWeatherStructureRepositoryProtocol {
        GetWeatherStructureRepository(networkService: networkService)
    }
    
    //MARK: - Use Cases
    private func makeGetWeatherStructureUseCase() -> GetWeatherStructureUseCaseProtocol {
        GetWeatherStructureUseCase(getWeatherStructureRepository: makeGetWeatherStructureRepository())
    }
    
    //MARK: - Views
    func makeWeatherView() -> some View {
        WeatherView(wheatherViewModel: makeWeatherViewModel())
    }
    private func makeWeatherViewModel() -> WeatherViewModel {
        WeatherViewModel(getWeatherStructureUseCase: makeGetWeatherStructureUseCase())
    }
}

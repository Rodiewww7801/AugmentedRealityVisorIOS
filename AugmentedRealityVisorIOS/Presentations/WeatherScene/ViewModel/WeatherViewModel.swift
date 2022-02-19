//
//  WeatherViewModel.swift
//  VirtualSupervisorIOS
//
//  Created by Rodion Hladchenko on 19.02.2022.
//

import Foundation
import Combine

final class WeatherViewModel: ObservableObject {
    @Published var weatherStructure: WeatherStructure?
    @Published var city: String = "Kyiv"
    var isLoading: Bool = false
    
    private let getWeatherStructureUseCase: GetWeatherStructureUseCaseProtocol
    private var subscriptions = Set<AnyCancellable>()
    
    init(getWeatherStructureUseCase: GetWeatherStructureUseCaseProtocol) {
        self.getWeatherStructureUseCase = getWeatherStructureUseCase
        
        $city
            .sink(receiveValue: getWeather(_:))
            .store(in: &subscriptions)
    }
    
    func getWeather(_ city: String) {
        isLoading = true
        
        getWeatherStructureUseCase.execute(city: city)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                self?.isLoading = false
            }, receiveValue: { [weak self] value in
                self?.weatherStructure = value
            }).store(in: &subscriptions)
    }
}

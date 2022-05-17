//
//  AnalyzerSceneFactory.swift
//  AugmentedRealityVisorIOS
//
//  Created by Rodion Hladchenko on 15.04.2022.
//

import Foundation
import SwiftUI
import Combine

final class AnalyzerSceneFactory: ObservableObject {
    private let mqttManager = MQTTManager.shared()
    
    //MARK: - Repositories
    private func makeGetMQTTObjectsValuesRepository() -> GetMQTTObjectRepository<ObjectValueDTO, Never> {
        return GetMQTTObjectRepository<ObjectValueDTO, Never>(mqttManager: mqttManager)
    }
    
    private func makeGetMQTTObjectsStatesRepository() -> GetMQTTObjectRepository<ObjectStateDTO, Never> {
        return GetMQTTObjectRepository<ObjectStateDTO, Never>(mqttManager: mqttManager)
    }
    
    //MARK: - some Views
    func makeAnalyzerView() -> some View {
        AnalyzerView(viewModel: self.makeAnalyzerViewModel())
    }
    
    private func makeAnalyzerViewModel() -> AnalyzerViewModel {
        AnalyzerViewModel(getMQTTObjectsRepository: makeGetMQTTObjectsValuesRepository(),
                          getMQTTStateObjectsRepository: makeGetMQTTObjectsStatesRepository())
    }
}

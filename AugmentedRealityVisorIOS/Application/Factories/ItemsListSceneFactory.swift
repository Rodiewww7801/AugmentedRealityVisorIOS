//
//  ARItemsSceneFactory.swift
//  AugmentedRealityVisorIOS
//
//  Created by Rodion Hladchenko on 03.05.2022.
//

import Foundation
import SwiftUI

final class ItemsListSceneFactory {
    private let mqttManager = MQTTManager.shared()
    
    //MARK: - Repositories
    private func makeGetMQTTObjectsValuesRepository() -> GetMQTTObjectRepository<ObjectValueDTO, Never> {
        return GetMQTTObjectRepository<ObjectValueDTO, Never>(mqttManager: mqttManager)
    }
    
    private func makeGetMQTTObjectsStatesRepository() -> GetMQTTObjectRepository<ObjectStateDTO, Never> {
        return GetMQTTObjectRepository<ObjectStateDTO, Never>(mqttManager: mqttManager)
    }
    
    //MARK: - some Views
    func makeItemsListView(isMenuOpen: Binding<Bool>, arSceneViewModel: ARSceneViewModel) -> some View {
        ItemsListView(arItemsListViewModel: makeItemvsListViewModel(), arSceneViewModel: arSceneViewModel, isMenuOpen: isMenuOpen)
    }
    
    private func makeItemvsListViewModel() -> ItemsListViewModel {
        ItemsListViewModel(getMQTTObjectsRepository: makeGetMQTTObjectsValuesRepository(),
                          getMQTTStateObjectsRepository: makeGetMQTTObjectsStatesRepository())
    }
}

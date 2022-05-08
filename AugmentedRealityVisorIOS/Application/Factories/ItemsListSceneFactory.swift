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
    
    init() {
        mqttManager.subscribe(topic: "rodie/Outvalue")
        mqttManager.subscribe(topic: "rodie/AUTO")
        mqttManager.subscribe(topic: "rodie/Kp")
        mqttManager.subscribe(topic: "rodie/Ti")
        mqttManager.subscribe(topic: "rodie/Td")
        mqttManager.subscribe(topic: "rodie/Setpoint")
        mqttManager.subscribe(topic: "rodie/notification", qos: .qos2)
    }
    
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

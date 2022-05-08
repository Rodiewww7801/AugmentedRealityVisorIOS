//
//  LibrarySceneFactory.swift
//  AugmentedRealityVisorIOS
//
//  Created by Rodion Hladchenko on 26.03.2022.
//

import Foundation
import SwiftUI

final class LibrarySceneFactory {
    private let mqttManager = MQTTManager.shared()
    private let topic: String = "rodie/objectsTest1"
    
    //MARK: - Repositories
    private func makeGetMQTTObjectRepository() -> GetMQTTObjectRepository<ObjectDTO, Never> {
        GetMQTTObjectRepository<ObjectDTO, Never>(mqttManager: mqttManager)
    }
    
    //MARK: - some Views
    func makeLibraryScene() -> some View {
        LibraryView(viewModel: makeLibraryViewModel())
    }
    
    private func makeLibraryViewModel() -> LibraryViewModel {
        LibraryViewModel(getMQTTObjectRepository: makeGetMQTTObjectRepository())
    }
}

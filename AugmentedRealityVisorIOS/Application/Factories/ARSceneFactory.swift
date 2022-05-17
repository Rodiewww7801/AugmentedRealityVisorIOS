//
//  ARSceneFactory.swift
//  AugmentedRealityVisorIOS
//
//  Created by Rodion Hladchenko on 08.05.2022.
//

import Foundation
import SwiftUI

final class ARSceneFactory {
    //MARK: - View
    func makeARSceneView(arSceneViewModel: ARSceneViewModel, documentationListViewModel: DocumentationListViewModel) -> ARSceneRepresentable {
        return ARSceneRepresentable(arSceneViewModel: arSceneViewModel, documentationListViewModel: documentationListViewModel)
    }
    //MARK: - ViewModel
    func makeARSceneViewModel() -> ARSceneViewModel {
        return ARSceneViewModel()
    }
}

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
    func makeARSceneView(viewModel: ARSceneViewModel) -> ARSceneRepresentable {
        return ARSceneRepresentable(arSceneViewModel: viewModel)
    }
    //MARK: - ViewModel
    func makeARSceneViewModel() -> ARSceneViewModel {
        return ARSceneViewModel()
    }
}

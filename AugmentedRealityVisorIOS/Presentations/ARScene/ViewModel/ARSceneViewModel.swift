//
//  ARSceneViewModel.swift
//  AugmentedRealityVisorIOS
//
//  Created by Rodion Hladchenko on 04.05.2022.
//

import Foundation
import ARKit

class ARSceneViewModel: ObservableObject {
    @Published var isQRProcess: Bool = false
    @Published var qrCodeAnchor: ARAnchor?
    @Published var arItems: [ARItemViewModel] = []
}

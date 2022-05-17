//
//  QRCodeModel.swift
//  AugmentedRealityVisorIOS
//
//  Created by Rodion Hladchenko on 14.05.2022.
//

import Foundation
import ARKit

struct QRCodeModel: Identifiable {
    let id: String
    //var worldPosition: simd_float4x4?
    var postion: SCNVector3?
    var documents: [DocumentationModel] = []
}

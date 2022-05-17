//
//  ARItemModel.swift
//  AugmentedRealityVisorIOS
//
//  Created by Rodion Hladchenko on 14.05.2022.
//

import Foundation
import ARKit

struct ARItemModel: Identifiable, Codable {
    var id: String
    var locationX: Float
    var locationY: Float
    var locationZ: Float
    let topic: String
}

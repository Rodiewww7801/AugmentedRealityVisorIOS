//
//  Object.swift
//  AugmentedRealityVisorIOS
//
//  Created by Rodion Hladchenko on 05.03.2022.
//

import Foundation

struct Object: Identifiable {
    let id = UUID()
    var objectName: String
    var objectValues: [ObjectValue]
}

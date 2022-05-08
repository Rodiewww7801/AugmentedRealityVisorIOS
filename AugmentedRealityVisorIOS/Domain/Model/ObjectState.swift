//
//  ObjectState.swift
//  AugmentedRealityVisorIOS
//
//  Created by Rodion Hladchenko on 24.04.2022.
//

import Foundation

struct ObjectState: Identifiable, Comparable {
    let id = UUID()
    var name: String
    var state: Bool
    var secureLevel: Int
    var isChange: Bool
    var time: Date
    var alarm: Bool?
    var description: String?
    var drawChart: Bool
    var hexColor: String?
    
    static func < (lhs: Self, rhs: Self) -> Bool {
        return lhs.name < rhs.name
    }
}

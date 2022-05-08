//
//  ObjectValue.swift
//  AugmentedRealityVisorIOS
//
//  Created by Rodion Hladchenko on 03.03.2022.
//

import Foundation

struct ObjectValue: Identifiable, Comparable {
    let id = UUID()
    var name: String
    var value: Double
    var secureLevel: Int
    var isChange: Bool
    var time: Date
    var alarmhihi: Double?
    var alarmlolo: Double?
    var description: String?
    var drawChart: Bool
    var hexColor: String?
    
    static func < (lhs: Self, rhs: Self) -> Bool {
        return lhs.value < rhs.value
    }
}

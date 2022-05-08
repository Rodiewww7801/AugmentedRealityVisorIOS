//
//  ObjectStateDTO.swift
//  AugmentedRealityVisorIOS
//
//  Created by Rodion Hladchenko on 24.04.2022.
//

import Foundation

struct ObjectStateDTO: Codable {
    var name: String
    var state: Bool
    var secureLevel: Int?
    var isChange: Bool?
    var alarm: Bool?
    var description: String?
    var drawChart: Bool?
    var hexColor: String?
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case state = "state"
        case secureLevel = "secureLevel"
        case isChange = "isChange"
        case alarm = "alarm"
        case description = "description"
        case drawChart = "drawChart"
        case hexColor = "hexColor"
    }
}

extension ObjectStateDTO: ConvertModelProtocol {
    func toModel() -> ObjectState {
        .init(name: name,
              state: state,
              secureLevel: secureLevel ?? 0,
              isChange: isChange ?? false,
              time: Date(),
              alarm: alarm,
              description: description,
              drawChart: drawChart ?? false,
              hexColor: hexColor)
    }
}

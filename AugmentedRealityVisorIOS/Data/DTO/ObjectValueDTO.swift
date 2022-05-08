//
//  ObjectValueDTO.swift
//  AugmentedRealityVisorIOS
//
//  Created by Rodion Hladchenko on 25.03.2022.
//

import Foundation

struct ObjectValueDTO: Codable {
    var name: String
    var value: Double
    var secureLevel: Int?
    var isChange: Bool?
    var alarmhihi: Double?
    var alarmlolo: Double?
    var description: String?
    var drawChart: Bool?
    var hexColor: String?
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case value = "value"
        case secureLevel = "secureLevel"
        case isChange = "isChange"
        case alarmhihi = "alarmhihi"
        case alarmlolo = "alarmlolo"
        case description = "description"
        case drawChart = "drawChart"
        case hexColor = "hexColor"
    }
}

extension ObjectValueDTO: ConvertModelProtocol {
    func toModel() -> ObjectValue {
        .init(name: name,
              value: value,
              secureLevel: secureLevel ?? 0,
              isChange: isChange ?? false,
              time: Date(),
              alarmhihi: alarmhihi,
              alarmlolo: alarmlolo,
              description: description,
              drawChart: drawChart ?? false,
              hexColor: hexColor)
    }
}

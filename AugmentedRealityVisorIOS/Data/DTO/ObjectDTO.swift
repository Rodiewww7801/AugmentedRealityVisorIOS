//
//  ObjectDTO.swift
//  AugmentedRealityVisorIOS
//
//  Created by Rodion Hladchenko on 25.03.2022.
//

import Foundation

struct ObjectDTO: Codable {
    var objectName: String
    var objectValues: [ObjectValueDTO]
    
    enum CodingKeys: String, CodingKey {
        case objectName = "objectName"
        case objectValues = "objectValues"
    }
}

extension ObjectDTO: ConvertModelProtocol {
    func toModel() -> Object {
        .init(objectName: objectName,
              objectValues: objectValues.map { $0.toModel() })
    }
}

//extension Array where Element == ObjectDTO {
//    func toModel() -> [Object] {
//        return self.map { $0.toModel() }
//    }
//}

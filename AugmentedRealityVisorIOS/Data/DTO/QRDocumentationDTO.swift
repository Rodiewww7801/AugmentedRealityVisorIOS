//
//  QRDocumentationDTO.swift
//  AugmentedRealityVisorIOS
//
//  Created by Rodion Hladchenko on 09.05.2022.
//

import Foundation

struct QRDocumentationDTO: Decodable {
    let name: String
    let link: String
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case link = "link"
    }
}

extension QRDocumentationDTO: ConvertModelProtocol {
    func toModel() -> DocumentationModel {
        .init(name: name, link: link)
    }
}

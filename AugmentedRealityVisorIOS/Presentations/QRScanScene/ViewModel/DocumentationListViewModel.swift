//
//  DocumentationListViewModel.swift
//  AugmentedRealityVisorIOS
//
//  Created by Rodion Hladchenko on 09.05.2022.
//

import Foundation

class DocumentationListViewModel: ObservableObject {
    @Published var documentationList: [DocumentationModel] = []
    
    func parseJSON(stringJSON: String) {
        if let data = stringJSON.data(using: .utf8),
           let dto = try?  JSONDecoder().decode([QRDocumentationDTO].self, from: data) {
            let models = dto.map { $0.toModel() }
            documentationList = models
        }
    }
}

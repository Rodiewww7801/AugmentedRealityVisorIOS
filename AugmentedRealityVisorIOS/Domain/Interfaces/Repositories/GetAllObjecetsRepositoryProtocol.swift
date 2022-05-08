//
//  GetAllObjecetsRepositoryProtocol.swift
//  AugmentedRealityVisorIOS
//
//  Created by Rodion Hladchenko on 07.03.2022.
//

import Foundation
import Combine

protocol GetMQTTObjectRepositoryProtocol {
    associatedtype Success: Decodable, ConvertModelProtocol
    associatedtype Failure: Error
    
    func subscribeTopic(selectedTopics: [String], completion: @escaping ((Result<(String, Success.Model), Failure>) -> Void))
}

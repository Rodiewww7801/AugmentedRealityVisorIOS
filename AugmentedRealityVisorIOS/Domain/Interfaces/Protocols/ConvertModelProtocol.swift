//
//  ConvertModelProtocol.swift
//  AugmentedRealityVisorIOS
//
//  Created by Rodion Hladchenko on 26.03.2022.
//

import Foundation

protocol ConvertModelProtocol {
    associatedtype Model
    
    func toModel() -> Model
}

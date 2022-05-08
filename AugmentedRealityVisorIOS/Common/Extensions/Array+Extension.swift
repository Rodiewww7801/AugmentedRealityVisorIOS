//
//  Array+Extension.swift
//  AugmentedRealityVisorIOS
//
//  Created by Rodion Hladchenko on 15.04.2022.
//

import Foundation
import UIKit

extension Array: ConvertModelProtocol where Element: ConvertModelProtocol {
    func toModel() -> [Element.Model] {
        return self.map { $0.toModel() }
    }
}

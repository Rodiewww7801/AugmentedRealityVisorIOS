//
//  View+Extensions.swift
//  AugmentedRealityVisorIOS
//
//  Created by Rodion Hladchenko on 23.02.2022.
//

import Foundation
import SwiftUI

extension View {
    //MARK: - Erase to any View
    func eraseToAnyView() -> AnyView {
        AnyView(self)
    }
}

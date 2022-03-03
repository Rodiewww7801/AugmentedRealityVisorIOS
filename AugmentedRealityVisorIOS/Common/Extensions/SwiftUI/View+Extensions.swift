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
    
    //MARK: - Hide keyboard
#if canImport(UIKit)
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
#endif
}


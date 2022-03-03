//
//  Router.swift
//  AugmentedRealityVisorIOS
//
//  Created by Rodion Hladchenko on 23.02.2022.
//

import Foundation
import SwiftUI

enum enumRouters {
    case loginView
    case main
}

final class Router: ObservableObject {
    @Published var currentView: enumRouters
    @Published var views: [enumRouters: AnyView] = [:]
    let animation: Animation = .spring()
    
    init() {
        currentView = .main
        views[.main] = MainView().eraseToAnyView()
    }
}

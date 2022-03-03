//
//  ContentView.swift
//  VirtualSupervisorIOS
//
//  Created by Rodion Hladchenko on 09.02.2022.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var router: Router
    
    var body: some View {
        ZStack {
            if let view = router.views[router.currentView] {
                view
                    .transition(.opacity)
            }
        }
    }
}

extension ContentView {
}

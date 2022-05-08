//
//  VirtualSupervisorIOSApp.swift
//  VirtualSupervisorIOS
//
//  Created by Rodion Hladchenko on 09.02.2022.
//

import SwiftUI

@main
struct VirtualSupervisorIOSApp: App {
    var router = Router()
    //var mqttManager
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(router)
        }
    }
}

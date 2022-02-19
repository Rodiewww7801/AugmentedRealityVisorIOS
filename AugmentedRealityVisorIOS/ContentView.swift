//
//  ContentView.swift
//  VirtualSupervisorIOS
//
//  Created by Rodion Hladchenko on 09.02.2022.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        weatherView()
    }
}

extension ContentView {
    func weatherView() -> some View {
        let weatherViewFactory = WeatherViewFactory()
        let weatherView = weatherViewFactory.makeWeatherView()
        return weatherView
    }
}

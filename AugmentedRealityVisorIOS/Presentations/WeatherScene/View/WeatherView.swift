//
//  WeatherView.swift
//  VirtualSupervisorIOS
//
//  Created by Rodion Hladchenko on 19.02.2022.
//

import SwiftUI

struct WeatherView: View {
    @ObservedObject var wheatherViewModel: WeatherViewModel
    @State var isSearchShow: Bool = false
    
    var body: some View {
        VStack {
            if isSearchShow {
                SearchBar(cityName: $wheatherViewModel.city)
                    .transition(.move(edge: .leading))
                    .padding()
            }
            
            Spacer()
            
            if let wetherModel = wheatherViewModel.weatherStructure {
                Text("\(wetherModel.city): \(wetherModel.weatherMain.temp), \(wetherModel.weather?.main ?? "")")
            }
            
            Button(action: {
                withAnimation {
                    isSearchShow.toggle()
                }
            }, label: {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 16))
            })
        }
    }
}


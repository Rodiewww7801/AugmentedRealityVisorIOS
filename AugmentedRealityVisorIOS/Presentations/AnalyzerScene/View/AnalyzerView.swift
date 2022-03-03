//
//  AnalyzerView.swift
//  AugmentedRealityVisorIOS
//
//  Created by Rodion Hladchenko on 03.03.2022.
//

import SwiftUI

struct AnalyzerView: View {
    @State var searchItem: String = ""
    
    var body: some View {
        ZStack {
            Color.white
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                SearchBar(cityName: $searchItem)
                    .padding()
                
                Spacer()
            }
        }
    }
}

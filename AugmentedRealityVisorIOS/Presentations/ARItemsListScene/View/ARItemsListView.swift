//
//  ARItemsListView.swift
//  AugmentedRealityVisorIOS
//
//  Created by Rodion Hladchenko on 02.03.2022.
//

import SwiftUI

struct ARItemsListView: View {
    @State var searchItem = ""
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            Color.white.opacity(0.5)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                
                
                SearchBar(cityName: $searchItem)
                    .padding()
            }.padding(.leading, 25)
        }.padding(.leading, 100)
    }
}

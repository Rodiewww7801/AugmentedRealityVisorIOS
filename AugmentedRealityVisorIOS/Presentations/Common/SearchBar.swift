//
//  SearchBar.swift
//  VirtualSupervisorIOS
//
//  Created by Rodion Hladchenko on 09.02.2022.
//

import SwiftUI

struct SearchBar: View {
   // @FocusState var focusToggle: Bool
    @Binding var searchItem: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 16))
            
            TextField("Search", text: $searchItem)
        }
        .padding(5)
        .background(RoundedRectangle(cornerRadius: 25).foregroundColor(.gray.opacity(0.2)))
    }
}


//
//  LibraryView.swift
//  AugmentedRealityVisorIOS
//
//  Created by Rodion Hladchenko on 03.03.2022.
//

import SwiftUI

struct LibraryView: View {
    @ObservedObject var viewModel: LibraryViewModel
    
    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea(edges: .all)
            
            Image("arvlogo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: UIScreen.main.bounds.width, height: 100)
                .opacity(0.05)
            
            VStack {
                if let objectName = viewModel.object?.objectName,
                   let objectValues = viewModel.object?.objectValues {
                    Text("ObjectName: \(objectName)")
                    ForEach(objectValues) { value in
                        Text("\(value.name): \(value.value)")
                    }
                }
            }
        }
    }
}

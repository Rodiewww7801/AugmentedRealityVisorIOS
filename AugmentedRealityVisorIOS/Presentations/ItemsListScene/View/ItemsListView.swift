//
//  ItemsListView.swift
//  AugmentedRealityVisorIOS
//
//  Created by Rodion Hladchenko on 02.03.2022.
//

import SwiftUI

struct ItemsListView: View {
    @ObservedObject var arItemsListViewModel: ItemsListViewModel
    @ObservedObject var arSceneViewModel: ARSceneViewModel
    @State var searchItem = ""
    @Binding var isMenuOpen: Bool
    
    var body: some View {
        VStack {
            SearchBar(searchItem: $searchItem)
                .padding(.vertical)
            
            ScrollView(.vertical, showsIndicators: true) {
                ForEach(arItemsListViewModel.objectValues.sorted(by: >), id: \.key) { topic, object in
                    if searchItem.isEmpty || object.name.lowercased().contains(searchItem.lowercased()) {
                        ItemValueCell(topic: topic, objectValue: object, isShown: $isMenuOpen, arSceneViewModel: arSceneViewModel)
                        Divider()
                    }
                }
                
                ForEach(arItemsListViewModel.stateValues.sorted(by: >), id: \.key) { topic, object in
                    if searchItem.isEmpty || object.name.lowercased().contains(searchItem.lowercased()) {
                        ItemStateCell(topic: topic, objectState: object, isShown: $isMenuOpen, arSceneViewModel: arSceneViewModel)
                        Divider()
                    }
                    
                }
            }
        }.padding([.horizontal, .top])
    }
    
   
}

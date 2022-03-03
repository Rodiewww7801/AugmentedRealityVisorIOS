//
//  TabController.swift
//  AugmentedRealityVisorIOS
//
//  Created by Rodion Hladchenko on 02.03.2022.
//

import Foundation

final class TabController: ObservableObject {
    @Published private(set) var onTopTab = OnTopTab.none
    @Published var tabBarOption = TabBarOptions.qrScan
    var previouslySelectedTab: Tab = TabBarOptions.qrScan
    
    func open(_ tab: Tab) {
        
    }
    
    func close(_ tab: Tab) {
        
    }
    
    func clearPresentedViews(for tab: Tab) {
        
    }
}

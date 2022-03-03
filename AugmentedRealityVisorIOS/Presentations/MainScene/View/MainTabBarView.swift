//
//  MainNavigationBar.swift
//  AugmentedRealityVisorIOS
//
//  Created by Rodion Hladchenko on 02.03.2022.
//

import Foundation
import SwiftUI

struct MainTabBarView: View {
    @Binding var selectedTab: TabBarOptions
    private var onTabSelection: ((Tab) -> Void)
    
    private let iconHeight: CGFloat = 20
    
    init(selectedTab: Binding<TabBarOptions>, onTabSelection: @escaping ((Tab) -> Void)) {
        self._selectedTab = selectedTab
        self.onTabSelection = onTabSelection
    }
    
    var body: some View {
        HStack {
            ForEach(TabBarOptions.allCases) { tab in
                Spacer()
                
                VStack {
                    Image(systemName: tab.imageName)
                        .renderingMode(.template) //todo try change
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: iconHeight / tab.scale, height: iconHeight)
                    
                    Text("\(tab.name)")
                        .font(.system(size: 10))
                }
                .foregroundColor(selectedTab == tab ? .black : .gray)
                .padding(.vertical, 5)
                .onTapGesture {
                        selectedTab = tab
                        onTabSelection(tab)
                }
                
                Spacer()
            }
        }
    }
}

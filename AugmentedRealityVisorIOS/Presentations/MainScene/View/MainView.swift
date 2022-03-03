//
//  MainView.swift
//  AugmentedRealityVisorIOS
//
//  Created by Rodion Hladchenko on 23.02.2022.
//

import SwiftUI

struct MainView: View {
    @StateObject var tabController = TabController()
    
    var body: some View {
        ZStack {
            Color.white
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {
                Spacer()
                
                tab
                
                Divider()
                    .background(Color.black.opacity(0.25))
                
                MainTabBarView(
                    selectedTab: $tabController.tabBarOption,
                    onTabSelection: { tab in
                        configureTab(tab)
                    })
                    .padding(.top, 5)
            }
        }
    }
    
    private var tab: some View {
        ZStack {
            AnalyzerView()
                .offset(x: tabController.tabBarOption == .analyzer ? 0 : 500, y: 0)
                .opacity(tabController.tabBarOption == .analyzer ? 1 : 0)
                .disabled(tabController.tabBarOption != .analyzer)
            
            QRScanMainView()
                .offset(x: tabController.tabBarOption == .qrScan ? 0 : 500, y: 0)
                //.opacity(tabController.tabBarOption == .qrScan ? 1 : 0)
                .disabled(tabController.tabBarOption != .qrScan)
            
            ProfileView()
                .offset(x: tabController.tabBarOption == .profile ? 0 : 500, y: 0)
                .opacity(tabController.tabBarOption == .profile ? 1 : 0)
                .disabled(tabController.tabBarOption != .profile)
        }
    }
    
    private func configureTab(_ tab: Tab, with animation: Animation = .default) {
        withAnimation {
            tabController.open(tab)
        }
    }
}

// MARK: - Factory Views
extension MainView {
    
}

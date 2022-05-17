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
                .edgesIgnoringSafeArea(.bottom)
            
            VStack(spacing: 0) {
                Spacer()
                
                tab
                
                VStack {
                    Divider()
                        .background(Color.black.opacity(0.25))
                    
                    MainTabBarView(
                        selectedTab: $tabController.tabBarOption,
                        onTabSelection: { tab in
                            configureTab(tab)
                        })
                        .padding(.vertical, 5)
                        .background(Color.white)
                }
                .background(Color.white)
                .frame(alignment: .bottom)
            }
        }
    }
    
    private var tab: some View {
        ZStack {
            if tabController.tabBarOption == .analyzer {
                analyzerScene()
                    .offset(x: tabController.tabBarOption == .analyzer ? 0 : 500, y: 0)
                    .opacity(tabController.tabBarOption == .analyzer ? 1 : 0)
                    .disabled(tabController.tabBarOption != .analyzer)
            }
            
            
            qrScene()
                .offset(x: tabController.tabBarOption == .qrScan ? 0 : 500, y: 0)
                .opacity(tabController.tabBarOption == .qrScan ? 1 : 0)
                .disabled(tabController.tabBarOption != .qrScan)
            
            //            libraryScene()
            //                .offset(x: tabController.tabBarOption == .library ? 0 : 500, y: 0)
            //                .opacity(tabController.tabBarOption == .library ? 1 : 0)
            //                .disabled(tabController.tabBarOption != .library)
            //                .environmentObject(mqttManager)
            
            ProfileView()
                .offset(x: tabController.tabBarOption == .profile ? 0 : 500, y: 0)
                .opacity(tabController.tabBarOption == .profile ? 1 : 0)
                .disabled(tabController.tabBarOption != .profile)
        }
    }
    
    private func configureTab(_ tab: Tab, with animation: Animation = .default) {
        withAnimation {
            tabController.open(tab)
            hideKeyboard()
        }
    }
}

// MARK: - Factory Views
extension MainView {
    func analyzerScene() -> some View {
        let analyzerScenefactory = AnalyzerSceneFactory()
        let analyzerScene = analyzerScenefactory.makeAnalyzerView()
        return analyzerScene
    }
    
    func qrScene() -> some View {
        let arSceneFactory = ARSceneFactory()
        let viewModel = arSceneFactory.makeARSceneViewModel()
        return QRScanMainView(arSceneViewModel: viewModel, documentationViewModel: DocumentationListViewModel())
    }
    
    func libraryScene() -> some View {
        let libraryScenefactory = LibrarySceneFactory()
        let libraryScene = libraryScenefactory.makeLibraryScene()
        return libraryScene
    }
}


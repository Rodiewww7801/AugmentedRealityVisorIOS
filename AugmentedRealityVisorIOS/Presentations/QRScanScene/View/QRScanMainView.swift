//
//  QRScanMainView.swift
//  AugmentedRealityVisorIOS
//
//  Created by Rodion Hladchenko on 02.03.2022.
//

import SwiftUI
import CodeScanner
import ARKit

struct QRScanMainView: View {
    private let documentationButtonSize: CGFloat = 40
    private let chevronButtonSize: CGFloat = 35
    @State private var isMenuOpen: Bool = false
    @StateObject var arSceneViewModel: ARSceneViewModel
    
    @State var pressed: Bool = false
    @State var node = SCNNode()
    
    var body: some View {
        ZStack(alignment: .trailing) {
            arScene()
                
            Button(action: {
                withAnimation {
                    isMenuOpen.toggle()
                }
            }, label: {
                ZStack {
                    Circle()
                        .foregroundColor(Color.white)
                    
                    Image(systemName: "plus")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: chevronButtonSize * 0.35, height: chevronButtonSize * 0.35)
                        .padding(.trailing, 2)
                }.frame(width: documentationButtonSize, height: documentationButtonSize)
            })
            .buttonStyle(.plain)
            .padding()
            .frame(maxHeight: .infinity, alignment: .top)
            
            VStack {
                Button(action: {
                    
                }, label: {
                    ZStack {
                        Circle()
                            .foregroundColor(Color.white)
                        
                        Image(systemName: "qrcode.viewfinder")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: documentationButtonSize * 0.5, height: documentationButtonSize * 0.5)
                    }.frame(width: documentationButtonSize, height: documentationButtonSize)
                }).buttonStyle(.plain)
                
                Button(action: {
                    
                }, label: {
                    ZStack {
                        Circle()
                            .foregroundColor(Color.white)
                        
                        Image(systemName: "doc.text")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: documentationButtonSize * 0.5, height: documentationButtonSize * 0.5)
                    }.frame(width: documentationButtonSize, height: documentationButtonSize)
                }).buttonStyle(.plain)
            }.frame(maxHeight: .infinity, alignment: .bottom)
                .padding()
            
        }.sheet(isPresented: $isMenuOpen) {
            itemsListView()
        }
    }
}

extension QRScanMainView {
    func arScene() -> ARSceneRepresentable {
        let arSceneFactory = ARSceneFactory()
        let arSceneView = arSceneFactory.makeARSceneView(viewModel: arSceneViewModel)
        return arSceneView
    }
    
    func itemsListView() -> some View {
        let ARItemsListFactory = ItemsListSceneFactory()
        let ARItemsListView = ARItemsListFactory.makeItemsListView(isMenuOpen: $isMenuOpen, arSceneViewModel: arSceneViewModel)
        return ARItemsListView
    }
}

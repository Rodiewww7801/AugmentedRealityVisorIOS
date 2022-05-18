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
    @State private var documentationViewIsOpen: Bool = false
    @State private var dismissBottomSheetView: Bool = false
    @StateObject var arSceneViewModel: ARSceneViewModel
    @StateObject var documentationViewModel: DocumentationListViewModel
    
    var body: some View {
        ZStack(alignment: .trailing) {
            arScene()
            
            if arSceneViewModel.startQRScan {
                Image(systemName: "qrcode.viewfinder")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .font(Font.title.weight(.ultraLight))
                    .frame(width: UIScreen.main.bounds.width, height:  UIScreen.main.bounds.width * 0.6, alignment: .center)
                    .foregroundColor(.white.opacity(0.6))
            }
                
            Button(action: {
                withAnimation {
                    isMenuOpen.toggle()
                    self.arSceneViewModel.startQRScan = false
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
                    withAnimation {
                        arSceneViewModel.startQRScan.toggle()
                    }
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
                    self.documentationViewIsOpen.toggle()
                    self.arSceneViewModel.startQRScan = false
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
            
            if arSceneViewModel.showEditObjectValueView,
               let topic = arSceneViewModel.selectedTopic,
               let selectedObject = arSceneViewModel.selectedObjectValue {
                BottomSheetView(showBottomSheetView: $arSceneViewModel.showEditObjectValueView, dismissBottomSheetView: $dismissBottomSheetView) {
                    EditARItemObjectValueView(selectedValueObject: selectedObject, selectedTopic: topic, viewIsShown: $arSceneViewModel.showEditObjectValueView, onDeleteAction: arSceneViewModel.onDeleteAction)
                }
            }
            
            if arSceneViewModel.showEditObjectStateView,
               let topic = arSceneViewModel.selectedTopic,
               let selectedObject = arSceneViewModel.selectedObjectState {
                BottomSheetView(showBottomSheetView: $arSceneViewModel.showEditObjectStateView, dismissBottomSheetView: $dismissBottomSheetView) {
                    EditARItemObjectStateView(selectedValueObject: selectedObject, selectedTopic: topic, viewIsShown: $arSceneViewModel.showEditObjectStateView, onDeleteAction: arSceneViewModel.onDeleteAction)
                }
            }
        }.sheet(isPresented: $isMenuOpen) {
            itemsListView()
        }.sheet(isPresented: $documentationViewIsOpen, content: {
            DocumentationListView(documentations: arSceneViewModel.documentations)
        })
    }
}

extension QRScanMainView {
    func arScene() -> ARSceneRepresentable {
        let arSceneFactory = ARSceneFactory()
        let arSceneView = arSceneFactory.makeARSceneView(arSceneViewModel: arSceneViewModel, documentationListViewModel: documentationViewModel)
        return arSceneView
    }
    
    func itemsListView() -> some View {
        let ARItemsListFactory = ItemsListSceneFactory()
        let ARItemsListView = ARItemsListFactory.makeItemsListView(isMenuOpen: $isMenuOpen, arSceneViewModel: arSceneViewModel)
        return ARItemsListView
    }
}

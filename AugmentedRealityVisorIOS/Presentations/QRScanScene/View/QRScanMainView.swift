//
//  QRScanMainView.swift
//  AugmentedRealityVisorIOS
//
//  Created by Rodion Hladchenko on 02.03.2022.
//

import SwiftUI

struct QRScanMainView: View {
    private let documentationButtonSize: CGFloat = 40
    private let chevronButtonSize: CGFloat = 35
    @State private var isMenuOpen: Bool = false
    
    var body: some View {
        ZStack(alignment: .trailing) {
            Color.mint
                .edgesIgnoringSafeArea(.all)
            
                Button(action: {
                    withAnimation {
                        isMenuOpen.toggle()
                    }
                }, label: {
                    ZStack {
                       if !isMenuOpen {
                            Circle()
                                .foregroundColor(Color.white)
                                .transition(.scale)
                        }
                        
                        Image(systemName: "chevron.right")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: chevronButtonSize * 0.35, height: chevronButtonSize * 0.35)
                            .rotationEffect(.degrees(isMenuOpen ? 0 : -180))
                            .padding(.trailing, 2)
                    } .frame(width: chevronButtonSize, height: chevronButtonSize)
                })
                    .buttonStyle(.plain)
                    .padding()
                    .padding(.trailing, isMenuOpen ? 260 : 0)
                    .frame(maxHeight: .infinity, alignment: .top)
                    .zIndex(1)
            
            if !isMenuOpen {
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
            }
            
            if isMenuOpen {
                ARItemsListView()
                    .transition(.move(edge: .trailing))
                    .zIndex(0)
            }
            
        }
    }
}

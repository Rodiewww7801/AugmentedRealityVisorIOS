//
//  BottomSheetView.swift
//  AugmentedRealityVisorIOS
//
//  Created by Rodion Hladchenko on 22.04.2022.
//

import SwiftUI

struct BottomSheetView<Content: View>: View {
    @Binding var showBottomSheetView: Bool
    @Binding var dismissBottomSheetView: Bool
    let content: Content
    
    init(showBottomSheetView: Binding<Bool>,
         dismissBottomSheetView: Binding<Bool>,
         @ViewBuilder content: () -> Content ) {
        self._showBottomSheetView = showBottomSheetView
        self._dismissBottomSheetView = dismissBottomSheetView
        self.content =  content()
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
                GeometryReader { _ in
                    EmptyView()
                }.background(Color.black.opacity(0.1))
                .animation(.easeInOut)
                .onTapGesture {
                    withAnimation {
                        self.showBottomSheetView.toggle()
                    }
                }
                
                VStack {
                    Spacer()
                    
                    VStack {
                        content
                            .frame(maxWidth: .infinity)
                    }
                    .background(Color.white)
                    .cornerRadius(20, corners: [.topLeft, .topRight])

                }//.offset(y: self.showBottomSheetView ? 0 : 300)
                
                .animation(.easeInOut)
                
        }.shadow(color: .black.opacity(0.15), radius: 20)
                .edgesIgnoringSafeArea(.all)
    }
}

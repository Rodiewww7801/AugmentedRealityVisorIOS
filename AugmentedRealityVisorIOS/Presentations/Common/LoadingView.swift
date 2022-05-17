//
//  LoadingView.swift
//  AugmentedRealityVisorIOS
//
//  Created by Rodion Hladchenko on 17.05.2022.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        ZStack {
            Color(white: 0.2, opacity: 0.2)

            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                .scaleEffect(2.0)
        }
        .ignoresSafeArea()
    }
}

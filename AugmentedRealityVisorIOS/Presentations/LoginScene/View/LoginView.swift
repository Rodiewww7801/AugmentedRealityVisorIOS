//
//  LoginView.swift
//  AugmentedRealityVisorIOS
//
//  Created by Rodion Hladchenko on 03.03.2022.
//

import SwiftUI

struct LoginView: View {
    @StateObject var viewModel = LoginViewModel()
    @EnvironmentObject var router: Router
    
    var body: some View {
        VStack {
            Image("arvlogo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 250)
            
            TextField("Email", text: $viewModel.credentials.email)
                .keyboardType(.emailAddress)
            
            Divider()
            
            SecureField("Password", text: $viewModel.credentials.password)
            
            Divider()
            
            if viewModel.showProgressView {
                ProgressView()
            }
            
            if viewModel.isNotValidShown {
                Text("Incorrect email or password.\nTry again")
                    .multilineTextAlignment(.center)
                    .foregroundColor(.red)
                    .padding()
            }
            
            Button("Log in") {
                hideKeyboard()
                viewModel.login(completion: { success in
                    if success {
                        withAnimation {
                            router.currentView = .main
                        }
                    }
                })
            }.disabled(viewModel.loginDisabled)
                .padding()
        }.textFieldStyle(.plain)
            .autocapitalization(.none)
            .padding()
        .disabled(viewModel.showProgressView)
    }
}

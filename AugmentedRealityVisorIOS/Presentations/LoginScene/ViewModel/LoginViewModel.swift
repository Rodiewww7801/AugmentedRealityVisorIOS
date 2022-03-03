//
//  LoginViewModel.swift
//  AugmentedRealityVisorIOS
//
//  Created by Rodion Hladchenko on 03.03.2022.
//

import Foundation

final class LoginViewModel: ObservableObject {
    @Published var credentials: Credentials = Credentials(email: "", password: "")
    @Published var showProgressView: Bool = false
    @Published var isNotValidShown: Bool = false
    var loginDisabled: Bool {
        return credentials.email.isEmpty  || credentials.password.isEmpty
    }
    
    func login(completion: @escaping (Bool) -> Void ) {
        showProgressView = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            if self.credentials.password == "123" {
                completion(true)
                self.isNotValidShown = false
            } else {
                self.credentials = Credentials(email: "", password: "")
                completion(false)
                self.isNotValidShown = true
            }
            self.showProgressView = false
        }
    }
}

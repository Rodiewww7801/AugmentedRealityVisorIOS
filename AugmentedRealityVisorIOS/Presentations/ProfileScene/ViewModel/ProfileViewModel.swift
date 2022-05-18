//
//  ProfileViewModel.swift
//  AugmentedRealityVisorIOS
//
//  Created by Rodion Hladchenko on 03.03.2022.
//

import Foundation

final class ProfileViewModel: ObservableObject {
    @Published var userModel: User = User(id: "nil",
                                          firstName: "nil",
                                          lastName: "nil",
                                          dateOfBirth: "nil",
                                          companyName: "nil",
                                          stream: "nil",
                                          securityLevel: 0)
    
    init() {
        getUser()
    }
    
    func getUser() {
        FirebaseManager._shared.getUser { model in
            self.userModel = model
        }
    }
}

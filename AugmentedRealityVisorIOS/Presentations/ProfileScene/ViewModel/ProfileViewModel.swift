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
        fetchUser()
    }
    
    func fetchUser() {
        FirebaseManager._shared.firestore.collection("usersInfo").addSnapshotListener { query, error in
            guard let documents = query?.documents else {
                print("[Firebase error]: storage has no document usersInfo")
                return
            }
            
            if let data = documents.first(where: { documentSnapshot in
                documentSnapshot.data()["userUID"] as? String == FirebaseManager._shared.auth.currentUser?.uid
            }) {
                let model = User(id: data["userUID"] as? String ?? "nil",
                                     firstName: data["firstName"] as? String ?? "nil",
                                     lastName: data["lastName"] as? String ?? "nil",
                                     dateOfBirth: data["dateOfBirth"] as? String ?? "nil",
                                     stream: data["stream"] as? String,
                                     securityLevel: data["securityLevel"] as? Int)
                self.userModel = model
            }
        }
    }
}

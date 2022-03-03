//
//  ProfileViewModel.swift
//  AugmentedRealityVisorIOS
//
//  Created by Rodion Hladchenko on 03.03.2022.
//

import Foundation

final class ProfileViewModel: ObservableObject {
    @Published var userModel: User = User(firstName: "Timur",
                                          lastName: "Mutsuraev",
                                          dateOfBirth: Date(),
                                          companyName: "Chechenskay Respublika",
                                          stream: "Chechen",
                                          sequreLvl: 15)
}

struct User {
    var firstName: String
    var lastName: String
    var dateOfBirth: Date
    var companyName: String?
    var stream: String?
    var sequreLvl: Int?
}

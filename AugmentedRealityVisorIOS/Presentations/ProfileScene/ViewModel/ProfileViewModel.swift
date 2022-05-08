//
//  ProfileViewModel.swift
//  AugmentedRealityVisorIOS
//
//  Created by Rodion Hladchenko on 03.03.2022.
//

import Foundation

final class ProfileViewModel: ObservableObject {
    @Published var userModel: User = User(firstName: "Volodymyr",
                                          lastName: "Panasuk",
                                          dateOfBirth: Date(),
                                          companyName: "Nitishin Evil Corp",
                                          stream: "-_-",
                                          sequreLvl: 666)
}

struct User {
    var firstName: String
    var lastName: String
    var dateOfBirth: Date
    var companyName: String?
    var stream: String?
    var sequreLvl: Int?
}

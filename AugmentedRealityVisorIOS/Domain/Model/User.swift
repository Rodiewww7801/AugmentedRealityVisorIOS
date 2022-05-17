//
//  User.swift
//  AugmentedRealityVisorIOS
//
//  Created by Rodion Hladchenko on 12.05.2022.
//

import Foundation

struct User: Identifiable {
    let id: String
    var firstName: String
    var lastName: String
    var dateOfBirth: String
    var companyName: String?
    var stream: String?
    var securityLevel: Int?
}

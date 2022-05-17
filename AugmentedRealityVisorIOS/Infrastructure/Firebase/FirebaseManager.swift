//
//  FirebaseManager.swift
//  AugmentedRealityVisorIOS
//
//  Created by Rodion Hladchenko on 12.05.2022.
//

import Foundation
import Firebase
import FirebaseFirestore
import Combine
import SwiftUI

class FirebaseManager: NSObject {
    let auth: Auth
    let firestore: Firestore
    static let _shared =  FirebaseManager()
    private var subscriptions = Set<AnyCancellable>()
    
    override init() {
        FirebaseApp.configure()
        self.auth = Auth.auth()
        self.firestore = Firestore.firestore()
        super.init()
    }
    
    
}

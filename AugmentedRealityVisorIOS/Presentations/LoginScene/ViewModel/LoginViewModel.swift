//
//  LoginViewModel.swift
//  AugmentedRealityVisorIOS
//
//  Created by Rodion Hladchenko on 03.03.2022.
//

import Foundation
import Combine
import UserNotifications


final class LoginViewModel: ObservableObject {
    @Published var topics: [String] = []
    @Published var credentials: Credentials = Credentials(email: "", password: "")
    @Published var showProgressView: Bool = false
    @Published var isNotValidShown: Bool = false
    private var mqttManager = MQTTManager.shared()
    private var subscriptions = Set<AnyCancellable>()
    private let firebaseManager: FirebaseManager = FirebaseManager._shared 
    
    var loginDisabled: Bool {
        return credentials.email.isEmpty  || credentials.password.isEmpty
    }
    
    func login(completion: @escaping (Bool) -> Void ) {
        firebaseManager.auth.signIn(withEmail: credentials.email, password: credentials.password) { result, error in
            if let error = error {
                self.credentials = Credentials(email: "", password: "")
                completion(false)
                print("Error not valid login and/or password:\n\(error.localizedDescription)")
                self.isNotValidShown = true
            } else if result != nil {
                self.mqttManager.initializeMQTT(host: "", identifier: UUID().uuidString)
                self.mqttManager.connect()
                self.mqttManager.currentAppState.$appConnectionState.sink { state in
                    if state == .connected || state == .connectedSubscribed || state == .connectedUnSubscribed {
                        completion(true)
                        self.getUserTopics()
                        self.subscribeOnTopics()
                        self.isNotValidShown = false
                    } else if state == .disconnected {
                        print("Error connect to mqtt broker")
                    }
                }.store(in: &self.subscriptions)
            }
        }
    }
    
    private func getUserTopics() {
        firebaseManager.firestore.collection("usersInfo").addSnapshotListener { query, error in
            guard let documents = query?.documents else {
                print("[Firebase error]: storage has no document usersInfo")
                return
            }
            
            if let data = documents.first(where: { documentSnapshot in
                documentSnapshot.data()["userUID"] as? String == self.firebaseManager.auth.currentUser?.uid
            }) {
                self.topics = data["subscibeTopics"] as? [String] ?? []
            } else {
                print("error find uid")
            }
        }
    }
    
    private func subscribeOnTopics() {
        $topics.sink(receiveValue: { values in
            values.forEach({ topic in
                self.mqttManager.subscribe(topic: topic)
            })
        }).store(in: &subscriptions)
    }
    
}

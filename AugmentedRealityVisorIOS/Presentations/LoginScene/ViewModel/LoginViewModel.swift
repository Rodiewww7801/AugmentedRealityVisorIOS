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
    @Published var credentials: Credentials = Credentials(email: "", password: "")
    @Published var showProgressView: Bool = false
    @Published var isNotValidShown: Bool = false
    private var mqttManager = MQTTManager.shared()
    private var subscriptions = Set<AnyCancellable>()
    
    var loginDisabled: Bool {
        return credentials.email.isEmpty  || credentials.password.isEmpty
    }
    
    func login(completion: @escaping (Bool) -> Void ) {
        showProgressView = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [unowned self] in
            if self.credentials.password == "123" {
                self.mqttManager.initializeMQTT(host: "", identifier: UUID().uuidString)
                self.mqttManager.connect()
                self.mqttManager.currentAppState.$appConnectionState.sink { state in
                    if state == .connected || state == .connectedSubscribed || state == .connectedUnSubscribed {
                        completion(true)
                        self.isNotValidShown = false
                    } else {
                        print("Error connect to mqtt broker")
                       // self.isConnectToMQTTFailed = true
                    }
                }.store(in: &self.subscriptions)
            } else {
                self.credentials = Credentials(email: "", password: "")
                completion(false)
                print("Error not valid login and/or password")
                self.isNotValidShown = true
            }
            self.showProgressView = false
        }
    }
    
    
}

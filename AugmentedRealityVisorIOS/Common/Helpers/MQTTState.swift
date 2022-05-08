//
//  MQTTState.swift
//  AugmentedRealityVisorIOS
//
//  Created by Rodion Hladchenko on 06.03.2022.
//

import Foundation

enum MQTTConectionState {
    case connected
    case disconnected
    case connecting
    case connectedSubscribed
    case connectedUnsubscribed
    
    var description: String {
        switch self {
        case .connected:
            return "Connected"
        case .disconnected:
            return "Disconnected"
        case .connecting:
            return "Connecting"
        case .connectedSubscribed:
            return "Subscribed"
        case .connectedUnsubscribed:
            return "Connected Unsubscribed"
        }
    }
    
    var isConnected: Bool {
        switch self {
        case .connected, .connectedSubscribed, .connectedUnsubscribed: return true
        default: return false
        }
    }
    
    var isSubscribed: Bool {
        switch self {
        case .connectedSubscribed, .connectedUnsubscribed: return true
        default: return false
        }
    }
}

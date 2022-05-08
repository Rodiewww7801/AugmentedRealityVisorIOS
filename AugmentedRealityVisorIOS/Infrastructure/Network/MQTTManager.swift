//
//  MQTTManager.swift
//  SwiftUI_MQTT
//
//  Created by Anoop M on 2021-01-19.
//

import Foundation

import CocoaMQTT
import Combine

final class MQTTManager: ObservableObject {
    private var mqttClient: CocoaMQTT?
    private var identifier: String!
    private var host: String!
    private var topic: String!
    private var username: String!
    private var password: String!
    private let notificationCenter = UNUserNotificationCenter.current()
    private let content = UNMutableNotificationContent()
    private var notificationDelegate = NotificationDelegate()
    @Published var responseMessages: [String : CocoaMQTTMessage] = [:]
    @Published var topics: [String] = []
    @Published var currentAppState = MQTTAppState()
    private var anyCancellable: AnyCancellable?
    // Private Init
     private init() {
        // Workaround to support nested Observables, without this code changes to state is not propagated
        anyCancellable = currentAppState.objectWillChange.sink { [weak self] _ in
            self?.objectWillChange.send()
        }
    }

    // MARK: Shared Instance

    private static let _shared = MQTTManager()

    // MARK: - Accessors

    class func shared() -> MQTTManager {
        return _shared
    }

    func initializeMQTT(host: String, identifier: String, username: String? = nil, password: String? = nil) {
        // If any previous instance exists then clean it
        if mqttClient != nil {
            mqttClient = nil
        }
        self.identifier = identifier
        self.host = "test.mosquitto.org"
        self.username = username
        self.password = password
        let clientID = "CocoaMQTT-\(identifier)-" + String(ProcessInfo().processIdentifier)

        // TODO: Guard
        mqttClient = CocoaMQTT(clientID: clientID, host: self.host, port: 1883)
        // If a server has username and password, pass it here
        if let finalusername = self.username, let finalpassword = self.password {
            mqttClient?.username = finalusername
            mqttClient?.password = finalpassword
        }
        //mqttClient?.willMessage = CocoaMQTTWill(topic: "/will", message: "dieout")
        mqttClient?.keepAlive = 60
        mqttClient?.delegate = self
    }

    func connect() {
        if let success = mqttClient?.connect(), success {
            currentAppState.setAppConnectionState(state: .connecting)
            notificationSetup()
        } else {
            currentAppState.setAppConnectionState(state: .disconnected)
        }
    }

    func subscribe(topic: String, qos: CocoaMQTTQoS = .qos1) {
        if let _ = topics.first(where: { $0.lowercased() == topic.lowercased() }) {
            return
        }
        self.topic = topic
        topics.append(topic)
        mqttClient?.subscribe(topic, qos: .qos1)
        print("[MQTT]: success subsribe on topic: \(topic)")
    }

    func publish(topic: String, with message: String) {
        let message = CocoaMQTTMessage(topic: topic, string: message, qos: .qos1, retained: true)
        //mqttClient?.publish(topic, withString: message, qos: .qos1, retained: true)
        mqttClient?.publish(message)
        print("[MQTT Publish]:\ntopic:\(topic)\nmessage: \(message)")
    }

    func disconnect() {
        mqttClient?.disconnect()
    }

    /// Unsubscribe from a topic
    func unSubscribe(topic: String) {
        topics.removeAll(where:  { $0.lowercased() == topic.lowercased() })
        mqttClient?.unsubscribe(topic)
    }

    /// Unsubscribe from a topic
    func unSubscribeFromCurrentTopic() {
        mqttClient?.unsubscribe(topic)
    }
    
    func currentHost() -> String? {
        return host
    }
    
    func isSubscribed() -> Bool {
       return currentAppState.appConnectionState.isSubscribed
    }
    
    func isConnected() -> Bool {
        return currentAppState.appConnectionState.isConnected
    }
    
    func connectionStateMessage() -> String {
        return currentAppState.appConnectionState.description
    }
}

extension MQTTManager: CocoaMQTTDelegate {
    func mqtt(_ mqtt: CocoaMQTT, didSubscribeTopics success: NSDictionary, failed: [String]) {
        //
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didUnsubscribeTopics topics: [String]) {
        TRACE("topic: \(topics)")
        currentAppState.setAppConnectionState(state: .connectedSubscribed)
    }

    func mqtt(_ mqtt: CocoaMQTT, didConnectAck ack: CocoaMQTTConnAck) {
        TRACE("ack: \(ack)")

        if ack == .accept {
            currentAppState.setAppConnectionState(state: .connected)
        }
        //subscribe(topic: "rodie/#")
    }

    func mqtt(_ mqtt: CocoaMQTT, didPublishMessage message: CocoaMQTTMessage, id: UInt16) {
        TRACE("message: \(message.string.description), id: \(id)")
    }

    func mqtt(_ mqtt: CocoaMQTT, didPublishAck id: UInt16) {
        TRACE("id: \(id)")
    }

    func mqtt(_ mqtt: CocoaMQTT, didReceiveMessage message: CocoaMQTTMessage, id: UInt16) {
        let textMessage = "Topic: \(message.topic), Message: \(message.string.description)"
        responseMessages[message.topic] = message
        TRACE("message: \(textMessage), id: \(id)")
        currentAppState.setReceivedMessage(text: textMessage)
        if  message.topic.lowercased().contains("notification") {
            scheduleNotification(topic: "ARV", message: message.string ?? "")
        }
    }

    func mqtt(_ mqtt: CocoaMQTT, didUnsubscribeTopic topic: String) {
        TRACE("topic: \(topic)")
        currentAppState.setAppConnectionState(state: .connectedUnSubscribed)
        currentAppState.clearData()
    }

    func mqttDidPing(_ mqtt: CocoaMQTT) {
        TRACE()
    }

    func mqttDidReceivePong(_ mqtt: CocoaMQTT) {
        TRACE()
    }

    func mqttDidDisconnect(_ mqtt: CocoaMQTT, withError err: Error?) {
        TRACE("\(err.description)")
        currentAppState.setAppConnectionState(state: .disconnected)
    }
}

extension MQTTManager {
    func TRACE(_ message: String = "", fun: String = #function) {
        let names = fun.components(separatedBy: ":")
        var prettyName: String
        if names.count == 1 {
            prettyName = names[0]
        } else {
            prettyName = names[1]
        }

        if fun == "mqttDidDisconnect(_:withError:)" {
            prettyName = "didDisconect"
        }

        print("[TRACE] [\(prettyName)]: \(message)")
    }
}

extension Optional {
    // Unwrap optional value for printing log only
    var description: String {
        if let wraped = self {
            return "\(wraped)"
        }
        return ""
    }
}

extension MQTTManager {
    func notificationSetup() {
        //let notificationCenter = UNUserNotificationCenter.current()
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        
        notificationCenter.requestAuthorization(options: options) {
            (didAllow, error) in
            if !didAllow {
                print("User has declined notifications")
            }
        }
        notificationCenter.delegate = notificationDelegate
    }
    
    func scheduleNotification(topic: String, message: String) {
        
         // Содержимое уведомления
        
        content.title = topic
        content.body = message
        content.sound = UNNotificationSound.default
        content.badge = 0
        
        let triger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        
        let identifier = "Local Notification"
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: triger)

        notificationCenter.add(request) { (error) in
            if let error = error {
                print("Error \(error.localizedDescription)")
            }
        }
    }
}

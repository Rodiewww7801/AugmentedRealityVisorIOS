//
//  NotificationDelegate.swift
//  AugmentedRealityVisorIOS
//
//  Created by Rodion Hladchenko on 23.04.2022.
//

import Foundation
import UserNotifications

class NotificationDelegate: NSObject, ObservableObject, UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.badge, .banner, .sound])
    }
}

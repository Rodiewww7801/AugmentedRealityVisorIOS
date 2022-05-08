//
//  MQTTLogger.swift
//  AugmentedRealityVisorIOS
//
//  Created by Rodion Hladchenko on 06.03.2022.
//

import Foundation

final class MQTTLogger {
    class func log(_ message: String = "", function: String = #function) {
        print("[\(function)]: \(message)")
    }
}

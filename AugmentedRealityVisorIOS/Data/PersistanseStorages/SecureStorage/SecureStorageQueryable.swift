//
//  SecureStorageQueryable.swift
//  VirtualSupervisorIOS
//
//  Created by Rodion Hladchenko on 11.02.2022.
//

import Foundation

public protocol SecureStorageQueryable {
    var query: [String : Any] { get }
}

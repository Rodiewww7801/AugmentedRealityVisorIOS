//
//  AuthTokenStorage.swift
//  VirtualSupervisorIOS
//
//  Created by Rodion Hladchenko on 11.02.2022.
//

import Foundation

protocol AuthTokenStorageProtocol {
    func getToken() throws -> String?
    func setToken(_ value: String) throws
    func removeToken() throws
}

struct AuthTokenStorage: AuthTokenStorageProtocol {
    private let securedStorage: SecureStorageProtocol
    private let authenticationTokenKey = "AuthenticationTokenKey"
    
    init() {
        self.securedStorage = KeychainStorage(secureStorageQueryable: GenericPasswordQueryable(service: "AuthenticationTokenService"))
    }
    
    func getToken() throws -> String? {
        do {
            let token = try securedStorage.getValue(for: authenticationTokenKey)
            return token
        } catch {
            throw error
        }
    }
    
    func setToken(_ value: String) throws {
        do {
            try securedStorage.setValue(value, for: authenticationTokenKey)
        } catch {
            throw error
        }
    }
    
    func removeToken() throws {
        do {
            try securedStorage.removeValue(for: authenticationTokenKey)
        } catch {
            throw error
        }
    }
}

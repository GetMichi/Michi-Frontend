//
//  KeychainManager.swift
//  Secure storage
//
//  Created by Jennifer Shi on 2026-02-07.
//

import Foundation
import Security

class KeychainManager {
    static let shared = KeychainManager()
    
    private init() {}
    
    // MARK: - Save
    func save(_ data: Data, forKey key: String) -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecValueData as String: data,
            kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlockedThisDeviceOnly
        ]
        
        // Delete any existing item
        SecItemDelete(query as CFDictionary)
        
        // Add new item
        let status = SecItemAdd(query as CFDictionary, nil)
        return status == errSecSuccess
    }
    
    func save(_ string: String, forKey key: String) -> Bool {
        guard let data = string.data(using: .utf8) else { return false }
        return save(data, forKey: key)
    }
    
    // MARK: - Retrieve
    func getData(forKey key: String) -> Data? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        if status == errSecSuccess {
            return result as? Data
        }
        return nil
    }
    
    func getString(forKey key: String) -> String? {
        guard let data = getData(forKey: key) else { return nil }
        return String(data: data, encoding: .utf8)
    }
    
    // MARK: - Delete
    func delete(forKey key: String) -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        return status == errSecSuccess
    }
    
    // MARK: - Token Management
    func saveAccessToken(_ token: String) -> Bool {
        save(token, forKey: Config.Keychain.accessTokenKey)
    }
    
    func getAccessToken() -> String? {
        getString(forKey: Config.Keychain.accessTokenKey)
    }
    
    func deleteAccessToken() -> Bool {
        delete(forKey: Config.Keychain.accessTokenKey)
    }
    
    func saveRefreshToken(_ token: String) -> Bool {
        save(token, forKey: Config.Keychain.refreshTokenKey)
    }
    
    func getRefreshToken() -> String? {
        getString(forKey: Config.Keychain.refreshTokenKey)
    }
    
    func deleteRefreshToken() -> Bool {
        delete(forKey: Config.Keychain.refreshTokenKey)
    }
    
    func savePlaidToken(_ token: String) -> Bool {
        save(token, forKey: Config.Keychain.plaidTokenKey)
    }
    
    func getPlaidToken() -> String? {
        getString(forKey: Config.Keychain.plaidTokenKey)
    }
    
    func deletePlaidToken() -> Bool {
        delete(forKey: Config.Keychain.plaidTokenKey)
    }
    
    // MARK: - Clear All
    func clearAll() -> Bool {
        var success = true
        success = success && deleteAccessToken()
        success = success && deleteRefreshToken()
        success = success && deletePlaidToken()
        return success
    }
}

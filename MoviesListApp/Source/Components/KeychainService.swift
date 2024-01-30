//
//  KeychainService.swift
//  MoviesListApp
//
//  Created by MA1424 on 30/01/24.
//

import Foundation
import Security

class KeychainService {
    
    @discardableResult
    static func save(key: String, data: Data) -> OSStatus {
        let query = [
            kSecClass as String       : kSecClassGenericPassword as String,
            kSecAttrAccount as String : key,
            kSecValueData as String   : data ] as [String : Any]

        SecItemDelete(query as CFDictionary)
        return SecItemAdd(query as CFDictionary, nil)
    }

    static func load(key: String) -> String? {
        let query = [
            kSecClass as String       : kSecClassGenericPassword,
            kSecAttrAccount as String : key,
            kSecReturnData as String  : kCFBooleanTrue!,
            kSecMatchLimit as String  : kSecMatchLimitOne ] as [String : Any]

        var dataTypeRef: AnyObject?
        let status: OSStatus = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)

        if status == noErr {
            if let retrievedData = dataTypeRef as? Data,
               let result = String(data: retrievedData, encoding: .utf8) {
                return result
            }
        }
        return nil
    }

    @discardableResult
    static func delete(key: String) -> OSStatus {
        let query = [
            kSecClass as String       : kSecClassGenericPassword,
            kSecAttrAccount as String : key ] as [String : Any]

        return SecItemDelete(query as CFDictionary)
    }
}

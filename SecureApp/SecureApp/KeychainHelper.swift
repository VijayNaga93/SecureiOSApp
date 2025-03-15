//
//  KeychainHelper.swift
//  SecureApp
//
//  Created by Vijay N on 16/03/25.
//

import Foundation
import Security


/*
 Reference for keychain: https://medium.com/@ranga.c222/how-to-save-sensitive-data-in-keychain-in-ios-using-swift-c839d0e98f9d
 */


public enum KeychainError: Error {
    case keychainErrorSomethingWentWrong
    
    
    var description: String {
        switch self {
        case .keychainErrorSomethingWentWrong:
            return "Something went wrong trying to find the user in the keychain"
        }
    }
    
}


class KeychainHelper {
    
    static let accountValue: String = "SecureApp"
    
    //    static func saveToKeychain(data: Data, service: String, account: String) -> Bool {
    
    static func saveToKeychain(data: Data, service: String) -> Bool {
        let query: [String:Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
//            kSecAttrAccount as String: accountValue,
            //            kSecAttrLabel as String: "some label string for reference",
            kSecValueData as String: data
        ]
        
        //        let status = SecItemAdd(query as CFDictionary, nil)
        //        return status == errSecSuccess
        
        
        if SecItemAdd(query as CFDictionary, nil) == noErr {
            print("Keychain - data save successfully")
            return true
        } else {
            print("Keychain - Something went wrong data save failed")
            return false
        }
    }
    
    static func retrieveFromKeychain(service: String) -> Result<Data, KeychainError> {
        let query: [String:Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
//            kSecMatchLimit as String: kSecMatchLimitOne,
//            kSecAttrAccount as String: accountValue,
            kSecReturnAttributes as String: true,
            kSecReturnData as String: true
        ]
        
        var item: CFTypeRef?
        if SecItemCopyMatching(query as CFDictionary, &item) == errSecSuccess {
            if let existingItem = item as? [String:Any] {
                
                if let service = existingItem[kSecAttrService as String] as? String,
                   let data = existingItem[kSecValueData as String] as? Data,
                   let dataStr = String(data: data, encoding: .utf8) {
                    print("KeychainCheck - service:\(service) - data:\(dataStr)")
                    return .success(data)
                }
            }
        }
        print("Keychain - Something went wrong data retreive failed")
        return .failure(.keychainErrorSomethingWentWrong)
    }
    
    static func updateKeychain(data: Data, service: String) -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service
        ]
        
        let attributes: [String: Any] = [kSecValueData as String: data]
        
        if SecItemUpdate(query as CFDictionary, attributes as CFDictionary) == noErr {
            print("Keychain - update successful")
            return true
        } else {
            print("Keychain - Something went wrong update failed")
            return false
        }
    }
    
    static func deleteFromKeychain(service: String) -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service
        ]
                
        if SecItemDelete(query as CFDictionary) == noErr {
            print("Keychain - delete successful")
            return true
        } else {
            print("Keychain - Something went wrong delete failed")
            return false
        }
    }
    
}




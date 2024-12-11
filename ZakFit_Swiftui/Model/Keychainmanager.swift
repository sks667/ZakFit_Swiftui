//
//  Keychainmanager.swift
//  ZakFit_Swiftui
//
//  Created by Apprenant 178 on 09/12/2024.
//
import Foundation
import Security

struct KeyChainManager {

    static func save(token: String) {
        guard let tokenData = token.data(using: .utf8) else {
            print("Error converting token to data")
            return
        }
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: "VaporFrontToken",
            kSecValueData as String: tokenData
        ]
        SecItemDelete(query as CFDictionary)

        SecItemAdd(query as CFDictionary, nil)
    }

    static func get() -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: "VaporFrontToken",
            kSecReturnData as String: true
        ]

        var item : CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)

        if status == errSecSuccess, let data = item as? Data {
            return String(data: data, encoding: .utf8)
        }
        return nil
    }

    static func deleteToken() {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: "VaporFrontToken"
        ]

        let status = SecItemDelete(query as CFDictionary)
        if status != errSecSuccess {
            print("Erreur lors de la suppression du token : \(status)")
        } else {
            print("Token supprimé avec succès du Keychain")
        }
    }
}

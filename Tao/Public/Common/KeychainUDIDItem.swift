//
//  KeyChainUDIDItem.swift
//  iOSQuizzes
//
//  Created by user on 2018/8/24.
//  Copyright © 2018年 XML. All rights reserved.
//

import Foundation

struct KeychainUDIDItem {
    
    // MARK: Types
    enum KeychainError: Error {
        case noUDID
        case unexpectedUDIDData
        case unexpectedItemData
        case unhandleError(sttus: OSStatus)
    }
    
    // MARK: Properties

    let service: String
    
    private(set) var key: String
    
    let accessGroup: String?
    
    // MAKR: Initialization
    
    init(service: String, key: String, accessGroup: String? = nil) {
        self.service = service
        self.key = key
        self.accessGroup = accessGroup
    }
    
    // MAKR: Keychain access
    
    func readUDID() throws -> String {
        var query = KeychainUDIDItem.keychainQuery(withService: service, key: key, accessGroup: accessGroup)
        query[kSecMatchLimit as String] = kSecMatchLimitOne
        query[kSecReturnData as String] = kCFBooleanTrue
        query[kSecReturnAttributes as String] = kCFBooleanTrue
        
        // 尝试获取钥匙串
        var queryResult: AnyObject?
        let status = withUnsafeMutablePointer(to: &queryResult) {
            SecItemCopyMatching(query as CFDictionary, UnsafeMutablePointer($0))
        }
        
        guard status != errSecItemNotFound else { throw KeychainError.noUDID }
        guard status == noErr else { throw KeychainError.unhandleError(sttus: status) }
        
        // 解析
        guard let existingItem = queryResult as? [String: AnyObject],
            let UDIDData = existingItem[kSecValueData as String] as? Data,
            let UDID = String(data: UDIDData, encoding: String.Encoding.utf8)
        else {
            throw KeychainError.unexpectedUDIDData
        }
        return UDID
    }
    
    func saveUDID(_ udid: String) throws {
        let encodingUDID = udid.data(using: String.Encoding.utf8)
        
        do {
            // 检查钥匙串中现有项目
            try _ = readUDID()
            
            var attributesToUpdate = [String: AnyObject]()
            attributesToUpdate[kSecValueData as String] = encodingUDID as AnyObject?
            let query = KeychainUDIDItem.keychainQuery(withService: service, key: key, accessGroup: accessGroup)
            let status = SecItemUpdate(query as CFDictionary, attributesToUpdate as CFDictionary)
            guard status == noErr else { throw KeychainError.unhandleError(sttus: status) }
        }
        catch {
            // 如果没有项目，新建一个字典来存储
            var newItem = KeychainUDIDItem.keychainQuery(withService: service, key: key, accessGroup: accessGroup)
            newItem[kSecValueData as String] = encodingUDID as AnyObject?
            
            // 添加新的项目到钥匙串
            let status = SecItemAdd(newItem as CFDictionary, nil)
            
            guard status == noErr else { throw KeychainError.unhandleError(sttus: status) }
        }
    }
    
    // MARK: Convenience
    
    private static func keychainQuery(withService service: String, key: String? = nil, accessGroup: String? = nil) -> [String : AnyObject] {
        var query = [String : AnyObject]()
        query[kSecClass as String] = kSecClassGenericPassword
        query[kSecAttrService as String] = service as AnyObject?
        query[kSecAttrAccessible as String] = kSecAttrAccessibleAfterFirstUnlock
        
        if let key = key {
            query[kSecAttrAccount as String] = key as AnyObject?
        }
        
        if let accessGroup = accessGroup {
            query[kSecAttrAccessGroup as String] = accessGroup as AnyObject?
        }
        
        return query
    }
}

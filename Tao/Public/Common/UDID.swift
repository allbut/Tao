//
//  UDID.swift
//  iOSQuizzes
//
//  Created by user on 2018/8/24.
//  Copyright © 2018年 XML. All rights reserved.
//

import Foundation

struct UDID {
    static func getUDID() -> String {
        do {
            let keychainUUIDItem = KeychainUDIDItem(service: KeychainConfiguration.serviceName, key: KeychainConfiguration.key)
            let uuid = try keychainUUIDItem.readUDID()
            return uuid
        }
        catch {
            if let keychainError = error as? KeychainUDIDItem.KeychainError {
                switch keychainError {
                case .noUDID:
                    do {
                        let keychainUUIDItem = KeychainUDIDItem(service: KeychainConfiguration.serviceName, key: KeychainConfiguration.key)
                        try keychainUUIDItem.saveUDID(NSUUID().uuidString)
                        let uuid = try keychainUUIDItem.readUDID()
                        return uuid
                    }
                    catch {
                        fatalError("Error save keychain - \(error)")
                    }
                default:
                    fatalError("Error read keychain - \(error)")
                }
            }
        }
        return ""
    }
}

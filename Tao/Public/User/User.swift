//
//  UserInfo.swift
//  Gloden Palace Casino
//
//  Created by albutt on 2018/12/4.
//  Copyright © 2018 海创中盈. All rights reserved.
//

import Foundation

private let userKey = "userInfoDefaultsKey"
private let accountKey = "accountKey"
/// 处理用户数据本地化
class User {
    static var shared: User!
    
    private let defaults: UserDefaults
    init(defaults: UserDefaults) {
        self.defaults = defaults
    }
    
    /// Info
    var info: UserItem {
        guard let data = defaults.object(forKey: userKey) as? Data else {
            return UserItem()
        }
        let decoder = JSONDecoder()
        if let info = try? decoder.decode(UserItem.self, from: data) {
            return info
        } else {
            return UserItem()
        }
    }
    
    func save(user: UserItem) {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(user)
            defaults.set(data, forKey: userKey)
        } catch {
            print("[ERROR]: \(#function) User Info Encode Error")
        }
    }
    
    func deleteInfo() {
        save(user: UserItem())
    }
    
    /// Account
    var account: String? {
        return defaults.object(forKey: accountKey) as? String
    }
    
    func save(account: String) {
        defaults.set(account, forKey: accountKey)
    }
    
    func deleteAccount() {
        defaults.removeObject(forKey: accountKey)
    }
}

/// 退出登录
public func signOut() {
    BackendAuth.shared.deleteToken()
    User.shared.deleteInfo()
    NotificationCenter.default.post(name: NSNotification.Name.signOut, object: nil, userInfo: nil)
}

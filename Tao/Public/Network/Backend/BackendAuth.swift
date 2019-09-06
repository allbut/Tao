//
//  BackendAuth.swift
//  toytt
//
//  Created by user on 2018/7/23.
//  Copyright © 2018年 grayworm. All rights reserved.
//

import Foundation

public final class BackendAuth {
    private let key = "backendAuthToken"
    private let defaults: UserDefaults
    
    public static var shared: BackendAuth!
    
    init(defaults: UserDefaults) {
        self.defaults = defaults
    }
    
    public func setToken(token: String) {
        defaults.set(token, forKey: key)
    }
    
    public var token: String? {
        return defaults.value(forKey: key) as? String
    }
    
    public func deleteToken() {
        defaults.removeObject(forKey: key)
    }
}

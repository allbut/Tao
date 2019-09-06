//
//  BackendConfiguration.swift
//  toytt
//
//  Created by user on 2018/7/23.
//  Copyright © 2018年 grayworm. All rights reserved.
//

import Foundation

/// 后台配置
struct BackendConfiguration {
    let baseURL: URL
    public init(baseURL: URL) {
        self.baseURL = baseURL
    }
    
    public static var shared: BackendConfiguration!
}

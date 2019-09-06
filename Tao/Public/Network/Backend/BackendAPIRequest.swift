//
//  BackendAPIRequest.swift
//  toytt
//
//  Created by user on 2018/7/23.
//  Copyright © 2018年 grayworm. All rights reserved.
//

import Foundation
import UIKit

/// 构建请求
protocol BackendAPIRequest {
    var endPoint: String { get }
    var method: NetworkService.Method { get }
    var query: NetworkService.QueryType { get }
    var parameters: [String: Any]? { get }
    var headers: [String: String]? { get }
}

extension BackendAPIRequest {

    func defaultJSONHeaders() -> [String: String] {
        let header = ["client": "iOS",
                      "versionCode": String(Application.versionCode),
                      "language": Languager.shared.language == .chinese ? "zh" : "en"
                      ]
        return header
        // token 在 BackendService 类中添加
    }
    
    var headers: [String: String]? {
        return defaultJSONHeaders()
    }
    
    var identifier: String {
        let headerHash = headers?.hashValue ?? 0
        let endpointHash = endPoint.hashValue
        let id = "\(headerHash)090\(endpointHash)"
        return id
    }
}


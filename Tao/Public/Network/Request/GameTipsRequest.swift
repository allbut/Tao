//
//  GameTipsRequest.swift
//  Gloden Palace Casino
//
//  Created by albutt on 2019/1/17.
//  Copyright © 2019 海创中盈. All rights reserved.
//

import UIKit


/// 游戏小贴士请求
struct GameTipsRequest: BackendAPIRequest {
    var gameEn: String
    
    var endPoint: String {
        return "/gametips/list"
    }
    
    var method: NetworkService.Method {
        return .GET
    }
    
    var query: NetworkService.QueryType {
        return .path
    }
    
    var parameters: [String : Any]? {
        return ["gameEn": gameEn]
    }
    
    init(gameEn: String) {
        self.gameEn = gameEn
    }
}

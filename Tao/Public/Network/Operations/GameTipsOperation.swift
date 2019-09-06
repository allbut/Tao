//
//  GameTipsOperation.swift
//  Gloden Palace Casino
//
//  Created by albutt on 2019/1/17.
//  Copyright © 2019 海创中盈. All rights reserved.
//

import Foundation

/// 游戏小贴士
class GameTipsOperation: ObjectOperation<GameTipsRequest, [String]> {
    
    init(gameEn: String) {
        let request = GameTipsRequest(gameEn: gameEn)
        super.init(request: request)
    }
    
}

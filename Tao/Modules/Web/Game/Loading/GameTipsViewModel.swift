//
//  GameTipsViewModel.swift
//  Gloden Palace Casino
//
//  Created by albutt on 2019/1/17.
//  Copyright © 2019 海创中盈. All rights reserved.
//

import Foundation

/// 游戏i小贴士
class GameTipsViewModel {
    typealias Tips = [String]
    var handleTips: ((Tips) -> Void)?
    
    func requestGameTips(gameEn: String) {
        let operation = GameTipsOperation(gameEn: gameEn)
        operation.isShowLoading = false
        operation.isToastWhenSuccess = false
        operation.isToastWhenFailure = false
        operation.isPromptWhenException = false
        operation.success = handleTips
        NetworkQueue.shared.addOperation(operation: operation)
    }
}

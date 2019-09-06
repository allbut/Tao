//
//  GameLoadingProtocol.swift
//  Gloden Palace Casino
//
//  Created by albutt on 2018/12/24.
//  Copyright © 2018 海创中盈. All rights reserved.
//

import UIKit

/// 游戏加载页协议
protocol GameLoadingProtocol where Self: UIView {
    var progress: Double { get set }
    var handleBack: (() -> Void)? { get set }
    var gameEn: GameEn? { get set }
    var tip: String { get set }
}

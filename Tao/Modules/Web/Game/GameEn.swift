//
//  GameEn.swift
//  Gloden Palace Casino
//
//  Created by albutt on 2018/12/24.
//  Copyright © 2018 海创中盈. All rights reserved.
//

import Foundation

enum GameEn: String {
    case lhd                    // 龙虎斗
    case lucky777 = "laohuji"   // 幸运777
    case liu = "liuliuliu"      // 666
    case dlp                    // 大轮盘
    case cdx = "caiDx"          // 猜大小
    case bjl                    // 百家乐
    case brn                    // 百人牛牛
    case qzp                    // 七张牌
    case landscape              // 常规横屏
    case portrait               // 常规竖屏
}

extension GameEn {
    // 背景图片
    var backgroundImageName: String {
        switch self {
        case .liu:
            return "loading_666_background"
        case .dlp:
            return "loading_dlp_background"
        case .cdx:
            return "loading_cdx_background"
        case .bjl:
            return "loading_bjl_background"
        case .lhd:
            return "loading_lhd_background"
        case .lucky777:
            return "loading_lhj_background"
        case .brn:
            return "loading_brn_background"
        case .qzp:
            return "loading_qzp_background"
        case .landscape:
            return "loading_normal_background_h"
        case .portrait:
            return "loading_normal_background_v"
        }
    }
    
    var progressHeaderImageName: String {
        switch self {
        case .lhd:
            return "loading_lhd_progress_head"
        case .lucky777:
            return "loading_lhj_progress_head"
        case .liu:
            return "loading_666_progress_head"
        case .dlp:
            return "loading_dlp_progress_head"
        case .cdx:
            return "loading_cdx_progress_head"
        case .bjl:
            return "loading_bjl_progress_head"
        case .brn:
            return "loading_bjl_progress_head"
        case .qzp:
            return "loading_bjl_progress_head"
        case .landscape:
            return "loading_cdx_progress_head"
        case .portrait:
            return "loading_cdx_progress_head"
        }
    }
    
    /// 当前进度
    var currentProgressImageName: String {
        switch self {
        case .liu, .cdx, .portrait:
            return "loading_normal_progress_current_v"
        case .bjl, .dlp, .lhd, .lucky777, .brn, .qzp, .landscape:
            return "loading_normal_progress_current_h"
        }
        
    }
    
    /// 进度背景
    var completeProgressImageName: String {
        switch self {
        case .liu, .cdx, .portrait:
            return "loading_normal_progress_background_v"
        case .bjl, .dlp, .lhd, .lucky777, .brn, .qzp, .landscape:
            return "loading_normal_progress_background_h"
        }
    }
}

extension GameEn {

}

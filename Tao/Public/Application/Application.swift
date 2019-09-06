//
//  Application.swift
//  Gloden Palace Casino
//
//  Created by albutt on 2018/12/7.
//  Copyright © 2018 海创中盈. All rights reserved.
//

import UIKit

// 应用信息
struct ApplicationInfo: Codable {
    // 是否设置过语言
    var isSetLanguage: Bool
    
    // 背景音乐开关 false: 关闭，true: 打开
//    var isTurnOnBGM: Bool
    
    // 音效开关 false: 关闭，true: 打开
//    var isTurnOnSoundEffect: Bool
}

private let applicationKey = "applicationDefaultsKey"
/// 处理应用信息本地化
class Application {
    // 版本号
    static let versionCode: Int = 5
    
    // 是否已提示过更新版本
    static var hasBeenPromptedToUpdate = false
    
    // 默认界面方向
    static let defaultInterfaceOrientations: UIInterfaceOrientationMask = [.landscapeLeft, .landscapeRight]
    
    static var shared: Application!
    private let defaults: UserDefaults
    init(defaults: UserDefaults) {
        self.defaults = defaults
    }
    
    var info: ApplicationInfo {
        guard let data = defaults.object(forKey: applicationKey) as? Data else {
            return defaultInfo()
        }
        let decoder = JSONDecoder()
        if let info = try? decoder.decode(ApplicationInfo.self, from: data) {
            return info
        } else {
            return defaultInfo()
        }
    }
    
    func save(user: ApplicationInfo) {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(user)
            defaults.set(data, forKey: applicationKey)
        } catch {
            print("[ERROR]: \(#function) Application Info Encode Error")
        }
    }
    
    func clearInfo() {
        save(user: defaultInfo())
    }
    
    private func defaultInfo() -> ApplicationInfo {
        let info = ApplicationInfo(isSetLanguage: false)
        return info
    }
}

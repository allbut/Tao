//
//  UserItem.swift
//  Gloden Palace Casino
//
//  Created by albutt on 2018/12/13.
//  Copyright © 2018 海创中盈. All rights reserved.
//

import Foundation

/// 用户数据
struct UserItem: Codable {
    var id: String?
    var nickName: String?
    var mobile: String?
    var icon: Int?          // 头像索引
    var sex: Int?        // 性别 （男：0，女：1，其他：9）
    var safeBalance: Double?
    var balance: Double?
    var bindMobile: Int?    // 是否绑定手机   0-否　1-是
    var setSafePass: Int?   // 是否设置过保险箱密码 0-否　1-是
}

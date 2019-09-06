//
//  URL+Network.swift
//  Quizzes
//
//  Created by user on 2018/9/6.
//  Copyright © 2018年 albutt. All rights reserved.
//

import Foundation

extension URL {
    init?(baseURL: BaseURL) {
        self.init(string: baseURL.rawValue)
    }
}

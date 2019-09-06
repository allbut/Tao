//
//  Int.swift
//  Quizzes
//
//  Created by user on 2018/9/4.
//  Copyright © 2018年 albutt. All rights reserved.
//

import UIKit

extension Int {
    // 适配屏幕 Float
    var adap: CGFloat { return self.cgFloat * CGFloat.adaptation }
}

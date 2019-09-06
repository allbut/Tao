//
//  Float+Adaptation.swift
//  toytt
//
//  Created by user on 2018/7/19.
//  Copyright © 2018年 grayworm. All rights reserved.
//

import UIKit

extension Float {
    // 适配屏幕 Float
    var adap: CGFloat { return self.cgFloat * CGFloat.adaptation }
}

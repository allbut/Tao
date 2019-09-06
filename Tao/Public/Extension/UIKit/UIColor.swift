//
//  UIColor.swift
//  toytt
//
//  Created by user on 2018/7/19.
//  Copyright © 2018年 grayworm. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(hexValue: UInt, alpha: CGFloat = 1.0) {
        let r = Float((hexValue & 0xFF0000) >> 16) / 255.0
        let g = Float((hexValue & 0xFF00) >> 8) / 255.0
        let b = Float(hexValue & 0xFF) / 255.0
        self.init(red: r.cgFloat, green: g.cgFloat, blue: b.cgFloat, alpha: alpha)
    }
}


//
//  CGFloat.swift
//  toytt
//
//  Created by user on 2018/7/19.
//  Copyright © 2018年 grayworm. All rights reserved.
//

import UIKit

extension CGFloat {
    var float: Float { return Float(self) }
    var double: Double { return Double(self) }
    
    static var screenWidth: CGFloat { return CGRect.screen.size.width }
    static var screenHeight: CGFloat { return CGRect.screen.size.height }
    static var statusBarHeight: CGFloat { return UIApplication.shared.statusBarFrame.size.height }
    
    static var adaptation: CGFloat {
        let orientation = UIApplication.shared.statusBarOrientation
        switch orientation {
        case .portrait, .portraitUpsideDown:
            return CGFloat.screenWidth / 375
        case .landscapeLeft, .landscapeRight:
            return CGFloat.screenHeight / 375
        case .unknown:
            return 1
        @unknown default:
            return 1
        }
    }
}

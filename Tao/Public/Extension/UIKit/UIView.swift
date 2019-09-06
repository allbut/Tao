//
//  UIView.swift
//  Gloden Palace Casino
//
//  Created by albutt on 2018/12/3.
//  Copyright © 2018 海创中盈. All rights reserved.
//

import UIKit

extension UIView {
    
    /// 圆角方法
    ///
    /// - Parameters:
    ///   - corners: 需要圆角的角，客串多个
    ///   - radii: 圆角大小
    func corner(by rect: CGRect, corners: UIRectCorner, radii: CGFloat) {
        let maskPath = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radii, height: radii))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.bounds
        maskLayer.path = maskPath.cgPath
        self.layer.mask = maskLayer
    }
}

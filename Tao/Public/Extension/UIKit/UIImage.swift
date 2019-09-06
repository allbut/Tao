//
//  UIImage.swift
//  toytt
//
//  Created by user on 2018/7/25.
//  Copyright © 2018年 allbut. All rights reserved.
//

import UIKit

extension UIImage {
    
    /// 颜色转 Image
    convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }
    
    /// 渐变模式
    enum GradientMode {
        case horizontal
        case vertical
    }
    
    /// 渐变色 Image
    convenience init?(colors: [UIColor], bounds: CGRect = CGRect(origin: .zero, size: CGSize(width: 1, height: 1)), type: GradientMode = .horizontal) {
        
        let cgColors = colors.map { (color) -> CGColor in
            return color.cgColor
        }
        
        let start: CGPoint = .zero
        var end: CGPoint = .zero
        switch type {
        case .horizontal:
            end = CGPoint(x: bounds.size.width, y: 0)
        case .vertical:
            end = CGPoint(x: 0, y: bounds.size.height)
        }
        
        UIGraphicsBeginImageContextWithOptions(bounds.size, true, 1)
        guard let context = UIGraphicsGetCurrentContext() else { UIGraphicsEndImageContext(); return nil }
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let gradient = CGGradient(colorsSpace: colorSpace, colors: cgColors as CFArray, locations: nil)
        context.drawLinearGradient(gradient!, start: start, end: end, options: .drawsBeforeStartLocation)
        guard let cgImage = UIGraphicsGetImageFromCurrentImageContext()?.cgImage else { UIGraphicsEndImageContext(); return nil }
        self.init(cgImage: cgImage)
        UIGraphicsEndImageContext()
    }
}

extension UIImage {
    convenience init?(colors: [UIColor], height: CGFloat) {
        self.init(colors: colors, bounds: CGRect(x: 0, y: 0, width: CGFloat.screenWidth, height: height), type: .vertical)
    }
    
    convenience init?(colors: [UIColor], width: CGFloat) {
        self.init(colors: colors, bounds: CGRect(x: 0, y: 0, width: width, height: CGFloat.screenHeight), type: .horizontal)
    }
}

extension UIImage {
    
    /// 处理国际化图片
    ///
    /// - Parameter name: 本地化图片名
    convenience init?(localizable name: String) {
        self.init(named: String(table: "LocalizedImageName", localizable: name))
    }
}





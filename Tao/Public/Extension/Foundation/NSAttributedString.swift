//
//  NSAttributedString.swift
//  Gloden Palace Casino
//
//  Created by albutt on 2018/12/19.
//  Copyright © 2018 海创中盈. All rights reserved.
//

import Foundation
import UIKit

extension NSAttributedString {
    
    /// 棕边框文字
    convenience init(brownStroke string: String,
                     font: UIFont,
                     foregroundColor: UIColor = UIColor(hexValue: 0xFCE9B6),
                     strokeColor: UIColor = UIColor(hexValue: 0x784815),
                     strokeWidth: CGFloat = -3,
                     shadowBlurRadius: CGFloat = 2,
                     shadowOffset: CGSize = CGSize(width: 0, height: 1),
                     shadowColor: UIColor = UIColor(hexValue: 0xB25800)) {
        self.init(stroke: string,
                  font: font,
                  foregroundColor: foregroundColor,
                  strokeColor: strokeColor,
                  strokeWidth: strokeWidth,
                  shadowBlurRadius: shadowBlurRadius,
                  shadowOffset: shadowOffset,
                  shadowColor: shadowColor)
    }
    
    /// 深棕色边框文字
    convenience init(drakBrownStroke string: String,
                     font: UIFont,
                     foregroundColor: UIColor,
                     strokeColor: UIColor = UIColor(hexValue: 0x531605),
                     strokeWidth: CGFloat = -3,
                     shadowBlurRadius: CGFloat = 2,
                     shadowOffset: CGSize = CGSize(width: 0, height: 1),
                     shadowColor: UIColor = UIColor(hexValue: 0x5D1400)) {
        self.init(stroke: string,
                  font: font,
                  foregroundColor: foregroundColor,
                  strokeColor: strokeColor,
                  strokeWidth: strokeWidth,
                  shadowBlurRadius: shadowBlurRadius,
                  shadowOffset: shadowOffset,
                  shadowColor: shadowColor)
    }
    
    /// 带阴影、边框的文字
    convenience init(stroke string: String,
                     font: UIFont,
                     foregroundColor: UIColor,
                     strokeColor: UIColor,
                     strokeWidth: CGFloat,
                     shadowBlurRadius: CGFloat,
                     shadowOffset: CGSize,
                     shadowColor: UIColor) {
        let shadow = NSShadow()
        shadow.shadowBlurRadius = shadowBlurRadius
        shadow.shadowOffset = shadowOffset
        shadow.shadowColor = shadowColor
        let attributes = [NSAttributedString.Key.font: font,
                          NSAttributedString.Key.foregroundColor: foregroundColor,
                          NSAttributedString.Key.strokeWidth: strokeWidth,
                          NSAttributedString.Key.strokeColor: strokeColor,
                          NSAttributedString.Key.shadow: shadow] as [NSAttributedString.Key : Any]
        self.init(string: string, attributes: attributes)
    }
}

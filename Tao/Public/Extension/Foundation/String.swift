//
//  String.swift
//  Gloden Palace Casino
//
//  Created by albutt on 2018/11/30.
//  Copyright © 2018 海创中盈. All rights reserved.
//

import Foundation

extension String {

    var base64Encode: String? {
        let data = self.data(using: .utf8)
        if let base64Str = data?.base64EncodedString(options: .lineLength64Characters) {
            return base64Str
        } else {
            return nil
        }
    }
    
    var base64Decode: String? {
        if let data = Data(base64Encoded: self, options: .ignoreUnknownCharacters),
            let decodeStr = String(data: data, encoding: .utf8) {
            return decodeStr
        } else {
            return nil
        }
    }
}


extension String {
    
    /// 金额
    var amount: String {
        let pattern = "^[\\+\\-]?\\d+\\.?\\d{0,2}"  // 保留两位小数
        if let result = self.regexMatches(pattern: pattern).first {
            return result
        }
        return ""
    }
    
    /// 纯数字
    var pureNumber: String {
        let pattern = "[^0-9]"
        return self.regularReplace(pattern: pattern, with: "")
    }
    
    /// 纯字母
    var pureLetter: String {
        let pattern = "[^A-Za-z]"
        return self.regularReplace(pattern: pattern, with: "")
    }
    
    /// 正则替换
    func regularReplace(pattern: String, with string: String, options: NSRegularExpression.Options = []) -> String {
        do {
            let regex = try NSRegularExpression(pattern: pattern, options: options)
            return regex.stringByReplacingMatches(in: self, options: [], range: NSMakeRange(0, self.count), withTemplate: string)
        } catch {
            return self
        }
    }
    
    /// 正则提取
    func regexMatches(pattern:String) -> [String] {
        let regex = try! NSRegularExpression(pattern: pattern, options:[])
        let matches = regex.matches(in: self, options: [], range: NSRange(self.startIndex...,in: self))
        //解析出子串
        return matches.map { m in
            let range = self.range(from: m.range)!
            return String(self[range])
        }
    }

    
    private func range(from nsRange: NSRange) -> Range<String.Index>? {
        guard
            let from16 = utf16.index(utf16.startIndex, offsetBy: nsRange.location,
                                     limitedBy: utf16.endIndex),
            let to16 = utf16.index(from16, offsetBy: nsRange.length,
                                   limitedBy: utf16.endIndex),
            let from = String.Index(from16, within: self),
            let to = String.Index(to16, within: self)
            else { return nil }
        return from ..< to
    }
}


extension String {
    
    /// URL QueryItems
    var urlQueryItems: [URLQueryItem]? {
        return URLComponents(string: self)?.queryItems
    }
    
    var urlQueryDictionary: [String: String]? {
        guard let queryItems = URLComponents(string: self)?.queryItems else {
            return nil
        }
        var dict = [String:String]()
        for qi in queryItems {
            let key = qi.name
            let value = qi.value
            dict[key] = value
        }
        return dict
    }
    
}


extension String {
    var htmlAttributed: NSAttributedString? {
        do {
            guard let data = data(using: String.Encoding.utf8) else {
                return nil
            }
            return try NSAttributedString(data: data,
                                          options: [.documentType: NSAttributedString.DocumentType.html,
                                                    .characterEncoding: String.Encoding.utf8.rawValue],
                                          documentAttributes: nil)
        } catch {
            print("[ERROR]: \(error)")
            return nil
        }
    }
}

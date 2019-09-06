//
//  Languager.swift
//  Gloden Palace Casino
//
//  Created by albutt on 2018/11/29.
//  Copyright © 2018 海创中盈. All rights reserved.
//

import Foundation

enum Language: String {
    case english = "en"
    case chinese = "zh-Hans"
    
    var value: String {
        switch self {
        case .english:
            return "en"
        case .chinese:
            return "zh"
        }
    }
}

/// 语言控制器
class Languager {
    
    
    typealias ChangeHandle = ((Language) -> Void)
    static var shared: Languager!
    
    private let langKey = "lang"
    
    var defaults: UserDefaults
    var language: Language {
        didSet {
            guard language != oldValue else { return }
            defaults.set(language.rawValue, forKey: langKey)
            languageChangedHandle?(language)
        }
    }
    var languageChangedHandle: ((Language) -> Void)?
    
    init(defaults: UserDefaults) {
        self.defaults = defaults
        if let lang = defaults.object(forKey: langKey) as? String {
            language = Language(rawValue: lang)!
        } else {
            language = Languager.systemLanguage
        }
    }
    
}

extension Languager {
    static var systemLanguage: Language {
        if _systemLanguage.hasPrefix("en") {
            return .english
        }
        return .chinese
    }
    
    private static var _systemLanguage: String {
        return Bundle.main.preferredLocalizations.first!
    }
}

extension String {
    init(localizable: String) {
        self.init(table: "Localizable", localizable: localizable)
    }
    
    init(table: String, localizable: String) {
        let clStr = Languager.shared.language.rawValue
        if let lPath = Bundle.main.path(forResource: clStr, ofType: "lproj"),
            let bundle = Bundle(path: lPath) {
            self.init(bundle: bundle, table: table, localizable: localizable)
        } else {
            self.init(localizable)
        }
    }
    
    init(bundle: Bundle, table: String, localizable: String) {
        let string = bundle.localizedString(forKey: localizable, value: nil, table: table)
        self.init(string)
    }
}

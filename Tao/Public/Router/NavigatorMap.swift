//
//  Navigator.swift
//  Gloden Palace Casino
//
//  Created by albutt on 2018/11/27.
//  Copyright © 2018 海创中盈. All rights reserved.
//

import Foundation
import URLNavigator

/// 导航Map
class NavigatorMap {

    static var navigator: Navigator {
        let navigator = Navigator()
        
        // MARK: - 复制文本
        navigator.handle("casino://copy") { (url, values, context) -> Bool in
            if let content = url.queryParameters["content"] {
                UIPasteboard.general.string = content
                Toast.say(message: String(localizable: "common_successful_copy"))
            }
            return true
        }
        
        return navigator
    }
}

protocol Routerable {
    var url: String? { get }
    var context: Any? { get }
    var isLogin: Int? { get }
}

extension Routerable {
    var context: Any? {
        return nil
    }
}

extension Router {
    func open<R: Routerable>(routerable: R) {
        guard let url = routerable.url else { return }
        open(url: url,
             context: routerable.context,
             isNeedToLogIn: routerable.isLogin == 1)
    }
}

extension Router {
    
    func open(url: String?, context: Any? = nil, isNeedToLogIn: Bool = false) {
        guard let url = url else { return }
        /// 如果跳转需要登录，且未登录则弹出登录框
        let token = BackendAuth.shared.token ?? ""
        if isNeedToLogIn,
           token.isEmpty {
//            let logInSuccess: ((String) -> Void) = { [weak self] token in
//                guard let `self` = self else { return }
//                self._open(url: url, context: context)
//            }
//            let loginView = LogInBoxView()
//            loginView.handleSuccess = logInSuccess
//            loginView.display(in: Router.topMost?.view)
        } else {
            _open(url: url, context: context)
        }
    }

    private func _open(url: String, context: Any? = nil) {
        
        let isPushed = self.navigator.push(url, context: context) != nil
        if isPushed {
            print("[Navigator] push: \(url)")
        } else {
            self.navigator.open(url, context: context)
            print("[Navigator] open: \(url)")
        }
    }
    
    func viewController(for url: String?, context: Any? = nil) -> UIViewController? {
        guard let url = url else { return nil }
        let vc = navigator.viewController(for: url, context: context)
        return vc
    }
}

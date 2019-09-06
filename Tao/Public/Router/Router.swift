//
//  Router.swift
//  Gloden Palace Casino
//
//  Created by albutt on 2018/11/30.
//  Copyright © 2018 海创中盈. All rights reserved.
//

import Foundation
import URLNavigator

/// 简单封装的Router
class Router {
    
    static var shared: Router!
    var navigator: Navigator { return _navigator }
    private var _navigator: Navigator
    
    init(navigator: Navigator) {
        self._navigator = navigator
    }
    
    static var topMost: UIViewController? {
        if let topMost = UIViewController.topMost {
            var topViewController = topMost.parent
            while topViewController?.parent != nil {
                topViewController = topViewController?.parent
            }
            if let navigationController = topViewController as? UINavigationController,
                let last = navigationController.viewControllers.last {
                topViewController = last
            }
            return topViewController
        }
        return nil
    }

}


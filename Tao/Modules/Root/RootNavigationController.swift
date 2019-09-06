//
//  RootNavigationController.swift
//  Quizzes
//
// 主要做一些全局性配置
//  Created by user on 2018/8/27.
//  Copyright © 2018年 albutt. All rights reserved.
//

import UIKit

/// Root NavigationController
class RootNavigationController: UINavigationController {
    
    /// 第二次可响应时间
    var secondResponseTime: TimeInterval = 0.5
    private var isIgnoreResponse = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        guard !isIgnoreResponse else { return }
        isIgnoreResponse = true
        DispatchQueue.main.asyncAfter(deadline: .now() + secondResponseTime) { [weak self] in
            guard let `self` = self else { return }
            self.isIgnoreResponse = false
        }
        super.pushViewController(viewController, animated: animated)
    }
}

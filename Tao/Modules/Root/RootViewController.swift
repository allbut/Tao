//
//  ViewController.swift
//  Quizzes
//
//  Created by user on 2018/10/25.
//  Copyright © 2018 albutt. All rights reserved.
//

import UIKit

/// ViewController 基类
class RootViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension RootViewController {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
}


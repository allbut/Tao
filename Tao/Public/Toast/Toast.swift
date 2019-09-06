//
//  Toast.swift
//  Quizzes
//
//  Created by user on 2018/10/8.
//  Copyright © 2018 albutt. All rights reserved.
//

import UIKit

/// Toast
class Toast {
    
    static func say(message: String?, in view: UIView? = UIApplication.shared.keyWindow) {
        if let view = view {
            // 移除已添加的Toast View
            for subv in view.subviews {
                if let toastView = subv as? ToastView {
                    toastView.upwardDisappearing()
                }
            }
        }
        
        ToastView().display(in: view, message: message)
    }
}


/// Toast View
private class ToastView: UIView {
    
    var backgroundImageView: UIImageView!
    var label: UILabel!
    var isAutoDisappearing = true
    var duration: TimeInterval = 2       // 如果isAutoDisappearing = true，则duration秒后视图消失
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initialize() {
        backgroundImageView = UIImageView()
        backgroundImageView.image = UIImage(named: "toast_bg")
        addSubview(backgroundImageView)
        
        label = UILabel()
        label.textColor = UIColor(hexValue: 0xF6DE9C)
        label.font = UIFont.systemFont(ofSize: 17.adap, weight: .bold)
        label.textAlignment = .center
        label.numberOfLines = 3
        backgroundImageView.addSubview(label)
        
        makeConstraints()
    }
    
    private func makeConstraints() {
        
        backgroundImageView.snp.makeConstraints { (maker) in
//            maker.left.right.top.bottom.equalToSuperview()
            maker.center.equalToSuperview()
            maker.top.bottom.equalToSuperview()
            maker.width.equalToSuperview().multipliedBy(0.8)
            maker.height.equalTo(43.adap).priority(300)
        }
        
        label.snp.makeConstraints { (maker) in
            maker.edges.equalTo(UIEdgeInsets(top: 10.adap, left: 18.adap, bottom: 10.adap, right: 18.adap))
        }
    }
    
    func display(in view: UIView? = UIApplication.shared.keyWindow, message: String?) {
        guard let view = view else { return }
        self.label.text = message
        view.addSubview(self)
        self.snp.makeConstraints { (make) in
            make.centerX.centerY.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        self.transform = CGAffineTransform(translationX: 0, y: 200.adap)
        self.alpha = 0
        let translationAnimation = {
            self.transform = CGAffineTransform.identity
        }
        let alphaAnimation = {
            self.alpha = 1
        }
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 1, options: .curveEaseInOut, animations: translationAnimation)
        UIView.animate(withDuration: 0.4, animations: alphaAnimation)
        
        if isAutoDisappearing {
            DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                self.disappear()
            }
        }
    }
    
    func disappear(animated: Bool = true) {
        if animated {
            let animation = {
                self.alpha = 0
            }
            let completion: ((Bool) -> Void) = { _ in
                self.removeFromSuperview()
            }
            UIView.animate(withDuration: 0.15, animations: animation, completion: completion)
        } else {
            removeFromSuperview()
        }
    }
    
    /// 向上消失
    func upwardDisappearing() {
        let animation = {
            self.transform = CGAffineTransform(translationX: 0, y: -30.adap)
            self.alpha = 0
        }
        let completion: ((Bool) -> Void) = { _ in
            self.removeFromSuperview()
        }
        UIView.animate(withDuration: 0.15, animations: animation, completion: completion)
    }
}


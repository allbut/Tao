//
//  LoadingView.swift
//  Gloden Palace Casino
//
//  Created by albutt on 2018/12/13.
//  Copyright © 2018 海创中盈. All rights reserved.
//

import UIKit

class Loading {
    static var `default` = LoadingView()
    
    static func start(in view: UIView? = UIApplication.shared.keyWindow, message: String? = nil) {
        guard let view = view else { return }
        if `default`.superview != nil {
            `default`.removeFromSuperview()
        }
        let msg = message ?? String(localizable: "loading_messgae")
        `default`.message(msg: msg).start(in: view)
    }
    
    static func end() {
        guard `default`.superview != nil else { return }
        `default`.end()
    }
}


/// 加载视图
class LoadingView: UIView {
    
    enum `Type` {
        case notMandatory   // 不强制
        case mandatory      // 强制显示
    }
    
    var type: Type = .notMandatory
    var circleImageView: UIImageView!
    var flowerImageView: UIImageView!
    var contentLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor(hexValue: 0x000000, alpha: 0.8)
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initialize() {
        circleImageView = UIImageView(image: UIImage(named: "loading_circle"))
        addSubview(circleImageView)
        
        flowerImageView = UIImageView(image: UIImage(named: "loading_flower"))
        addSubview(flowerImageView)
        
        contentLabel = UILabel()
        contentLabel.font = UIFont.boldSystemFont(ofSize: 18.adap)
        contentLabel.textColor = UIColor(hexValue: 0xE6D39E)
        contentLabel.textAlignment = .center
        addSubview(contentLabel)
        
        makeConstraints()
    }
    
    private func makeConstraints() {
        circleImageView.snp.makeConstraints { (maker) in
            maker.center.equalToSuperview()
            maker.height.width.equalTo(64.adap)
        }
        
        flowerImageView.snp.makeConstraints { (maker) in
            maker.center.equalToSuperview()
            maker.height.width.equalTo(30.adap)
        }
        
        contentLabel.snp.makeConstraints { (maker) in
            maker.centerX.equalToSuperview()
            maker.top.equalTo(circleImageView.snp.bottom).offset(10.adap)
        }
    }
    
    var clear: LoadingView {
        backgroundColor = .clear
        return self
    }
    
    func type(type: Type) -> LoadingView {
        self.type = type
        return self
    }
    
    func message(msg: String?) -> LoadingView {
        contentLabel.text = msg
        return self
    }
    
    func start(in view: UIView? = UIApplication.shared.keyWindow,
               frame: CGRect? = nil) {
        guard let view = view else { return }
        if let frame = frame {
            self.frame = frame
        } else {
            self.frame = view.bounds
        }
        view.addSubview(self)
        self.alpha = 0
        UIView.animate(withDuration: 0.2) {
            self.alpha = 1
        }
        circleImageView.layer.add(rotationZAnimation(), forKey: "rotationZ")
        flowerImageView.layer.add(rotationYAnimation(), forKey: "rotationY")
    }
    
    func end() {
        circleImageView.layer.removeAnimation(forKey: "rotationZ")
        flowerImageView.layer.removeAnimation(forKey: "rotationY")
        UIView.animate(withDuration: 0.2, animations: {
            self.alpha = 0
        }) { (_) in
            self.removeFromSuperview()
        }
    }
    
    private func rotationZAnimation() -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: "transform.rotation.z")
        animation.duration = 1.2
        animation.byValue = CGFloat.pi * 2
        animation.repeatCount = HUGE
        return animation
    }
    
    private func rotationYAnimation() -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: "transform.rotation.y")
        animation.duration = 1
        animation.byValue = CGFloat.pi
        animation.repeatCount = HUGE
        return animation
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        if type == .notMandatory {
            end()
        }
    }
}

//
//  PortraitGameLoadingView.swift
//  Gloden Palace Casino
//
//  Created by albutt on 2018/12/24.
//  Copyright © 2018 海创中盈. All rights reserved.
//

import UIKit

/// 竖屏游戏加载视图
class PortraitGameLoadingView: UIView, GameLoadingProtocol {
    
    private var backgroundImageView: UIImageView!
    private var backButton: UIButton!
    private var completeProgressImageView: UIImageView!
    private var currentProgressImageView: UIImageView!
    private var tipsLabel: UILabel!
    private var progressLabel: UILabel!
    private var progressHeadView: UIImageView!
    
    private var lastProgress: Double = 0
    
    var gameEn: GameEn? {
        set {
            _gameEn = newValue
            action(forSet: newValue)
        }
        get {
            return _gameEn
        }
    }
    
    
    private let progressWidth: CGFloat = 300.adap
    var progress: Double {
        set {
            _progress = newValue
            action(forSet: newValue)
        }
        get {
            return _progress
        }
    }
    
    var handleBack: (() -> Void)? {
        set {
            _handleBack = newValue
        }
        get {
            return _handleBack
        }
    }
    
    var tip: String {
        set {
            let text = String(localizable: "tips_game_prefix") + newValue
            tipsLabel.text = text
        }
        get {
            return tipsLabel.text ?? ""
        }
    }
    
    private var _gameEn: GameEn?
    private var _progress: Double = 0
    private var _handleBack: (() -> Void)?
    
   
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initialize()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 30) {
            self.backButton.isHidden = false
            if self.superview != nil {
                Toast.say(message: String(localizable: "tips_game_loading_timeout_prompt"))
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initialize() {
        
        backgroundImageView = UIImageView()
        backgroundImageView.contentMode = .scaleAspectFill
        addSubview(backgroundImageView)
        
        backButton = UIButton()
        backButton.setImage(UIImage(named: "loading_timeout_back"), for: .normal)
        backButton.addTarget(self, action: #selector(backButton(clicked:)), for: .touchUpInside)
        backButton.isHidden = true
        addSubview(backButton)
        
        completeProgressImageView = UIImageView()
        completeProgressImageView.contentMode = .scaleAspectFill
        completeProgressImageView.layer.cornerRadius = 6.adap
        completeProgressImageView.clipsToBounds = true
        addSubview(completeProgressImageView)
        
        currentProgressImageView = UIImageView()
        currentProgressImageView.contentMode = .scaleAspectFill
        currentProgressImageView.layer.cornerRadius = 6.adap
        currentProgressImageView.clipsToBounds = true
        completeProgressImageView.addSubview(currentProgressImageView)
        
        progressHeadView = UIImageView()
        addSubview(progressHeadView)
        
        progressLabel = UILabel()
        progressLabel.textColor = UIColor(hexValue: 0xF0D082)
        progressLabel.font = UIFont.systemFont(ofSize: 14)
        progressLabel.text = "0%"
        addSubview(progressLabel)
        
        tipsLabel = UILabel()
        tipsLabel.textColor = UIColor(hexValue: 0xF0D082)
        tipsLabel.numberOfLines = 2
        tipsLabel.textAlignment = .center
        tipsLabel.font = UIFont.systemFont(ofSize: 14)
        addSubview(tipsLabel)
        
        makeConstraints()
    }
    
    private func makeConstraints() {
        backgroundImageView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        
        backButton.snp.makeConstraints { (make) in
            make.left.equalTo(10.adap)
            make.top.equalTo(27.adap)
            make.width.height.equalTo(30.adap)
        }
        
        completeProgressImageView.snp.makeConstraints { (make) in
            make.bottom.equalTo(-120.adap)
            make.centerX.equalToSuperview().offset(-12.adap)
            make.width.equalTo(progressWidth)
            make.height.equalTo(12.adap)
        }
        
        currentProgressImageView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.height.equalTo(12.adap)
            make.left.equalToSuperview()
            make.width.equalTo(1)
        }
        
        progressLabel.snp.makeConstraints { (make) in
            make.left.equalTo(completeProgressImageView.snp.right).offset(5.adap)
            make.centerY.equalTo(completeProgressImageView)
        }
        
        progressHeadView.snp.makeConstraints { (make) in
            make.centerY.equalTo(completeProgressImageView)
            make.centerX.equalTo(completeProgressImageView.snp.left)
        }
        
        tipsLabel.snp.makeConstraints { (make) in
            make.left.right.equalTo(completeProgressImageView)
            make.top.equalTo(completeProgressImageView.snp.bottom).offset(20.adap)
        }
    }
    
    // 设置 Game En
    private func action(forSet gameEn: GameEn?) {
        guard let game = gameEn else { return }
        backgroundImageView.image = UIImage(named: game.backgroundImageName)
        completeProgressImageView.image = UIImage(named: game.completeProgressImageName)
        currentProgressImageView.image = UIImage(named: game.currentProgressImageName)
        progressHeadView.image = UIImage(named: game.progressHeaderImageName)
    }
    
    // 设置 progress
    private func action(forSet progress: Double) {
        let prgs = progress < 0 ? 0 : progress > 1 ? 1 : progress   // 不小于0,不大于1
        let width = CGFloat(prgs) * progressWidth
        
        let prgsString = String(Int(prgs * 100)) + "%"
        
        let time = 2 * (prgs - lastProgress)
        lastProgress = prgs
        
        currentProgressImageView.snp.updateConstraints { (make) in
            make.width.equalTo(width)
        }

        UIView.animate(withDuration: time, animations: {
            self.progressHeadView.transform = CGAffineTransform(translationX: width, y: 0)
            self.completeProgressImageView.layoutIfNeeded()
            self.progressLabel.text = prgsString
        }) { (_) in
            if progress == 1 {
                self.removeFromSuperview()
            }
        }
        
    }
    
    /// 返回按钮
    @objc
    private func backButton(clicked sender: UIButton) {
        _handleBack?()
    }

}

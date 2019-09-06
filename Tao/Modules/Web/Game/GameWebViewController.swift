//
//  GameWebViewController.swift
//  Gloden Palace Casino
//
//  Created by albutt on 2018/12/24.
//  Copyright © 2018 海创中盈. All rights reserved.
//

import UIKit
//import GCDWebServer

/// 游戏Web View Controller
class GameWebViewController: WebViewController {
    
    var packagePath: String?
    
    var tipsViewModel = GameTipsViewModel()
    
    lazy var loadingView: GameLoadingProtocol = {
        var view = loadingViewFactory()
        view.handleBack = { [weak self] in
            guard let `self` = self else { return }
            self.navigationController?.popViewController(animated: true)
        }
        return view
    }()
    
    init(gameEn: String) {
        super.init(nibName: nil, bundle: nil)
        self.gameEn = gameEn
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backButton.isHidden = true
        view.backgroundColor = .black
        isDisplayLoadingView = false
        
        if let urlStr = url,
            let url = URL(string: urlStr) {
            print("[PATH] Web URL: \(url.absoluteString)")
            let request = webRequest(url: url)
            webView.load(request)
        }
        initializeComponents()
        bindings()
        
        tipsViewModel.requestGameTips(gameEn: gameEn)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        // 屏幕常亮
        UIApplication.shared.isIdleTimerDisabled = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        
        // 关闭屏幕常亮
        UIApplication.shared.isIdleTimerDisabled = false
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        loadingFinish()
    }
    
    deinit {
        print("[MESSAGE]: Game Deinit")
    }

    private func initializeComponents() {
        /// Add loading view
        view.addSubview(self.loadingView as UIView)
        let loadingView = self.loadingView as UIView
        loadingView.snp.makeConstraints { (maker) in
            maker.edges.equalTo(UIEdgeInsets.zero)
        }
    }
    
    private func bindings() {
        tipsViewModel.handleTips = { [weak self] tips in
            guard let `self` = self else { return }
            guard tips.count > 0 else { return }
            let arcIndex = Int(arc4random() % uint(tips.count))
            let tip = tips[arcIndex]
            self.loadingView.tip = tip
        }
    }
}

// MARK: - 重写父类方法，获得一些游戏必要信息
extension GameWebViewController {
    override func webViewEstimatedProgressChange() {
        super.webViewEstimatedProgressChange()
        let progress = webView.estimatedProgress
        let maxProgress = Double(arc4random() % 6) / 100 + 0.9
        loadingView.progress = progress > maxProgress ? maxProgress : progress
    }
    
    override func webViewTitleChange() {
        super.webViewTitleChange()
    }
    
    override func gameDidFinish() {
        super.gameDidFinish()
        loadingFinish()
    }
    
    private func loadingFinish() {
        loadingView.progress = 1 
//        let loadingView = self.loadingView as! UIView
//        loadingView.removeFromSuperview()
    }
}

extension GameWebViewController {
    private func loadingViewFactory() -> GameLoadingProtocol {
        let gameEn = conversionGameEn(gameEn: self.gameEn)
        var view: GameLoadingProtocol
        switch gameEn {
        case .liu, .cdx, .portrait:
            view = PortraitGameLoadingView()
        case .bjl, .dlp, .lhd, .lucky777, .brn, .qzp, .landscape:
            view = LandscapeGameLoadingView()
        }
        view.gameEn = gameEn
        return view
    }
    
    private func conversionGameEn(gameEn: String) -> GameEn {
        var gameEn: GameEn
        if let game = GameEn(rawValue: self.gameEn) {
            gameEn = game
        } else {
            if interfaceOrientations == Application.defaultInterfaceOrientations {
                gameEn = .landscape
            } else {
                gameEn = .portrait
            }
        }
        return gameEn
    }
}

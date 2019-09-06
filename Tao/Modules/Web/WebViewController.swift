//
//  WebViewController.swift
//  Tao
//
//  Created by hc on 2019/8/30.
//  Copyright © 2019 hc. All rights reserved.
//

import UIKit
import WebKit
import SnapKit

/// 添加新name一定要注册
enum WKScriptMessageName: String {
    case tokenListen    //获取token
    case callLogin      //调取登录
    case syncToken      //H5同步登录
    case exitGame       //退出游戏
    case addNetWorkListener     //添加网络监听
    case cancelNetWordListener  //移除网络监听
    case recharge       //充值
    case gameDidFinish  //结束加载动画
    case getAppParams   //登录相关参数
    case soundListen    //获取音乐音效状态
    case syncSound      //同步音效
}

protocol WebViewControllerProtocol: NSObjectProtocol {
    func webView(view: WKWebView, estimatedProgressChange progress: Double) -> Void
    func webView(view: WKWebView, title: String?) -> Void
    func webViewExit(view: WKWebView) -> Void
}

class WebViewController: RootViewController {

    var name: String?
    
    var gameEn: String = ""
    
    var url: String?
    
    var webView: WKWebView!
    
    weak var delegate: WebViewControllerProtocol?
    
    var isShowBack: Bool = false    // 未使用
    
    /// 屏幕方向
    var interfaceOrientations: UIInterfaceOrientationMask = [.landscapeLeft, .landscapeRight, .portrait]
    
    /// 是否显示加载转圈视图
    var isDisplayLoadingView: Bool = true
    private let loadingView = LoadingView()
    
    /// 是否加载完成
    var isLoadingFinish: Bool = false
    
    /// 返回按钮
    var backButton: UIButton!
    
//    var gameSupervisor: GameSupervisor?
    
    private var screenCount = 0
    
    override func loadView() {
        
        let config = WKWebViewConfiguration()
        config.preferences.javaScriptEnabled = true
        config.allowsInlineMediaPlayback = true
        config.mediaTypesRequiringUserActionForPlayback = []
        config.preferences.javaScriptCanOpenWindowsAutomatically = true
        config.suppressesIncrementalRendering = true
        
        webView = WKWebView(frame: .zero, configuration: config)
        webView.navigationDelegate = self
        webView.backgroundColor = .black
        webView.uiDelegate = self
        webView.isOpaque = false
        webView.scrollView.bounces = false
        
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        _initialize()
        
        addWebViewObserver()
        addLoggedNotification()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        addAllScriptMessageName()
        
        /// 如果无父视图(navigation除外)允许三方选旋转
        if self.parent == nil || self.parent!.isKind(of: UINavigationController.self) {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.interfaceOrientations = interfaceOrientations
            /// 关闭音乐
//            Application.isForcedTurnOffBGM = true
            /// 竖屏使侧滑手势不可用
            if interfaceOrientations == .portrait {
                navigationController?.interactivePopGestureRecognizer?.isEnabled = false
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeAllScriptMessageName()
        
        willDisappear()
        
        /// 如果无父视图(navigation除外)返回时旋转回默认状态
        if self.parent == nil || self.parent!.isKind(of: UINavigationController.self) {
//            let appDelegate = UIApplication.shared.delegate as! AppDelegate
//            appDelegate.interfaceOrientations = Application.defaultInterfaceOrientations
//            navigationController?.interactivePopGestureRecognizer?.isEnabled = true
//            Application.isForcedTurnOffBGM = false
        }
    }
    
    deinit {
//        NetMonitor.shared.stopNotifier()
        removeWebViewObserver()
        removeLoggedNotification()
    }
    
    private func _initialize() {
        
        backButton = UIButton()
        backButton.setImage(UIImage(named: "web_back"), for: .normal)
        backButton.addTarget(self, action: #selector(backAction(sender:)), for: .touchUpInside)
        backButton.isHidden = !isShowBack
        view.addSubview(backButton)
        
        backButton.snp.makeConstraints { (maker) in
            if #available(iOS 11.0, *) {
                maker.left.equalTo(self.view.safeAreaLayoutGuide.snp.left).offset(8.adap)
                maker.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(9.adap)
            } else {
                // Fallback on earlier versions
                maker.left.equalTo(8.adap)
                maker.top.equalTo(8.adap)
            }
            maker.width.height.equalTo(35.adap)
        }
    }
    
    func willAppear() {
        guard var name = name else { return }
        screenCount += 1
        if !gameEn.isEmpty { name = name + "_" + gameEn  }
//        Analyst.shared.screenStart(name: name)
    }
    
    func willDisappear() {
        guard var name = name, screenCount > 0 else { return }
        screenCount -= 1
        if !gameEn.isEmpty { name = name + "_" + gameEn  }
//        Analyst.shared.screenEnd(name: name)
    }
    
    /// 隐藏状态栏
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    /// 返回
    @objc
    private func backAction(sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }

}

// MARK: - Private Method
extension WebViewController {
    private func addAllScriptMessageName() {
        for e in WKScriptMessageName.allValues {
            let name = e.rawValue
            webView.configuration.userContentController.add(self, name: name)
        }
    }
    
    private func removeAllScriptMessageName() {
        for e in WKScriptMessageName.allValues {
            let name = e.rawValue
            webView.configuration.userContentController.removeScriptMessageHandler(forName: name)
        }
    }
}

private let progressKeyPath = "estimatedProgress"
private let titleKeyPath = "title"

extension WebViewController {
    private func addWebViewObserver() {
        webView.addObserver(self, forKeyPath: progressKeyPath, options: .new, context: nil)
        webView.addObserver(self, forKeyPath: titleKeyPath, options: .new, context: nil)
    }
    
    private func removeWebViewObserver() {
        if webView != nil {
            webView.removeObserver(self, forKeyPath: progressKeyPath)
            webView.removeObserver(self, forKeyPath: titleKeyPath)
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == progressKeyPath {
            webViewEstimatedProgressChange()
        }
        if keyPath == titleKeyPath {
            webViewTitleChange()
        }
    }
}

// MARK: - Public Method (部分方法是给子类重写的)
extension WebViewController {
    
    /// Web View 加载进度改变
    @objc
    func webViewEstimatedProgressChange() {
        delegate?.webView(view: webView, estimatedProgressChange: webView.estimatedProgress)
    }
    
    /// Web View title改变
    @objc
    func webViewTitleChange() {
        delegate?.webView(view: webView, title: webView.title)
    }
    
    /// 游戏加载完成
    @objc
    func gameDidFinish() {
        
    }
}


// MARK: - WKNavigationDelegate
extension WebViewController: WKNavigationDelegate {
    
    // 1）接受网页信息，决定是否加载还是取消。必须执行肥调 decisionHandler 。逃逸闭包的属性
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        if let urlString = navigationAction.request.url?.absoluteString {
            print("[MESSAGE]: Decide Policy: \(urlString)")
            if urlString.hasPrefix("casino://") {
//                Router.shared.open(url: urlString)
                decisionHandler(.cancel)
                return
            }
        }
        decisionHandler(.allow)
    }
    // 2) 开始加载
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("[MESSAGE]: \(#function)")
        if isDisplayLoadingView {
//            loadingView.clear.start()
        }
    }
    
    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        print("[MESSAGE]: \(#function)")
    }
    
    // 3) 接受到网页 response 后, 可以根据 statusCode 决定是否 继续加载。allow or cancel, 必须执行肥调 decisionHandler 。逃逸闭包的属性
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        decisionHandler(.allow)
    }
    // 4) 网页加载成功
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("[MESSAGE]: \(#function)")
        loadingView.end()
        isLoadingFinish = true
    }
    // 4) 加载失败
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print("[MESSAGE]: \(#function)")
        loadingView.end()
    }
    //
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        let targetFrame = navigationAction.targetFrame
        if targetFrame == nil || !(targetFrame?.isMainFrame ?? false) {
            webView.load(navigationAction.request)
        }
        return nil
    }
    
}

// MARK: - WKUIDelegate
extension WebViewController: WKUIDelegate {
    // Alert
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        let alertAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction(alertAction)
        present(alert, animated: true, completion: nil)
        completionHandler()
    }
    // Confirm
    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        completionHandler(true)
    }
    // Prompt
    func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Void) {
        completionHandler(prompt)
    }
    
}

extension WebViewController {
    
}

// MARK: - WKScriptMessageHandler
extension WebViewController: WKScriptMessageHandler {
    // 接收到js消息
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        // 未定义的消息直接跳出
        guard let name = WKScriptMessageName(rawValue: message.name) else { return }
        // 调用js方法完成后回调
        let completionHandler: ((Any?, Error?) -> Void) = { (data, error) in
            print("[ERROR] Evaluate Java Script Error: \(error?.localizedDescription ?? "unknow")")
        }
        
        print("[MESSAGE] Java Script Message Name: \(name)")
        
        switch name {
        case .tokenListen:
            webView.evaluateJavaScript(name.action(param: BackendAuth.shared.token ?? ""), completionHandler: completionHandler)
        case .callLogin:
//            for subv in self.view.subviews {
//                if subv is LogInBoxView {
//                    return
//                }
//            }
//            Analyst.shared.select(name: "btn_gameLogin", parameter: ["gameEn": gameEn])
//            let loginBoxView = LogInBoxView()
//            loginBoxView.display(in: self.view)
            break
        case .syncToken:
            break
        case .exitGame:
            delegate?.webViewExit(view: webView)
            navigationController?.popViewController(animated: true)
        case .addNetWorkListener:
//            do {
//                try NetMonitor.shared.startNotifier()
//                NetMonitor.shared.whenChanged = { [weak self] status in
//                    guard let `self` = self else { return }
//                    switch status {
//                    case .WWAN, .WiFi:
//                        self.webView.evaluateJavaScript(name.action(param: "connect"), completionHandler: completionHandler)
//                    case .notReachable:
//                        self.webView.evaluateJavaScript(name.action(param: "disconnect"), completionHandler: completionHandler)
//                    }
//                }
//            } catch {
//                print("[ERROR] Net Monitor Start Notifier Failed")
//            }
            break
        case .cancelNetWordListener:
//            NetMonitor.shared.stopNotifier()
            break
        case .recharge:
//            let rechargeViewController = RechargeBoxViewController()
//            rechargeViewController.gameEn = gameEn
//            rechargeViewController.exit = { [weak self] in
//                self?.navigationController?.popViewController(animated: true)
//            }
//            rechargeViewController.becomePresent()
            break
        case .gameDidFinish:
            gameDidFinish()
        case .getAppParams:
            break
        case .soundListen:
//            let musicOn = Application.shared.info.isTurnOnBGM
//            let soundOn = Application.shared.info.isTurnOnSoundEffect
//            self.webView.evaluateJavaScript(name.action(param: "\(soundOn),\(musicOn)"), completionHandler: completionHandler)
            break
        case .syncSound:
//            if let body = message.body as? String {
//                let param = body.components(separatedBy: ",")
//                guard param.count > 1 else { return }
//                let isSoundOn = param[0] == "1"
//                let isBGMOn = param[1] == "1"
//                Application.shared.setSoundEffect(is: isSoundOn)
//                Application.shared.setBMG(is: isBGMOn)
//            }
            break
        }
        
    }
}


// MARK: - WebViewControllerProtocol 默认实现，使该协议部分方法可选实现
extension WebViewControllerProtocol {
    func webView(view: WKWebView, estimatedProgressChange progress: Double) {
        
    }
    func webView(view: WKWebView, title: String?) {
        
    }
    
    func webViewExit(view: WKWebView) {
        
    }
}

// MARK: - Notification
extension WebViewController {
    /// 添加登录成功监听
    private func addLoggedNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(logged(notification:)), name: Notification.Name.logged, object: nil)
    }
    /// 移除登录成功监听
    private func removeLoggedNotification() {
        NotificationCenter.default.removeObserver(self, name: Notification.Name.logged, object: nil)
    }
    
    /// 登录成功监听
    @objc
    private func logged(notification: Notification) {
        if let token = BackendAuth.shared.token {
            // 调用js方法完成后回调
            let completionHandler: ((Any?, Error?) -> Void) = { (data, error) in
                print("[ERROR] Evaluate Java Script Error: \(error?.localizedDescription ?? "unknow")")
            }
            webView.evaluateJavaScript(WKScriptMessageName.tokenListen.action(param: token), completionHandler: completionHandler)
        }
    }
}

// MARK: - WkScriptMseeageName Extension Action Method
extension WKScriptMessageName {
    func action(param: String = "") -> String {
        switch self {
        case .tokenListen:
            return "tokenListen('\(param)')"
        case .callLogin:
            return "tokenListen('\(param)')"
        case .recharge:
            return "rechargeResult()"
        case .addNetWorkListener:
            return "getNetWorkStatus('\(param)')"
        case .gameDidFinish:
            return "playMusic()"
        case .soundListen:
            return "soundListen(\(param))"
        case .syncSound:
            return "syncSound(\(param))"
        default:
            return ""
        }
    }
}

// MARK: - WkScriptMseeageName All Values
extension WKScriptMessageName {
    static var allValues: [WKScriptMessageName] {
        return [.tokenListen,
                .callLogin,
                .syncToken,
                .exitGame,
                .addNetWorkListener,
                .cancelNetWordListener,
                .recharge,
                .gameDidFinish,
                .getAppParams,
                .soundListen,
                .syncSound]
    }
}


extension WebViewController {
    func webRequest(url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        request.addValue(String(Application.versionCode), forHTTPHeaderField: "versionCode")
        request.addValue(Languager.shared.language == .chinese ? "zh" : "en", forHTTPHeaderField: "language")
        request.addValue(BackendAuth.shared.token ?? "", forHTTPHeaderField: "token")
        if let lng = LocationItem.shared.longitude,
            let lat = LocationItem.shared.latitude {
            request.addValue("\(lng),\(lat)", forHTTPHeaderField: "location")
        }
        return request
    }
}

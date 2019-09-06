//
//  ObjectOperation.swift
//  Quizzes
//
//  Created by user on 2018/10/29.
//  Copyright © 2018 albutt. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

internal enum BackendError: Error {
    case failure
    case emptyResponse
    case tokenExpired
}

let tokenExpiredCode = 90000006
let notAccessibleCode = 477

/// 勿直接使用
class BaseOperation<R: BackendAPIRequest, O: Codable>: ServiceOperation {
    
    /// 是否显示加载视图
    var isShowLoading: Bool = true
    /// 是都当成功时Toast
    var isToastWhenSuccess: Bool = false
    /// 是否当失败时Toast
    var isToastWhenFailure: Bool = true
    /// 是否当网络异常时Toast
    var isPromptWhenException: Bool = true
    /// 是否当token失效时去登录
    var isLogInWhenTokenExpires: Bool = true
    /// 是否加入异常队列
    var isJoinTheExceptionQueue: Bool = true
    /// 是否加入不可访问队列
    private let isJoinNotAccessibleQueue: Bool = true
    
    let request: R

    init(request: R) {
        self.request = request
        super.init()
    }

    override func start() {
        super.start()
        if isShowLoading {
            DispatchQueue.main.async {        
                Loading.start()
            }
        }
        
        let success: ((Any?) -> Void) = { [weak self] (response) in
            self?._handleSuccess(response)
        }
        let failure: ((NSError, Int?) -> Void) = { [weak self] (error, code) in
            self?._handleFailure(error: error, statusCode: code)
        }
        
        service.request(request: request, success: success, failure: failure)
    }

    //MARK: - Private Method
    
    private func _handleSuccess(_ response: Any?) {
        /// 移除不可访问
        handleAccessible()
        
        handleNormal()
        
        guard let response = response as? Data else { return }
        let dncoder = JSONDecoder()
        do {
            let item = try dncoder.decode(ResponseItem<O>.self, from: response)
            if item.code == 0 {
                handleSuccess(item: item)
                finish()
            } else {
                handleFailure(code: item.code, msg: item.msg, error: BackendError.failure)
                if item.code == tokenExpiredCode {   /// Token失效
                    _handleTokenExpired()
                } else {
                    finish()
                }
            }
        } catch {
            /// 处理resp类型为字符串时的错误
            if let dictionary = (try? JSONSerialization.jsonObject(with: response, options: .allowFragments)) as? [String: Any] {
                let code = dictionary["code"] as? Int
                let msg = dictionary["msg"] as? String
                
                handleFailure(code: code, msg: msg, error: BackendError.failure)
                if code == tokenExpiredCode {  /// Token失效
                    _handleTokenExpired()
                } else {
                    finish()
                }

            } else {
                Toast.say(message: "数据解析失败，请联系客服")
                print("[ERROR]: \(#function) Decode Error")
                handleFailure(code: nil,
                              msg: ResponseMapperError.missingAttribute.localizedDescription,
                              error: ResponseMapperError.missingAttribute)
                finish()
            }
        }
    }

    private func _handleFailure(error: NSError, statusCode: Int?) {
        if statusCode == notAccessibleCode {
            handleNotAccessible()
        } else {
            /// 处理可访问状态
            handleAccessible()
            handleException(error: error)
            if !isPromptWhenException { finish() }
        }
    }
    
    private func _handleTokenExpired() {
        signOut()
        if isLogInWhenTokenExpires {
            showLogInBoxView()
        } else {
            finish()
        }
    }

    /// 处理请求成功
    func handleSuccess(item: ResponseItem<O>) {
        if isShowLoading { Loading.end() }
        if isToastWhenSuccess { Toast.say(message: item.msg) }
    }
    
    /// 处理请求失败
    func handleFailure(code: Int?, msg: String?, error: Error?) {
        if isShowLoading { Loading.end() }
        if isToastWhenFailure { Toast.say(message: msg) }
    }
    
    /// 处理不允许访问
    func handleNotAccessible() {
        if isJoinNotAccessibleQueue {
            NetworkNotAccessibleManager.default.add(operation: self, for: self.request.endPoint)
        }
        promptNotAccessible()
    }
    
    /// 处理允许访问
    func handleAccessible() {
        if isJoinNotAccessibleQueue {
            NetworkNotAccessibleManager.default.remove(for: self.request.endPoint)
            for (key, ops) in NetworkNotAccessibleManager.default.operationMap {
                ops.start()
                NetworkNotAccessibleManager.default.operationMap.removeValue(forKey: key)
            }
        }
        removeNotAccessible()
    }
    
    /// 处理网络异常
    func handleException(error: NSError) {
        if isShowLoading { Loading.end() }
        if isPromptWhenException {
            promptException()
        }
    }
    
    func handleNormal() {
        if isJoinTheExceptionQueue {
            NetworkExceptionManager.default.remove(for: self.request.endPoint)
        }
    }
    
    //MARK: - Private Method
    
    /// 提示不允许访问
    func promptNotAccessible() {
        
//        guard let topView = Router.topMost?.view else { return }
//        for subv in topView.subviews {
//            if subv.isKind(of: NotAccessibleBoxView.self) {
//                return
//            }
//        }
//        let view = NotAccessibleBoxView()
//        view.display(in: Router.topMost?.view)
    }
    
    /// 移除不允许访问
    func removeNotAccessible() {
        
//        guard let topView = Router.topMost?.view else { return }
//        for subv in topView.subviews {
//            if let subv = subv as? NotAccessibleBoxView {
//                subv.exit()
//            }
//        }
    }
    
    /// 提示网络异常
    private func promptException() {
//        let back: (() -> Void) = { [weak self] in
//            guard let `self` = self else { return }
//            if self.isJoinTheExceptionQueue {
//                NetworkExceptionManager.default.removeAll()
//            }
//            /// 返回
//            if let viewController = Router.topMost {
//                if let navigationViewControler = viewController.navigationController {
//                    navigationViewControler.popViewController(animated: true)
//                } else {
//                    viewController.dismiss(animated: true, completion: nil)
//                }
//            }
//            self.finish()
//        }
//        let reload = {
//            if self.isJoinTheExceptionQueue {
//                for (_, ops) in NetworkExceptionManager.default.operationMap {
//                    ops.start()
//                }
//            }
//        }
        
        if self.isJoinTheExceptionQueue {
            NetworkExceptionManager.default.add(operation: self, for: self.request.endPoint)
        }
        
//        guard let superView = Router.topMost?.view else { return }
//        for subv in superView.subviews {
//            if subv.isKind(of: NetworkAnomalyBoxView.self) {
//                return
//            }
//        }
//        let view = NetworkAnomalyBoxView()
//        view.handleBack = back
//        view.handleReload = reload
//        if let topViewController = Router.topMost,
//            topViewController.isKind(of: HomeViewController.self) {
//            view.isMandatory = true
//        }
//        view.display(in: superView)
    }
    
    /// 展示登录弹框
    private func showLogInBoxView() {
//        guard let topView = Router.topMost?.view else { return }
//        for subv in topView.subviews {
//            if subv.isKind(of: LogInBoxView.self) {
//                return
//            }
//        }
//        let hanldeLogInSuccess: ((String) -> Void) = { [weak self] token in
//            guard let `self` = self else { return }
//            self.start()
//        }
//        let view = LogInBoxView()
//        view.handleSuccess = hanldeLogInSuccess
//        view.display(in: Router.topMost?.view)
    }
}

/// 网络错误管理器
class NetworkExceptionManager {
    static let `default` = NetworkExceptionManager()
    var operationMap: [String: ServiceOperation] = [:]
    
    func add(operation: ServiceOperation, for key: String) {
        operationMap[key] = operation
    }
    
    func remove(for key: String) {
        operationMap.removeValue(forKey: key)
    }
    
    func removeAll() {
        operationMap.removeAll()
    }
}

class NetworkNotAccessibleManager {
    static let `default` = NetworkNotAccessibleManager()
    var operationMap: [String: ServiceOperation] = [:]
    
    func add(operation: ServiceOperation, for key: String) {
        operationMap[key] = operation
    }
    
    func remove(for key: String) {
        operationMap.removeValue(forKey: key)
    }
    
    func removeAll() {
        operationMap.removeAll()
    }
}

extension Reactive where Base: BaseOperation {
    
}

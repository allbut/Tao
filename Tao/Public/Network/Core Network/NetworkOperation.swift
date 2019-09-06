//
//  NetworkOperation.swift
//  toytt
//
//  Created by user on 2018/7/23.
//  Copyright © 2018年 grayworm. All rights reserved.
//

import Foundation

class NetwortOperation: Operation {
    private var _isReady = true
    override var isReady: Bool {
        get { return _isReady }
        set { update(change: { _isReady = newValue }, key: "isReady") }
    }
    
    private var _isExecuting = false
    override var isExecuting: Bool {
        get { return _isExecuting }
        set { update(change: { _isExecuting = newValue}, key: "isExecuting") }
    }
    
    private var _isFinished = false
    override var isFinished: Bool {
        get { return _isFinished }
        set { update(change: { _isFinished = newValue }, key: "isFinished") }
    }
    
    private var _isCancelled = false
    override var isCancelled: Bool {
        get { return _isCancelled }
        set { update(change: { _isCancelled = newValue }, key: "isCancelled") }
    }
    
    private func update(change: () -> Void, key: String) {
        willChangeValue(forKey: key)
        change()
        didChangeValue(forKey: key)
    }
    
    override var isAsynchronous: Bool {
        return true
    }
    
    override func start() {
        if isExecuting == false {
            isReady = false
            isExecuting = true
            isFinished = false
            isCancelled = false
        }
    }
    
    /// 只用于子类调用，外部调用应用'Cancel'
    func finish() {
        isExecuting = false
        isFinished = true
    }
    
    override func cancel() {
        isExecuting = false
        isCancelled = true
    }
}

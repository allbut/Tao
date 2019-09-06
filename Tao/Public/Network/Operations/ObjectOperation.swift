//
//  ObjectOperation.swift
//  Gloden Palace Casino
//
//  Created by albutt on 2018/12/26.
//  Copyright © 2018 海创中盈. All rights reserved.
//

import Foundation

/// 对象类型
class ObjectOperation<R: BackendAPIRequest, O: Codable>: BaseOperation<R, O> {
    
    var success: ((O) -> Void)?
    var failure: ((Int?, String?, Error?) -> Void)?
    var exception: ((NSError) -> Void)?
    
    override func handleSuccess(item: ResponseItem<O>) {
        super.handleSuccess(item: item)
        if let resp = item.resp {
            success?(resp)
        } else {
            failure?(item.code, item.msg, BackendError.emptyResponse)
        }
    }
    
    override func handleFailure(code: Int?, msg: String?, error: Error?) {
        super.handleFailure(code: code, msg: msg, error: error)
        failure?(code, msg, error)
    }
    
    override func handleException(error: NSError) {
        super.handleException(error: error)
        exception?(error)
    }
}

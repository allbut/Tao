//
//  ArrayOperation.swift
//  Quizzes
//
//  Created by user on 2018/10/29.
//  Copyright © 2018 albutt. All rights reserved.
//

import Foundation
/// 数组类型
class ArrayOperation<R: BackendAPIRequest, O: Codable>: BaseOperation<R, [O]> {
    
    var success: (([O]) -> Void)?
    var failure: ((Int?, String?, Error?) -> Void)?
    var exception: ((NSError) -> Void)?
    
    override func handleSuccess(item: ResponseItem<[O]>) {
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

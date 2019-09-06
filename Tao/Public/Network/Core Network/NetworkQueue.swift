//
//  NetworkQueue.swift
//  toytt
//
//  Created by user on 2018/7/23.
//  Copyright © 2018年 allbut. All rights reserved.
//

import Foundation

class NetworkQueue {
    static var shared: NetworkQueue!
    
    let queue = OperationQueue()
    
    init() {}
    
    func addOperation(operation: Operation) {
        queue.addOperation(operation)
    }
}

//
//  ServiceOperation.swift
//  toytt
//
//  Created by user on 2018/7/23.
//  Copyright © 2018年 allbut. All rights reserved.
//

import Foundation

class ServiceOperation: NetwortOperation {
    
    let service: BackendService
    
    override init() {
        self.service = BackendService(config: BackendConfiguration.shared)
        super.init()
    }
    
    override func cancel() {
        service.cancel()
        super.cancel()
    }
}

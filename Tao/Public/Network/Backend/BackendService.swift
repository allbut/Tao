//
//  BackendService.swift
//  toytt
//
//  Created by user on 2018/7/23.
//  Copyright © 2018年 grayworm. All rights reserved.
//

import UIKit

class BackendService {
    private let config: BackendConfiguration
    private let service: NetworkService
    
    init(config: BackendConfiguration) {
        self.config = config
        self.service = NetworkService()
    }

    func request<R: BackendAPIRequest>(request: R,
                                       success: ((Any?) -> Void)? = nil,
                                       failure: ((NSError, Int?) -> Void)? = nil) {
        let url = config.baseURL.appendingPathComponent(request.endPoint)
        
        var headers = request.headers
        /// authentication token
        headers?["token"] = BackendAuth.shared.token
        
        let parameters = request.parameters
        
        #if DEBUG
        print("[NET] Request .·ˇ .·ˇ .·ˇ")
        print("[NET] Method: \(request.method)")
        print("[NET] End Point: \(request.endPoint)")
        if let parameters = parameters {
            print("[NET] Parameters: \(parameters.description)")
        }
        #endif

        service.request(url: url,
                        method: request.method,
                        query: request.query,
                        parameters: parameters,
                        headers: headers,
                        success: { (data) in
                            #if DEBUG
                            if let data = data {
                                if let dataStr = String(data: data, encoding: .utf8) {
                                    let pstr = dataStr.replacingOccurrences(of: "\\", with: "")
                                    print("[NET] Response: \(pstr)")
                                }
                            }
                            #endif
                            DispatchQueue.main.async {
                                success?(data)
                            }
                        }) { (data, error, statusCode) in
                            if let data = data {
                                if let errorData = try? JSONSerialization.jsonObject(with: data, options: []) as? Dictionary<String, Any> {
                                    print("[ERROR] Failure Message: \(errorData["msg"] ?? "No Message").")
                                }
                            }
                            if let error = error {
                                DispatchQueue.main.async {
                                    failure?(error, statusCode)
                                }
                            }
                        }
    }
    
    func cancel() {
        service.cancel()
    }
}

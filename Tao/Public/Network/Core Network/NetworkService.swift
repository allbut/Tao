//
//  NetworkService.swift
//  toytt
//
//  Created by user on 2018/7/23.
//  Copyright © 2018年 grayworm. All rights reserved.
//

import UIKit

/// HTTP 请求
class NetworkService {
    
    private var task: URLSessionDataTask?
    private var successCode: Range<Int> = 0..<299
    private var failureCode: Range<Int> = 400..<499
    
    enum Method: String {
        case GET, POST, PUT, DELETE
    }
    
    enum QueryType {
        case json, path
    }
    
    func request(url: URL,
                 method: Method,
                 query type: QueryType,
                 parameters: [String: Any]? = nil,
                 headers: [String: String]? = nil,
                 success: ((Data?) -> Void)? = nil,
                 failure: ((Data?, NSError?, Int?) -> Void)? = nil) {
        
        var request = makeQuery(for: url, params: parameters, type: type)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = headers
        request.timeoutInterval = 10
        
        let session = URLSession.shared
        task = session.dataTask(with: request, completionHandler: { (data, response, error) in
            
            guard let response = response as? HTTPURLResponse else {
                failure?(data, error as NSError?, 0)
                print("[ERROR]: Non-http response.")
                return
            }
            
            if let error = error {
                failure?(data, error as NSError?, response.statusCode)
                print("[ERROR] Request failure. Response status code \(response.statusCode).")
                return
            }

            if self.successCode.contains(response.statusCode) {
                print("[SUCCESS] Request finished with success. Response status code \(response.statusCode).")
                success?(data)
            }
            else {
                let info = [
                    NSLocalizedDescriptionKey: "Request failed with code \(response.statusCode)",
                    NSLocalizedFailureReasonErrorKey: "Wrong handling logic, wrong endpoing mapping or backend bug."
                ]
                let error = NSError(domain: "NetworkService", code: response.statusCode, userInfo: info)
                failure?(data, error, response.statusCode)
                print("[ERROR] Request failed with code \(response.statusCode).")
            }
        })
        task?.resume()
    }
    
    func cancel() {
        task?.cancel()
    }
    
    //MARK: Private
    private func makeQuery(for url: URL, params: [String: Any]?, type: QueryType) -> URLRequest {
        switch type {
        case .json:
            var mutableRequest = URLRequest(url: url,
                                            cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
                                            timeoutInterval: 10.0)
            var query = ""
            
            params?.forEach { key, value in
                query = query + "\(key)=\(value)&"
            }
            mutableRequest.httpBody = query.data(using: .utf8)
            
            return mutableRequest
        case .path:
            var query = ""
            
            params?.forEach { key, value in
                query = query + "\(key)=\(value)&"
            }
            
            var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
            components.query = query
            
            return URLRequest(url: components.url!, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 10.0)
        }
        
    }
}

//
//  Server.swift
//  Gold Palace
//
//  Created by hc on 2019/5/13.
//  Copyright © 2019 海创中盈. All rights reserved.
//

import Foundation
//import GCDWebServer

/// 本地服务器
//class Server {
//
//    static var `default`: Server!
//    private var webServer: GCDWebServer
//
//    var isRunning: Bool {
//        return webServer.isRunning
//    }
//
//    init(directoryPath: String) {
//        webServer = GCDWebServer()
//        webServer.addGETHandler(forBasePath: "/", directoryPath: directoryPath, indexFilename: nil, cacheAge: 3600, allowRangeRequests: true)
//    }
//
//    func start(with port: UInt, bonjourName: String) {
//        webServer.start(withPort: port, bonjourName: bonjourName)
//    }
//
//    func stop() {
//        webServer.stop()
//    }
//}

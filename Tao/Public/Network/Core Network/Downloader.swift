//
//  Downloader.swift
//  Gloden Palace Casino
//
//  Created by albutt on 2019/2/19.
//  Copyright © 2019 海创中盈. All rights reserved.
//

import Foundation

class Downloader: NSObject, URLSessionDownloadDelegate {
    
    var progress: ((Int64, Int64, Float) -> Void)?
    var success: ((String) -> Void)?
    var failure: ((Error?) -> Void)?
    
    
    private var task: URLSessionDownloadTask?
    private lazy var session: URLSession = {
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config, delegate: self, delegateQueue: OperationQueue())
        return session
    }()
    
    // 文件下载完成后存储的路径
    private var path: String?
    
    func download(url: URL, path: String?) {
        self.path = path
        let request = URLRequest(url: url)
        self.task = self.session.downloadTask(with: request)
        self.task?.resume()
    }
    
    // MARK: - URLSessionDelegate
    
    // 下载偏移
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didResumeAtOffset fileOffset: Int64, expectedTotalBytes: Int64) {
        
    }
    
    // 下载中
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        //获取进度
        let written = Float(totalBytesWritten)
        let total = Float(totalBytesExpectedToWrite)
        let rate = written/total
        print("[PROGRESS] Download: \(rate)")
        DispatchQueue.main.async {
            self.progress?(totalBytesWritten, totalBytesExpectedToWrite, rate)
        }
    }
    
    // 下载完成
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        print("[MESSAGE] Download Complete")
        
        guard let toPath = path else {
            DispatchQueue.main.async {
                self.success?(location.path)
            }
            print("[PATH] Download: \(location.path)")
            return
        }
        
        do {
            let fileManager = FileManager.default
            try fileManager.moveItem(atPath: location.path, toPath: toPath)
            DispatchQueue.main.async {
                self.success?(toPath)
            }
            print("[PATH] Download: \(toPath)")
        } catch {
            print("[ERROR]: Move Item Error")
        }
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        DispatchQueue.main.async {
            if let error = error {
                self.failure?(error)
            }
        }
        
    }
}

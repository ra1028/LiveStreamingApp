//
//  URLSessionExtension.swift
//  LiveStreamingApp
//
//  Created by Ryo Aoyama on 3/7/17.
//  Copyright © 2017 Ryo Aoyama. All rights reserved.
//

import Foundation
import ReactiveSwift
import Result

private enum HeaderFieldKey: String {
    case ifModifiedSince = "If-Modified-Since"
    case lastModified = "Last-Modified"
    case ifNoneMatch = "If-None-Match"
    case eTag = "Etag"
}

extension Reactive where Base: URLSession {
    func continuousMonitorFile(url: URL, interval: TimeInterval) -> SignalProducer<Data, NoError> {
        let successCodeRange = 200..<300
        
        var lastModified: String = ""
        var lastETag: String = ""
        
        func startRequest() -> SignalProducer<Data, NoError> {
            return .init { [weak base] observer, disposable in
                guard let base = base else { return }
                
                var request = URLRequest(url: url)
                request.setValue(lastModified, forHTTPHeaderField: HeaderFieldKey.ifModifiedSince.rawValue)
                request.setValue(lastETag, forHTTPHeaderField: HeaderFieldKey.ifNoneMatch.rawValue)
                
                let task = base.downloadTask(with: request) { url, response, error in
                    guard let url = url,
                        let data = try? Data(contentsOf: url),
                        let response = response as? HTTPURLResponse,
                        successCodeRange ~= response.statusCode,
                        error == nil else { return }
                    
                    if let modified = response.allHeaderFields[HeaderFieldKey.lastModified.rawValue] as? String {
                        lastModified = modified
                    }
                    
                    if let etag = response.allHeaderFields[HeaderFieldKey.eTag.rawValue] as? String {
                        lastETag = etag
                    }
                    
                    observer.send(value: data)
                }
                task.resume()
                disposable.add(task.cancel)
            }
        }
        
        let scheduler = QueueScheduler(qos: .default)
        let dispatchTimeInterval = DispatchTimeInterval.milliseconds(Int(interval * 1000))
        
        return timer(interval: dispatchTimeInterval, on: scheduler).map { _ in }.flatMap(.latest, transform: startRequest)
    }
}

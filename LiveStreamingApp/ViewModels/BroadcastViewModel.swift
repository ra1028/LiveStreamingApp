//
//  BroadcastViewModel.swift
//  LiveStreamingApp
//
//  Created by Ryo Aoyama on 2/26/17.
//  Copyright © 2017 Ryo Aoyama. All rights reserved.
//

import AVFoundation
import ReactiveSwift
import Result
import lf

extension Reactive where Base: BroadcastViewModel {
    var broadcast: BindingTarget<Bool> {
        return base.isBroadcasting.bindingTarget
    }
    
    var isBroadcasting: Property<Bool> {
        return .init(base.isBroadcasting)
    }
}

final class BroadcastViewModel: ReactiveExtensionsProvider {
    let httpStream = HTTPStream()
    
    fileprivate let (lifetime, token) = Lifetime.make()
    fileprivate let disposable = ScopedCompositeDisposable()
    fileprivate let service = HTTPService(domain: "", type: HTTPService.type, name: "LiveStreamingApp", port: HTTPService.defaultPort)
    fileprivate let isBroadcasting = MutableProperty(false)
    
    init() {
        configure()
    }
    
    deinit {
        stopStream()
    }
}

private extension BroadcastViewModel {
    func configure() {
        httpStream.orientation = AVCaptureVideoOrientation.landscapeRight
        httpStream.captureSettings = ["sessionPreset": AVCaptureSessionPreset1920x1080]
        httpStream.attachCamera(DeviceUtil.device(withPosition: .back))
        httpStream.attachAudio(AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeAudio))
        
        disposable += isBroadcasting.signal
            .observeValues { [unowned self] in ($0 ? self.startStream : self.stopStream)() }
    }
    
    func startStream() {
        UIApplication.shared.isIdleTimerDisabled = true
        httpStream.publish("live")
        service.addHTTPStream(httpStream)
        service.startRunning()
    }
    
    func stopStream() {
        UIApplication.shared.isIdleTimerDisabled = false
        httpStream.publish(nil)
        service.removeHTTPStream(httpStream)
        service.stopRunning()
    }
}

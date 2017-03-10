//
//  AVPlayerLayer.swift
//  LiveStreamingApp
//
//  Created by Ryo Aoyama on 3/8/17.
//  Copyright © 2017 Ryo Aoyama. All rights reserved.
//

import AVFoundation
import ReactiveSwift
import ReactiveCocoa
import Result

extension Reactive where Base: AVPlayerLayer {
    var readyForDisplay: Property<Bool> {
        let readyForDisplay = DynamicProperty<Bool>(object: base, keyPath: "readyForDisplay").producer.skipNil()
        return .init(initial: base.isReadyForDisplay, then: readyForDisplay)
    }
}

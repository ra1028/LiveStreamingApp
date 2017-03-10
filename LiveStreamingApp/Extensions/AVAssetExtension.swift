//
//  AVAssetExtension.swift
//  LiveStreamingApp
//
//  Created by Ryo Aoyama on 3/8/17.
//  Copyright © 2017 Ryo Aoyama. All rights reserved.
//

import AVFoundation
import ReactiveSwift
import Result

extension Reactive where Base: AVAsset {
    var playable: Property<Bool> {
        let loadPlayable = SignalProducer<Bool, NoError> { [weak base] observer, _ in
            guard let base = base else { return }
            
            base.loadValuesAsynchronously(forKeys: ["playable"]) { [weak base] in
                guard let base = base else { return }
                
                observer.send(value: base.isPlayable)
            }
        }
        
        return .init(initial: base.isPlayable, then: loadPlayable)
    }
}

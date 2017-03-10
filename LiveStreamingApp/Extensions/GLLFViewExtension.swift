//
//  GLLFViewExtension.swift
//  LiveStreamingApp
//
//  Created by Ryo Aoyama on 2/26/17.
//  Copyright © 2017 Ryo Aoyama. All rights reserved.
//

import ReactiveSwift
import ReactiveCocoa
import lf

extension Reactive where Base: GLLFView {
    var httpStream: BindingTarget<HTTPStream?> {
        return makeBindingTarget { $0.attachStream($1) }
    }
}

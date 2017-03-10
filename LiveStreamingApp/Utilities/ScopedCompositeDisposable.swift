//
//  ScopedCompositeDisposable.swift
//  LiveStreamingApp
//
//  Created by Ryo Aoyama on 2/26/17.
//  Copyright © 2017 Ryo Aoyama. All rights reserved.
//

import ReactiveSwift

public typealias ScopedCompositeDisposable = ScopedDisposable<CompositeDisposable>

public extension ScopedDisposable where Inner: CompositeDisposable {
    convenience init() {
        self.init(Inner())
    }
}

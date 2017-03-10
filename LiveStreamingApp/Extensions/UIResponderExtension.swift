//
//  UIResponderExtension.swift
//  LiveStreamingApp
//
//  Created by Ryo Aoyama on 3/9/17.
//  Copyright © 2017 Ryo Aoyama. All rights reserved.
//

import UIKit
import ReactiveSwift

extension Reactive where Base: UIResponder {
    var resignFirstResponder: BindingTarget<()> {
        return makeBindingTarget { $0.0.resignFirstResponder() }
    }
}

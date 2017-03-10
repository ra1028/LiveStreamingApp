//
//  RootViewController.swift
//  LiveStreamingApp
//
//  Created by Ryo Aoyama on 3/9/17.
//  Copyright © 2017 Ryo Aoyama. All rights reserved.
//

import UIKit
import ReactiveSwift

final class RootViewController: UIViewController {
    @IBOutlet fileprivate weak var playerButton: UIButton!
    @IBOutlet fileprivate weak var broadcastButton: UIButton!
    
    fileprivate let disposable = ScopedCompositeDisposable()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
}

private extension RootViewController {
    func configure() {
        disposable += reactive.pushViewController(animated: true) <~ Signal.merge(
            playerButton.reactive.controlEvents(.touchUpInside).map { _ in PlayerViewController.instantiate() },
            broadcastButton.reactive.controlEvents(.touchUpInside).map { _ in BroadcastViewController.instantiate() }
        )
    }
}

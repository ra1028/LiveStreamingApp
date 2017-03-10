//
//  PlayerViewController.swift
//  LiveStreamingApp
//
//  Created by Ryo Aoyama on 3/6/17.
//  Copyright © 2017 Ryo Aoyama. All rights reserved.
//

import UIKit
import ReactiveSwift

extension Reactive where Base: PlayerViewController {
    var currentPlayerLayerView: BindingTarget<PlayerLayerView?> {
        return makeBindingTarget { $0.currentPlayerLayerView = $1 }
    }
}

final class PlayerViewController: UIViewController, UIGestureRecognizerDelegate {
    @IBOutlet fileprivate weak var playerContainerView: UIView!
    @IBOutlet fileprivate weak var textView: UITextView!
    fileprivate let ipAddressTextField = IPAddressTextField()
    
    fileprivate let vm = PlayerViewModel()
    fileprivate let disposable = ScopedCompositeDisposable()
    
    fileprivate var currentPlayerLayerView: PlayerLayerView? {
        didSet {
            oldValue?.removeFromSuperview()
            currentPlayerLayerView?.addConstrainedTo(superView: playerContainerView)
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override var inputAccessoryView: UIView? {
        return ipAddressTextField
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
}

private extension PlayerViewController {
    func configure() {
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        
        let tap = UITapGestureRecognizer()
        view.addGestureRecognizer(tap)
        
        disposable += reactive.currentPlayerLayerView <~ vm.reactive.playablePlayer
            .map { $0.map(PlayerLayerView.init(player:)) }
        
        disposable += textView.reactive.text <~ vm.reactive.monitoredPlaylistText
        
        disposable += ipAddressTextField.reactive.resignFirstResponder <~ tap.reactive.stateChanged
            .map { _ in }
        
        disposable += vm.reactive.streamURL <~ ipAddressTextField.reactive.controlEvents(.editingDidEndOnExit)
            .on(value: { $0.resignFirstResponder() })
            .filterMap { $0.text.map { "http://\($0):8080/live/playlist.m3u8" }.flatMap(URL.init(string:)) }
    }
}

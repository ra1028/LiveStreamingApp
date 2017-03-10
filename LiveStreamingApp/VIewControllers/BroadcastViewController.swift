//
//  BroadcastViewController.swift
//  LiveStreamingApp
//
//  Created by Ryo Aoyama on 2/26/17.
//  Copyright © 2017 Ryo Aoyama. All rights reserved.
//

import UIKit
import AVFoundation
import ReactiveSwift
import ReactiveCocoa
import Result
import lf

final class BroadcastViewController: UIViewController, UIGestureRecognizerDelegate {
    @IBOutlet fileprivate weak var containerView: UIView!
    @IBOutlet fileprivate weak var captureControl: UIControl!
    @IBOutlet fileprivate weak var captureStateView: UIView!
    @IBOutlet fileprivate weak var publishingLabel: UILabel!
    
    fileprivate let vm = BroadcastViewModel()
    fileprivate let disposable = ScopedCompositeDisposable()
    
    fileprivate let lfView = GLLFView(frame: .zero)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
}

private extension BroadcastViewController {
    func configure() {
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        
        captureControl.layer.cornerRadius = captureControl.bounds.height / 2
        captureControl.layer.borderColor = UIColor.white.cgColor
        captureControl.layer.borderWidth = 8
        captureControl.backgroundColor = .clear
        
        captureStateView.layer.cornerRadius = captureStateView.bounds.width / 2
        
        publishingLabel.alpha = 0
        publishingLabel.layer.cornerRadius = publishingLabel.bounds.height / 2
        
        lfView.videoGravity = AVLayerVideoGravityResizeAspect
        lfView.attachStream(vm.httpStream)
        containerView.addConstrained(subview: lfView)
        
        disposable += vm.reactive.broadcast <~ captureControl.reactive.controlEvents(.touchUpInside)
            .scan(false) { return !$0.0 }
        
        disposable += vm.reactive.isBroadcasting.producer
            .observe(on: UIScheduler())
            .startWithValues { [unowned self] isBroadcasting in
                let duration: TimeInterval = 0.2
                let cornerRadius = isBroadcasting ? 5 : self.captureStateView.bounds.width / 2
                let transform = isBroadcasting ? CATransform3DMakeScale(0.5, 0.5, 1) : CATransform3DIdentity
                let cornerRadiusAnimation = CABasicAnimation(keyPath: "cornerRadius")
                let transformAnimation = CABasicAnimation(keyPath: "transform")
                cornerRadiusAnimation.fromValue = self.captureStateView.layer.cornerRadius
                cornerRadiusAnimation.toValue = cornerRadius
                transformAnimation.fromValue = self.captureStateView.layer.transform
                transformAnimation.toValue = transform
                let animationGroup = CAAnimationGroup()
                animationGroup.animations = [cornerRadiusAnimation, transformAnimation]
                animationGroup.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
                animationGroup.duration = duration
                self.captureStateView.layer.add(animationGroup, forKey: "animation")
                self.captureStateView.layer.cornerRadius = cornerRadius
                self.captureStateView.layer.transform = transform
                UIView.animate(withDuration: duration) { self.publishingLabel.alpha = isBroadcasting ? 1 : 0 }
        }
    }
}

//
//  PlayerLayerView.swift
//  LiveStreamingApp
//
//  Created by Ryo Aoyama on 3/9/17.
//  Copyright © 2017 Ryo Aoyama. All rights reserved.
//

import UIKit
import AVFoundation
import ReactiveSwift

final class PlayerLayerView: UIView {
    fileprivate var playerLayer: AVPlayerLayer {
        return layer as! AVPlayerLayer
    }
    
    override class var layerClass: AnyClass {
        return AVPlayerLayer.self
    }
    
    init(player: AVPlayer) {
        super.init(frame: .zero)
        configure()
        playerLayer.player = player
        player.play()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }
    
    deinit {
        self.playerLayer.player = nil
    }
}

private extension PlayerLayerView {
    func configure() {
        playerLayer.videoGravity = AVLayerVideoGravityResizeAspect
    }
}

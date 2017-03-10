//
//  PlayerViewModel.swift
//  LiveStreamingApp
//
//  Created by Ryo Aoyama on 3/7/17.
//  Copyright © 2017 Ryo Aoyama. All rights reserved.
//

import Foundation
import AVFoundation
import ReactiveSwift
import Result

extension Reactive where Base: PlayerViewModel {
    var streamURL: BindingTarget<URL> {
        return .init(on: QueueScheduler(qos: .default), lifetime: base.lifetime) { [weak base] in
            guard let base = base else { return }
            base.reload(with: $0)
        }
    }
    
    var playablePlayer: Signal<AVPlayer?, NoError> {
        return base.playablePlayer.signal
    }
    
    var monitoredPlaylistText: Signal<String, NoError> {
        return base.monitoredPlaylistText.skipRepeats().signal
    }
}

final class PlayerViewModel: ReactiveExtensionsProvider {
    fileprivate let (lifetime, token) = Lifetime.make()
    fileprivate var playingDisposable = ScopedCompositeDisposable()
    
    fileprivate let playablePlayer = MutableProperty<AVPlayer?>(nil)
    fileprivate let monitoredPlaylistText = MutableProperty("")
}

private extension PlayerViewModel {
    func reload(with url: URL) {
        playingDisposable = .init()
        playablePlayer.value = nil
        monitoredPlaylistText.value = ""
        
        let asset = AVURLAsset(url: url)
        let playerItem = AVPlayerItem(asset: asset)
        
        playingDisposable += playablePlayer <~ asset.reactive.playable.producer
            .filter { $0 }
            .take(first: 1)
            .observe(on: QueueScheduler.main)
            .map { _ in AVPlayer(playerItem: playerItem) }
        
        playingDisposable += monitoredPlaylistText <~ URLSession.shared.reactive.continuousMonitorFile(url: url, interval: 1)
            .filterMap { String(data: $0, encoding: .utf8) }
        
        playingDisposable.inner.add(asset.cancelLoading)
    }
}

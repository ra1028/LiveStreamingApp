//
//  UIScrollViewExtension.swift
//  LiveStreamingApp
//
//  Created by Ryo Aoyama on 3/6/17.
//  Copyright © 2017 Ryo Aoyama. All rights reserved.
//

import UIKit

extension UIScrollView {
    func scrollToBottom(animated: Bool) {
        guard contentSize.height > bounds.height else { return }
        setContentOffset(.init(x: contentOffset.x, y: contentSize.height - bounds.height), animated: animated)
    }
}

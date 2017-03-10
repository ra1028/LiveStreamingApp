//
//  NSLayoutConstraints.swift
//  LiveStreamingApp
//
//  Created by Ryo Aoyama on 2/26/17.
//  Copyright © 2017 Ryo Aoyama. All rights reserved.
//

import UIKit

extension Array where Element: NSLayoutConstraint {
    func activate() {
        NSLayoutConstraint.activate(self)
    }
    
    func deactivate() {
        NSLayoutConstraint.deactivate(self)
    }
}

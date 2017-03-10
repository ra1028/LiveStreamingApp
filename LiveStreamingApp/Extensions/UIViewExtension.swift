//
//  UIViewExtension.swift
//  LiveStreamingApp
//
//  Created by Ryo Aoyama on 2/26/17.
//  Copyright © 2017 Ryo Aoyama. All rights reserved.
//

import UIKit
import ReactiveSwift

extension UIView {
    func addConstrained(subview view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        
        [topAnchor.constraint(equalTo: view.topAnchor),
         bottomAnchor.constraint(equalTo: view.bottomAnchor),
         trailingAnchor.constraint(equalTo: view.trailingAnchor),
         leadingAnchor.constraint(equalTo: view.leadingAnchor)].activate()
    }
    
    func addConstrainedTo(superView view: UIView) {
        view.addConstrained(subview: self)
    }
}

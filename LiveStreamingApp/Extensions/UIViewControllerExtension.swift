//
//  UIViewControllerExtension.swift
//  LiveStreamingApp
//
//  Created by Ryo Aoyama on 2/26/17.
//  Copyright © 2017 Ryo Aoyama. All rights reserved.
//

import UIKit
import ReactiveSwift
import Result

extension Reactive where Base: UIViewController {
    func pushViewController<VC: UIViewController>(animated: Bool) -> BindingTarget<VC> {
        return makeBindingTarget { $0.navigationController?.pushViewController($1, animated: animated) }
    }
}

extension UIViewController: StoryboardInstantiatable {
    static var storyboardName: String {
        return String(reflecting: self).components(separatedBy: ".").last!
    }
    
    static var bundle: Bundle {
        return .main
    }
}

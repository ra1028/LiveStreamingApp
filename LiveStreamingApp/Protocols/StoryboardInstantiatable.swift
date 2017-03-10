//
//  StoryboardInstantiatable.swift
//  LiveStreamingApp
//
//  Created by Ryo Aoyama on 2/26/17.
//  Copyright © 2017 Ryo Aoyama. All rights reserved.
//

import UIKit

enum StoryboardInstantiateStrategy {
    case initial
    case identifier(String)
}

protocol StoryboardInstantiatable: class {
    static var storyboardName: String { get }
    static var bundle: Bundle { get }
}

extension StoryboardInstantiatable where Self: UIViewController {
    static func instantiate(strategy: StoryboardInstantiateStrategy = .initial) -> Self {
        let storyboard = UIStoryboard(name: storyboardName, bundle: bundle)
        let instance: Self?
        
        switch strategy {
        case .initial:
            instance = storyboard.instantiateInitialViewController() as? Self
        case .identifier(let identifier):
            instance = storyboard.instantiateViewController(withIdentifier: identifier) as? Self
        }
        
        guard let viewController = instance else { fatalError("Failed to instantiate \(Self.self) from storyboard.") }
        
        return viewController
    }
}

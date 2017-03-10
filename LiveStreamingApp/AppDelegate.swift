//
//  AppDelegate.swift
//  LiveStreamingApp
//
//  Created by Ryo Aoyama on 2/26/17.
//  Copyright © 2017 Ryo Aoyama. All rights reserved.
//

import UIKit

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        configure()
        return true
    }
}

private extension AppDelegate {
    func configure() {
        window = UIWindow(frame: UIScreen.main.bounds)
        let rootViewController = RootViewController.instantiate()
        let navigationController = UINavigationController(rootViewController: rootViewController)
        navigationController.isNavigationBarHidden = true
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
}

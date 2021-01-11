//
//  AppDelegate.swift
//  AVMIDIPlayerSanityCheck
//
//  Created by Haris Ali on 1/11/21.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    let rootVC = ViewController()
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow()
        window?.rootViewController = rootVC
        window?.makeKeyAndVisible()
        
        return true
    }

}


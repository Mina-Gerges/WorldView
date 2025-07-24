//
//  AppDelegate.swift
//  WorldView
//
//  Created by Mina Gerges on 24/07/2025.
//

import UIKit
import netfox

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        // MARK: - Setup Netfox
        //=====================
        #if DEBUG
        NFX.sharedInstance().start()
        #endif
        
        return true
    }
    
}

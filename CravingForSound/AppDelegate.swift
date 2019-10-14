//
//  AppDelegate.swift
//  Craving for Sound
//
//  Created by Rodion on 03/10/2019.
//  Copyright © 2019 LetsSee. All rights reserved.
//

import UIKit

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {

    private(set) lazy var appCoordinator = AppCoordinator()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions
        launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        appCoordinator.start()
            .subscribe()
            .dispose()
        return true
        
    }
    
}

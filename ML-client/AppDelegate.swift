//
//  AppDelegate.swift
//  ML-client
//
//  Created by Pablo Romero on 8/12/17.
//  Copyright © 2017 Pablo Romero. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let paymentManager = PaymentManager()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow()
        window?.rootViewController = paymentManager.controller
        window?.makeKeyAndVisible()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
    
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
  
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
 
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
    
    }

    func applicationWillTerminate(_ application: UIApplication) {
   
    }

}

//
//  AppDelegate.swift
//  JitenshaMobile
//
//  Created by Chijioke Ndubisi on 01/03/2017.
//
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var apiToken: String!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        application.isStatusBarHidden = true

        return true
    }
    
    static var delegate: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
}


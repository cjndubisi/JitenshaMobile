//
//  AppDelegate.swift
//  JitenshaMobile
//
//  Created by Chijioke Ndubisi on 01/03/2017.
//
//

import UIKit
import SimpleKeychain

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var apiToken: String!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        application.isStatusBarHidden = true

        guard let token = A0SimpleKeychain(service: "Jitensha").string(forKey: "accessToken") else {
            return true
        }

        APIClinet.shared.apiToken = token
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = UIAssistant.rootView()

        window?.makeKeyAndVisible()

        return true
    }
    
    static var delegate: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
}


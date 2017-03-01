//
//  UIAssistant.swift
//  industry-ios
//
//  Created by Chijioke Ndubisi on 28/02/2017.
//  Copyright © 2017 Reach. All rights reserved.
//

import UIKit

class UIAssistant {
    
    static func rootView() -> UIViewController {
        let tab = UITabBarController()
        let business = UITabBarItem(title: "Business", image: #imageLiteral(resourceName: "Menu_Business"), selectedImage: #imageLiteral(resourceName: "Menu_Business_ac"))

        let profile = UITabBarItem(title: "Profile", image: #imageLiteral(resourceName: "Menu_Profile"), selectedImage: #imageLiteral(resourceName: "Menu_Profile_ac"))

        let home = UITabBarItem(title: "Home", image: #imageLiteral(resourceName: "Menu_Home"), selectedImage: #imageLiteral(resourceName: "Menu_Home_ac"))
        let job = UITabBarItem(title: "Jobs", image: #imageLiteral(resourceName: "Menu_Jobs"), selectedImage: #imageLiteral(resourceName: "Menu_Jobs_ac"))
        let notification =  UITabBarItem(title: "Notifications", image: #imageLiteral(resourceName: "Menu_Notifications"), selectedImage: #imageLiteral(resourceName: "Menu_Notifications_ac"))
        let businessVC = UINavigationController(rootViewController: BusinessController())
        businessVC.tabBarItem = business

        let profileVC = UINavigationController(rootViewController: ProfileController())
        profileVC.tabBarItem = profile

        let homeVC = UINavigationController(rootViewController: HomeController())
        homeVC.tabBarItem = home

        let jobVC = UINavigationController(rootViewController: JobController())
        jobVC.tabBarItem = job

        let notificationVC = UINavigationController(rootViewController: NotificationController())
        notificationVC.tabBarItem = notification

        let vcs = [businessVC, profileVC, homeVC, jobVC, notificationVC]

        tab.setViewControllers(vcs, animated: false)

        return tab
    }

    static func alert(with title: String = "Error", message: String, style: UIAlertActionStyle = .default)  -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "dismiss", style: style, handler: nil)
        alert.addAction(action)

        return alert
    }
}

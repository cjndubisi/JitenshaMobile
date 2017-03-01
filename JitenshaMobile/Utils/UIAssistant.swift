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
        return MapViewController()
    }

    static func alertError(with title: String = "Error", message: String, style: UIAlertActionStyle = .default)  -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "dismiss", style: style, handler: nil)
        alert.addAction(action)

        return alert
    }
}

//
//  AppDelegate.swift
//  JitenshaMobile
//
//  Created by Chijioke Ndubisi on 01/03/2017.
//
//

import UIKit
import SimpleKeychain
import OHHTTPStubs

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var apiToken: String! {
        return APIClient.shared.apiToken
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        #if DEBUG
            if (ProcessInfo.processInfo.arguments.contains("STUB_HTTP_ENDPOINTS")) {
                self.setupNetworkStubs()
            }
        #endif

        application.isStatusBarHidden = true
        guard let token = A0SimpleKeychain(service: "Jitensha").string(forKey: "accessToken") else {
            return true
        }

        APIClient.shared.apiToken = token
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController =  UINavigationController(rootViewController: UIAssistant.rootView())

        window?.makeKeyAndVisible()

        return true
    }
    
    static var delegate: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }

    private func setupNetworkStubs() {
        A0SimpleKeychain(service: "Jitensha").clearAll()

        stub(condition: isHost("localhost") && isPath("/api/v1/register"), response: { _ in
            let url = Bundle(for: self.classForCoder).url(forResource: "POST#auth", withExtension: ".json")
            return OHHTTPStubsResponse(fileURL: url!, statusCode: 200, headers: nil)
        })
        // Put setup code here. This method is called before the invocation of each test method in the class.

        stub(condition: isHost("localhost") && isPath("/api/v1/auth"), response: { _ in
            let url = Bundle(for: self.classForCoder).url(forResource: "POST#auth", withExtension: ".json")
            return OHHTTPStubsResponse(fileURL: url!, statusCode: 200, headers: nil)
        })
        stub(condition: isHost("localhost") && isPath("/api/v1/places"), response: { _ in
            let url = Bundle(for: self.classForCoder).url(forResource: "GET#places", withExtension: ".json")
            return OHHTTPStubsResponse(fileURL: url!, statusCode: 200, headers: nil)
        })

        stub(condition: isHost("localhost") && isPath("/api/v1/rent"), response: { _ in
            let url = Bundle(for: self.classForCoder).url(forResource: "POST#rent", withExtension: ".json")
            return OHHTTPStubsResponse(fileURL: url!, statusCode: 200, headers: nil)
        })
    }
}


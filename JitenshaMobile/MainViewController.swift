//
//  MainViewController.swift
//  JitenshaMobile
//
//  Created by Chijioke Ndubisi on 01/03/2017.
//
//

import UIKit

class MainViewController: UIViewController {

    private let loginButtonTag = 20

    @IBAction func authenticate(_ sender: UIButton) {
        performSegue(withIdentifier: "Authenticate", sender: sender)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destination = segue.destination as? AuthController,
        let button = sender as? UIButton else {
            return
        }

        destination.isLogin = button.tag == loginButtonTag ? .login : .register
    }
}

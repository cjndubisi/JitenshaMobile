//
//  ViewController.swift
//  JitenshaMobile
//
//  Created by Chijioke Ndubisi on 01/03/2017.
//
//

import UIKit
import SwiftValidator
import NVActivityIndicatorView

class AuthController: UIViewController, NVActivityIndicatorViewable {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!

    private var validator: Validator = Validator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        validator.registerField(emailField, rules: [RequiredRule(), EmailRule()])
        validator.registerField(passwordField, rules: [RequiredRule(), PasswordRule()])
    }

    @IBAction func login() {
        startAnimating()
    }

    @IBAction func signup() {
        startAnimating()
    }

    fileprivate func validateInput() {
        validator.validate { (errors) in

        }
    }
}


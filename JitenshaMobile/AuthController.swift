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
    @IBOutlet weak var loginButton: UIButton!

    private var validator: Validator!
    var isLogin: AuthState = .login
    
    override func viewDidLoad() {
        super.viewDidLoad()

        validator.registerField(emailField, rules: [RequiredRule(), EmailRule()])
        validator.registerField(passwordField, rules: [RequiredRule(), PasswordRule()])

        loginButton.setTitle(isLogin.rawValue, for: .normal)
    }

    @IBAction func authenticate() {
        startAnimating()

    }

    enum AuthState: String  {
        case login = "Login"
        case register = "Register"
    }
}


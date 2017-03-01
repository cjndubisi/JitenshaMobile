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
import PromiseKit

class AuthController: UIViewController, NVActivityIndicatorViewable {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!

    private var validator: Validator = Validator()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        emailField.layer.borderColor = UIColor.white.withAlphaComponent(0.5).cgColor
        emailField.layer.borderWidth = 1.0
        passwordField.layer.borderColor = UIColor.white.withAlphaComponent(0.5).cgColor
        passwordField.layer.borderWidth = 1.0

        // Indent placeholder text
        let emailPaddingView = UIView(frame: CGRect(x:0, y:0, width:5,height: 20));
        let passwordPaddingView = UIView(frame: CGRect(x:0, y:0, width:5,height: 20));
        emailField.leftView = emailPaddingView;
        emailField.leftViewMode = .always;
        passwordField.leftView = passwordPaddingView;
        passwordField.leftViewMode = .always;

        validator.registerField(emailField, rules: [RequiredRule(), EmailRule()])
        validator.registerField(passwordField, rules: [RequiredRule(), PasswordRule()])
    }

    @IBAction func login() {
        startAnimating()
        APIClinet.shared
            .login(with: emailField.text!, password: passwordField.text!)
            .then{ [unowned self] () -> Void in
                self.stopAnimating()
                self.moveToHome()
        }.catch { [unowned self] (error) in
            self.stopAnimating()
            self.present(UIAssistant.alertError(message: error.localizedDescription), animated: true)
        }
    }

    @IBAction func signup() {
        startAnimating()
        APIClinet.shared
            .signUp(with: emailField.text!, password: passwordField.text!)
            .then{ [unowned self] () -> Void in
                self.stopAnimating()
                self.moveToHome()
            }.catch { [unowned self] (error) in
                self.stopAnimating()
                self.present(UIAssistant.alertError(message: error.localizedDescription), animated: true)
        }
    }

    fileprivate func validateInput() {
        validator.validate { (errors) in

        }
    }

    private func moveToHome() {
        let window = AppDelegate.delegate.window!
        let rootVC = UINavigationController(rootViewController: UIAssistant.rootView())
        UIView.transition(from: window.rootViewController!.view!,
                          to: rootVC.view,
                          duration: 0.3,
                          options: .transitionCrossDissolve)
        { (_) in
            window.rootViewController = rootVC
        }
    }
}


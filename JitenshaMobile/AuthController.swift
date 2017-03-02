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
import Sugar

class AuthController: UIViewController, NVActivityIndicatorViewable {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!

    private var validator: Validator = Validator()
    private var keyboardObserver: KeyboardObserver!
    private var keyboardIsUp: Bool = false

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

        // Handle UIKeyboardWillShow & UIKeyboardWillHide
        let handler = BasicKeyboardHandler()
        handler.show = { [weak self] height in
            guard let sSelf = self else { return }
            if !sSelf.keyboardIsUp {
                let diff = sSelf.view.frame.height - sSelf.passwordField.frame.maxY
                sSelf.view.frame.origin.y += height - diff
                sSelf.keyboardIsUp = true
            }
        }

        handler.hide = { [weak self] in
            guard let sSelf = self else { return }
            if sSelf.keyboardIsUp {
                sSelf.view.frame.origin.y = 0
                sSelf.keyboardIsUp = false
            }
        }
        keyboardObserver = KeyboardObserver(handler: handler)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        keyboardObserver.activate()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        keyboardObserver.deactivate()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

    @IBAction func login() {
        if let errorAlert = validateInput() {
            self.present(errorAlert, animated: true)
            return
        }
        startAnimating()
        let promise = APIClient.shared
            .login(with: emailField.text!, password: passwordField.text!)
        self.authenticate(promise)
    }

    @IBAction func signup() {
        if let errorAlert = validateInput() {
            self.present(errorAlert, animated: true)
            return
        }
        startAnimating()
        let promise = APIClient.shared
            .signUp(with: emailField.text!, password: passwordField.text!)
        self.authenticate(promise)
    }

    private func authenticate(_ promise: Promise<Void>) {
        promise.then { [unowned self] () -> Void in
            self.stopAnimating()
            self.moveToHome()
            }.catch { [unowned self] (error) in
                self.stopAnimating()
                self.present(UIAssistant.alert(message: error.localizedDescription), animated: true)
        }

    }

    fileprivate func validateInput() -> UIAlertController? {
        var errorMsg: (String, String)!

        validator.validate { (errors) in
            if let (field, error) = errors.first {
                errorMsg = ((field as! UITextField).placeholder!, error.errorMessage)
            }
        }
        guard errorMsg == nil else {
            return UIAssistant.alert(with:errorMsg.0, message: errorMsg.1)
        }
        return nil
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


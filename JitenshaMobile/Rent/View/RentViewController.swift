//
//  RentViewController.swift
//  
//
//  Created by Chijioke Ndubisi on 02/03/2017.
//
//

import UIKit
import SwiftValidator

class RentViewController: UIViewController {

    @IBOutlet weak var cardHolderField: UITextField!
    @IBOutlet weak var cardNumberField: UITextField!
    @IBOutlet weak var expirationField: UITextField!
    @IBOutlet weak var cvvField: UITextField!

    fileprivate let validator = Validator()

    init() {
        super.init(nibName: String(describing: type(of: self)), bundle: .main)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Rent", style: .done, target: self, action: #selector(rent))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancel))

        validator.registerField(cardNumberField, rules: [RequiredRule(message: "Card Number cannot be emptry")])
        validator.registerField(cardHolderField, rules: [RequiredRule(message: "Card Holder cannot be emptry")])
        validator.registerField(expirationField, rules: [RequiredRule(message: "Expiration cannot be emptry")])
        validator.registerField(cvvField, rules: [RequiredRule(message: "CVV cannot be emptry")])
    }

    func cancel() {
        self.dismiss(animated: true)
    }

    func rent() {
        if let alert = validateInput()  {
            present(alert, animated: true)
            return
        }

        APIClient.shared.rent(with: cardHolderField.text!,
                              cardNumber: cardNumberField.text!,
                              expiration: expirationField.text!,
                              cvv: cvvField.text!)
            .then { [unowned self] (message) -> (Void) in

                let alert = UIAlertController(title: "Transcation Complete", message: "You rented a bicycle", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
                    alert.dismiss(animated: true)
                    self.dismiss(animated: true)
                }))

                self.present(alert, animated: true)
            }
            .catch { (error) in
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
}

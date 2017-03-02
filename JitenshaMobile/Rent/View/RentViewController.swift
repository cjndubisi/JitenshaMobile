//
//  RentViewController.swift
//  
//
//  Created by Chijioke Ndubisi on 02/03/2017.
//
//

import UIKit
import SwiftValidator
import Caishen

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

        validator.registerField(cardNumberField, rules: [RequiredRule(message: "Card Number cannot be emptry"), MaxLengthRule(length: 16), MinLengthRule(length: 16)])
        validator.registerField(cardHolderField, rules: [RequiredRule(message: "Card Holder cannot be emptry")])
        validator.registerField(expirationField, rules: [RequiredRule(message: "Expiration cannot be emptry"), MaxLengthRule(length: 5)])
        validator.registerField(cvvField, rules: [RequiredRule(message: "CVV cannot be emptry"), MaxLengthRule(length: 3)])
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

        // validate input rules
        validator.validate { (errors) in
            if let (field, error) = errors.first {
                errorMsg = ((field as! UITextField).placeholder!, error.errorMessage)
            }
        }

        guard errorMsg == nil else {
            return UIAssistant.alert(with:errorMsg.0, message: errorMsg.1)
        }

        // validate card details
        let expiryString = expirationField.text!.split("/")
        let expiryMonth = expiryString.count == 2 ? expiryString[0] : ""
        let expiryYear = expiryString.count == 2 ? expiryString[1] : ""
        let number = cardNumberField.text ?? ""
        let cvc = CVC(rawValue: cvvField.text ?? "")
        let expiry =  Expiry(month: expiryMonth, year: expiryYear) ?? .invalid

        let type = NumberInputTextField().cardTypeRegister.cardType(for: Number(rawValue: number))

        guard type.validate(cvc: cvc)
            .union(type.validate(expiry: expiry))
            .union(type.validate(number: Number(rawValue: number))) == .Valid else {
                return UIAssistant.alert(message: "Invalid card details")
        }

        return nil
    }
}

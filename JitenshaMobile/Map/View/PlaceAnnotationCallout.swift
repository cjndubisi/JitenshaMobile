//
//  JitenshaAnnotationCallout.swift
//  JitenshaMobile
//
//  Created by Chijioke Ndubisi on 01/03/2017.
//
//

import UIKit
import CoreLocation

class JitenshaAnnotationCallout: UIView {
    @IBOutlet weak var contactName: UILabel!

    weak var delegate: JitenshaAnnotationCalloutDelegate?
    weak var annotation: JitenshaMapAnnotation! {
        didSet {
            guard annotation != nil else { return }
            contactName.text = annotation.name
            (0..<3).forEach({
                guard let button = self.viewWithTag($0) as? UIButton else {
                    return
                }
                let image = button.image(for: .normal)

                button.setImage(image?.withRenderingMode(.alwaysTemplate), for: .normal)
                button.tintColor = .blue
            })
        }
    }

    @IBAction func rent() {
        delegate?.rent(with: annotation)
    }
}

protocol JitenshaAnnotationCalloutDelegate: class {
    func rent(with: MKAnnotation)
}

//
//  JitenshaAnnotationCallout.swift
//  JitenshaMobile
//
//  Created by Chijioke Ndubisi on 01/03/2017.
//
//

import UIKit
import CoreLocation

class PlaceMapAnnotationCallout: UIView {
    @IBOutlet weak var name: UILabel!

    let rentButtonTag = 40
    weak var delegate: PlaceMapAnnotationCalloutDelegate?
    weak var annotation: PlaceMapAnnotation! {
        didSet {
            guard annotation != nil else { return }
            name.text = annotation.name
        }
    }

    @IBAction func rent() {
        delegate?.rent(with: annotation)
    }
}

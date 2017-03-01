//
//  PlaceAnnotationView.swift
//  JitenshaMobile
//
//  Created by Chijioke Ndubisi on 01/03/2017.
//
//

import Foundation


import MapKit

class PlaceMapAnnotationView: MKPinAnnotationView {
    class var reuseIdentifier:String {
        return "PlaceMapAnnotationView"
    }

    private var calloutView: PlaceMapAnnotationCallout?
    private var hitOutside:Bool = true

    var preventDeselection:Bool {
        return !hitOutside
    }

    convenience init(annotation: MKAnnotation!) {
        self.init(annotation: annotation, reuseIdentifier: PlaceMapAnnotationView.reuseIdentifier)

        canShowCallout = false;
    }


    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        guard let view = super.hitTest(point, with: event) else { return  nil }
        self.superview?.bringSubview(toFront: view)

        return view
    }

    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {

        let rect = self.bounds
        var isInside = rect.contains(point)

        if !isInside {
            let view = self.subviews.first(where: { $0.frame.contains(point) })
            isInside = view != nil
        }

        return isInside
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        let calloutViewAdded = calloutView?.superview != nil

        if (selected || !selected && hitOutside) {
            super.setSelected(selected, animated: animated)
        }

        self.superview?.bringSubview(toFront: self)

        if (calloutView == nil) {
            let views = Bundle.main.loadNibNamed("LAMapAnnotationCallout", owner: nil, options: nil)

            let calloutView = views?[0] as! PlaceMapAnnotationCallout
            self.calloutView = calloutView
            self.calloutView?.annotation = self.annotation as? PlaceMapAnnotation
            self.calloutView?.layer.cornerRadius = 10
            self.calloutView?.center = CGPoint(x: self.bounds.size.width / 2, y: -calloutView.bounds.size.height*0.52)
        }

        if (self.isSelected && !calloutViewAdded) {
            addSubview(calloutView!)
        }
        
        if (!self.isSelected) {
            calloutView?.removeFromSuperview()
        }
    }
}

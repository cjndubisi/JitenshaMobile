//
//  JitenshaMapAnnotation.swift
//  JitenshaMobile
//
//  Created by Chijioke Ndubisi on 01/03/2017.
//
//

import MapKit
import CoreLocation

class PlaceMapAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var name: String

    init(place: Place) {
        self.name = place.name

        self.coordinate = CLLocation(latitude: place.long, longitude: place.long).coordinate
    }
}

protocol PlaceMapAnnotationCalloutDelegate: class {
    func rent(with: MKAnnotation)
}

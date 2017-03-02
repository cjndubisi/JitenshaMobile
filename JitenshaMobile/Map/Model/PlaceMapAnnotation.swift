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
    let name: String
    let id: String
    init(place: Place) {
        self.id = place.id
        self.name = place.name
        self.coordinate = CLLocation(latitude: place.lat, longitude: place.long).coordinate
    }
}

protocol PlaceMapAnnotationCalloutDelegate: class {
    func rent(with annotation: MKAnnotation)
}

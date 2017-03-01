//
//  MapViewController.swift
//  JitenshaMobile
//
//  Created by Chijioke Ndubisi on 01/03/2017.
//
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    private var places: [Place] = []
    private var isShowingContacts = true

    init() {
        super.init(nibName: "MapViewController", bundle: .main)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self

        let placeAnnotation = self.places.map{ PlaceMapAnnotation(place: $0)}
        self.mapView.addAnnotations(placeAnnotation)
        self.mapView.showAnnotations(placeAnnotation, animated: true)
    }
}

extension MapViewController: MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            // customize current location
            return nil
        }
        guard annotation is PlaceMapAnnotation else {
            return mapView.dequeueReusableAnnotationView(withIdentifier: "Pin")
        }
        if let view = mapView.dequeueReusableAnnotationView(withIdentifier: PlaceMapAnnotationView.reuseIdentifier) {
            return view
        }

        return PlaceMapAnnotationView(annotation: annotation)
    }
}

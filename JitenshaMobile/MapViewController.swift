//
//  MapViewController.swift
//  JitenshaMobile
//
//  Created by Chijioke Ndubisi on 01/03/2017.
//
//

import UIKit
import MapKit
import NVActivityIndicatorView

class MapViewController: UIViewController, NVActivityIndicatorViewable {

    @IBOutlet weak var mapView: MKMapView!
    fileprivate var places: [Place] = [] {
        didSet {
            updateUI()
        }
    }

    private var isShowingContacts = true

    init() {
        super.init(nibName: "MapViewController", bundle: .main)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.title = "Places"
        mapView.delegate = self
        startAnimating()
        APIClient.shared
            .places()
            .then { (json) -> (Void) in
                self.stopAnimating()
                self.places = json.enumerated().map({Place(json:$0.element)})
        }.catch { (error) in
            self.stopAnimating()
            self.present(UIAssistant.alert(message: error.localizedDescription), animated: true)
        }
        if places.count > 0 {
            updateUI()
        }
    }

    fileprivate func updateUI() {
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
        let annotationView = PlaceMapAnnotationView(annotation: annotation)
        annotationView.calloutDelegate = self

        return annotationView
    }
}

extension MapViewController: PlaceMapAnnotationCalloutDelegate {
    func rent(with annotation: MKAnnotation) {
        guard let annotation = annotation as? PlaceMapAnnotation else {
            return
        }
        if let _ = self.places.filter({$0.id == annotation.id }).first {
            let rentViewController = UINavigationController(rootViewController: RentViewController())
            self.present(rentViewController, animated: true)
        }
    }
}

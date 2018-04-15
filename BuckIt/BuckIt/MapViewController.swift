//
//  MapViewController.swift
//  BuckIt
//
//  Created by WilliamH on 1/23/18.
//  Copyright © 2018 Samnang Sok. All rights reserved.
//

import UIKit
import MapKit
import Firebase

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    private let locationManager = CLLocationManager()
    private var currentCoordinate: CLLocationCoordinate2D?
    private var activitiesPin = FirebaseDataContoller.sharedInstance.activitiesPin
//    private var controller = FirebaseDataContoller()
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        FirebaseDataContoller.sharedInstance.mapViewObj = self.mapView
        configureLocationServices()
    }
    
    override func viewDidAppear(_ animated: Bool) {
//        addAnnotations()
//        print("Counter: INSIDE AFter \(activitiesPin.count) \n\n")
    }
    
    private func configureLocationServices() {
        locationManager.delegate = self
        let status = CLLocationManager.authorizationStatus()
        
        if status == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        } else if status == .authorizedWhenInUse {
            beginLocationUpdates(locationManager: locationManager)
        }
    }
    
    private func beginLocationUpdates(locationManager: CLLocationManager) {
        mapView.showsUserLocation = true
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }
    
    private func zoomToLatestLocation(with coordinate: CLLocationCoordinate2D) {
        let zoomLevel: Double = 10000
        let zoomRegion = MKCoordinateRegionMakeWithDistance(coordinate, zoomLevel, zoomLevel)
        mapView.setRegion(zoomRegion, animated: true)
    }
    
    private func addAnnotations() {
//        print("Counter in ADDANNO: \(FirebaseDataContoller.sharedInstance.activitiesPin.count)")
//        print("Counter in ADDANNO: \(FirebaseDataContoller.sharedInstance.activitiesPinGetter.count)")
//        for activity in FirebaseDataContoller.sharedInstance.activitiesPinGetter {
//            self.mapView.addAnnotation(activity)
//            print("After addANNO in the loop")
//        }
//        print("Counter in ADDANNO: \(FirebaseDataContoller.sharedInstance.activitiesPin.count)")
//        print("Counter in ADDANNO: \(FirebaseDataContoller.sharedInstance.activitiesPinGetter.count)")
        print("Inside ANNO before")
        FirebaseDataContoller.sharedInstance.fetchActivitiesToMap()
        print("Inside ANNO After \(FirebaseDataContoller.sharedInstance.activitiesPin.count)\n")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("Did get latest location")
        guard let latestLocation = locations.first else { return }
        
        if currentCoordinate == nil {
            zoomToLatestLocation(with: latestLocation.coordinate)
            addAnnotations()
        }
        print("\(FirebaseDataContoller.sharedInstance.activitiesPin.count)")
        currentCoordinate = latestLocation.coordinate
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("Status changed")
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            beginLocationUpdates(locationManager: manager)
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        print("Inside ViewFor")
        
        let annotationIdentifier = "ActivityAnnotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier)
        
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
            print("AnnotationView created\n\n")
        }
        
        if annotation === mapView.userLocation {
            annotationView?.image = UIImage(named: "current_user.png")
        }
        
        if let annotationView = annotationView, let _ = annotation as? ActivityPin {
            for activity in FirebaseDataContoller.sharedInstance.activitiesPin {
                if let title = annotation.title, title == activity.title {
                    print("\t \(activity.imageName)\n\n")
                    annotationView.image = UIImage(named: "\(activity.imageName)")
                }
            }
        }
        
        annotationView?.canShowCallout = true
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        print("Selected annotation: \(String(describing: view.annotation?.title))")
    }
}

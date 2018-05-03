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
    private var activitiesPin = [ActivityPin]()
    private var activities = [Activity]()
    var selectedActivity = Activity?.self
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var search: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        configureLocationServices()
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        self.navigationController?.setNavigationBarHidden(true, animated: false)
//    }
//    override func viewWillDisappear(_ animated: Bool) {
//        self.navigationController?.setNavigationBarHidden(false, animated: false)
//    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("Did get latest location")
        guard let latestLocation = locations.first else { return }
        
        if currentCoordinate == nil {
            zoomToLatestLocation(with: latestLocation.coordinate)
            fetchActivities()
        }
        print("Current # of pins: \(activitiesPin.count)")
        currentCoordinate = latestLocation.coordinate
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("Status changed")
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            beginLocationUpdates(locationManager: manager)
        }
    }
    
    // Customized pins starts here ~ This implementation behaves like an UIView
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {        
        let annotationIdentifier = "ActivityAnnotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier)
    
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
        }
        
        // Display pin icon for user's current location
        if annotation === mapView.userLocation {
            annotationView?.image = UIImage(named: "current_user.png")
        }
        
        // Display pin icon for all the activities from the Firebase
        if let annotationView = annotationView, let _ = annotation as? ActivityPin {
            for activity in activitiesPin {
                if let title = annotation.title, title == activity.title {
                    annotationView.image = UIImage(named: "\(activity.imageName)")
                }
            }
        }
        
        annotationView?.canShowCallout = true
        annotationView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        return annotationView
    }
    
    // Display a messege in the console for the pin selected on the map
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        print("Selected annotation: \(String(describing: view.annotation?.title))")
        for item in activities {
            print("\n\n \(item)")
        }
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
//        let annotationView = view.annotation
        
        performSegue(withIdentifier: "showActivityProfileVC", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? ActivityProfileViewController{
//            destination.activity =
        }
    }
    
    // This helper method fetches of one category from Firebase
    func fetchActivities() {
        let ref = FirebaseDataContoller.sharedInstance.refToFirebase
        ref.child("Activities").observeSingleEvent(of: .value, with: { (snap) in
            if snap.exists() {
                let activitySnap = snap.value as! [String: AnyObject]
                for (_,activity) in activitySnap {
                    var activityObj = Activity()
                    if let title = activity["activityName"] as? String,
                        let subtitle = activity["description"] as? String,
                        let latitude = activity["latitude"] as? Double,
                        let longitude = activity["longitude"] as? Double,
                        let category = activity["category"] as? String {
                        
                        var imageFileName : String = ""
                        for (key, value) in FirebaseDataContoller.sharedInstance.categoriesDictionary {
                            if category == "\(key)" {
                                imageFileName = "\(value)"
                            }
                        }
                        let coordinate = CLLocationCoordinate2DMake(latitude, longitude)
                        let activityPin = ActivityPin(title: title, subtitle: subtitle, coordinate: coordinate, category: category, imageName: imageFileName)
                        activityObj.title = title
                        activityObj.theDescription = subtitle
                        
                        self.activities.append(activityObj)
                        self.activitiesPin.append(activityPin)
                        print("Count inside: \(self.activitiesPin.count) \n")
                        self.mapView.addAnnotation(activityPin)
                    }
                }
            }
        })
        reference.removeAllObservers()
    }
    
    // This helper method allows to request permission to track user's location
    private func configureLocationServices() {
        locationManager.delegate = self
        let status = CLLocationManager.authorizationStatus()
        
        if status == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        } else if status == .authorizedWhenInUse {
            beginLocationUpdates(locationManager: locationManager)
        }
    }
    
    // This helper method allows to starts gathering user's location
    private func beginLocationUpdates(locationManager: CLLocationManager) {
        mapView.showsUserLocation = true
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }
    
    // This helper method allows to auto-zoom the map once it's loaded
    private func zoomToLatestLocation(with coordinate: CLLocationCoordinate2D) {
        let zoomLevel: Double = 3000
        let zoomRegion = MKCoordinateRegionMakeWithDistance(coordinate, zoomLevel, zoomLevel)
        mapView.setRegion(zoomRegion, animated: true)
    }
}

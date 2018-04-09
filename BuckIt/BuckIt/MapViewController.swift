//
//  MapViewController.swift
//  BuckIt
//
//  Created by WilliamH on 1/23/18.
//  Copyright © 2018 Samnang Sok. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    private let locationManager = CLLocationManager()
    private var currentCoordinate: CLLocationCoordinate2D?

    var activitiesPin: Array<ActivityPin> = Array()
    
    @IBOutlet weak var mapView: MKMapView!
    
    class CPA: MKPointAnnotation {
        var imageName: String?
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        addAnnotations()
        configureLocationServices()
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
        var applePin: ActivityPin!
        var parkPin: ActivityPin!

        let appleCoordinate = CLLocationCoordinate2D(latitude: 37.332072300, longitude: -122.011138100)
        applePin = ActivityPin(title: "Apple Park", subtitle: "It works on the Apple HQ", coordinate: appleCoordinate, imageName: "add")

        let parkCoordinate = CLLocationCoordinate2D(latitude: 37.342226, longitude: -122.025617)
        parkPin = ActivityPin(title: "Ortega Park", subtitle: "The park", coordinate: parkCoordinate, imageName: "thumbup-click")

        activitiesPin.append(applePin)
        activitiesPin.append(parkPin)
        
        mapView.addAnnotation(applePin)
        mapView.addAnnotation(parkPin)
        
//        var pin1 = CPA()
//        pin1.coordinate = CLLocationCoordinate2DMake(37.332072300, -122.011138100)
//        pin1.title = "Apple Park"
//        pin1.subtitle = "It works on the Apple HQ"
//        pin1.imageName = "add"
//
//        var pin2 = CPA()
//        pin2.coordinate = CLLocationCoordinate2DMake(37.342226, -122.025617)
//        pin2.title = "Ortega Park"
//        pin2.subtitle = "The park"
//        pin2.imageName = "thumbup-click"
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("Did get latest location")
        guard let latestLocation = locations.first else { return }
        
        if currentCoordinate == nil {
            zoomToLatestLocation(with: latestLocation.coordinate)
            addAnnotations()
        }
        
        currentCoordinate = latestLocation.coordinate
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("Status changed")
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            beginLocationUpdates(locationManager: manager)
        }
    }
//}

//extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        print("Inside ViewFor")
        
        let annotationIdentifier = "ActivityAnnotation"

        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier)
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
            annotationView!.canShowCallout = true
            print("AnnotationView created\n\n")
        }
        
        if annotation === mapView.userLocation {
            annotationView?.image = UIImage(named: "current_user.png")
        }
        
        if let annotationView = annotationView, let _ = annotation as? ActivityPin {
            for activity in activitiesPin {
                if let title = annotation.title, title == activity.title {
                    print("\t \(activity.imageName)\n\n")
                    annotationView.image = UIImage(named: "\(activity.imageName)")
                    annotationView.canShowCallout = true
                }
            }
        }
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        print("Selected annotation: \(String(describing: view.annotation?.title))")
    }
}

//extension MapViewController: CLLocationManagerDelegate {
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        print("Did get latest location")
//        guard let latestLocation = locations.first else { return }
//
//        if currentCoordinate == nil {
//            zoomToLatestLocation(with: latestLocation.coordinate)
//            addAnnotations()
//        }
//    }
//
//    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
//        print("Status changed")
//        if status == .authorizedWhenInUse {
//            beginLocationUpdates(locationManager: manager)
//        }
//    }
//}

//extension MapViewController: MKMapViewDelegate {
//    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "AnnotationView")
//
//        if annotationView == nil {
//            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "AnnotationView")
//        }
//
//        if let title = annotation.title, title == "Apple Park" {
//            annotationView?.image = UIImage(named: "add")
//        } else if let title = annotation.title, title == "Ortega Park" {
//            annotationView?.image = UIImage(named: "thumbup-click")
//        } else if annotation === mapView.userLocation {
//            annotationView?.image = UIImage(named: "plus")
//        }
//
//        annotationView?.canShowCallout = true
//
//        return annotationView
//    }
//
//    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
//        print("Selected annotation: \(String(describing: view.annotation?.title))")
//    }
//}


//    let locationManager = CLLocationManager()
//    var mapHasCenteredOnce = false
//    var pin:ActivityPin!
//    var activityPin = MKPointAnnotation()
    //var initialLocation : CLLocation!
    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        locationManager.delegate = self
//        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
//        locationManager.requestWhenInUseAuthorization()
//        locationManager.startUpdatingLocation()
        
//        self.mapView.delegate = self
//        mapView.showsUserLocation = true
//        mapView.userTrackingMode = MKUserTrackingMode.follow
//        let initialLocation = CLLocation(latitude: 37.33467, longitude: 123.0312)
//        centerMapOnLocation(location: initialLocation)
        
        
//        activityPin.coordinate = activityCoordinate
//        activityPin.title = "Current PIN"
//        mapView.addAnnotation(activityPin)
        
        
//        let coordinateX = CLLocationCoordinate2DMake(37.3318, 122.0312)
//        pin = ActivityPin(activityName: "Apple HQ", coordinate: coordinateX)
//        activityPin.coordinate = coordinateX
//        activityPin.title = "Hello"
//        mapView.addAnnotation(activityPin)

//        print("Current location at: \n\t \(String(describing: activityPin.coordinate))")
//        mapView.delegate = self
//        determineCurrentLocation()
//    }
//
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        locationAuthStatus()
//    }
//
//    func locationAuthStatus() {
//        locationManager.delegate = self
//        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
//            mapView.showsUserLocation = true
//        } else {
//            locationManager.requestWhenInUseAuthorization()
//        }
//    }

//    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
//        if status == .authorizedWhenInUse {
//            mapView.showsUserLocation = true
//        }
//    }
//
//    func centerMapOnLocation(location: CLLocation) {
//        let zoomLevel: Double = 2000
//        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, zoomLevel, zoomLevel)
//        mapView.setRegion(coordinateRegion, animated: true)
//    }
//
//    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
//        if let loc = userLocation.location {
//            if !mapHasCenteredOnce {
//                centerMapOnLocation(location: loc)
//                mapHasCenteredOnce = true
//            }
//        }
//    }

//    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//        var annotationView: MKAnnotationView?
//        var annotationView = MKAnnotationView(annotation: pin, reuseIdentifier: "Apple HQ")
//        annotationView.image = UIImage(named: "plus")
//        if annotation.isKind(of: MKUserLocation.self) {
//            annotationView = MKAnnotationView(annotation: pin, reuseIdentifier: "Apple HQ")
//            annotationView.image = UIImage(named: "plus")
//        }
//        return annotationView
//
//        if !(annotation is MKPointAnnotation) {
//            print("NOT REGISTERED AS MKPointAnnotation")
//            return nil
//        }
//
//        // This is like a table view
//        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "activityIdentifier")
//        // If it doesn't exist
//        if annotationView == nil {
//            // Create one with the reusable identifier
//            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "activityIdentifier")
//            annotationView!.canShowCallout = true
//        } else {
//            annotationView!.annotation = annotation
//        }
//
//        annotationView!.image = UIImage(named: "add")
//
//        return annotationView
//    }

    
//    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//        let identifier = "Activity"
//        var annotationView: MKAnnotationView?
//        if annotation.isKind(of: MKUserLocation.self) {
//            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "User")
//            annotationView?.image = UIImage(named: "plus")
//        } else if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) {
//                annotationView = dequeuedView
//            annotationView?.annotation = annotation
//        } else {
//            let av = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
//            av.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
//            annotationView = av
//        }
//
//        if let annotatationView = annotationView, let anno = annotation as? ActivityPin {
//            annotationView?.canShowCallout = true
//            annotationView?.image = UIImage(named: "add")
//            let btn = UIButton()
//            btn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
//            btn.setImage(UIImage(named: "Help"), for: .normal)
//            annotationView?.rightCalloutAccessoryView = btn
//        }
//
//        return annotationView
    
    
//        if !(annotation is MKPointAnnotation) {
//            print("NOT REGISTERED AS MKPointAnnotation")
//            return nil
//        }
//
//        // This is like a table view
//        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "activityIdentifier")
//        // If it doesn't exist
//        if annotationView == nil {
//            // Create one with the reusable identifier
//            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "activityIdentifier")
//            annotationView!.canShowCallout = true
//        } else {
//            annotationView!.annotation = annotation
//        }
//
//        // change image of the annotationView
//        annotationView!.image = UIImage(named: "add")
//        return annotationView
//    }
//                view = dequeuedView as! MKAnnotationView
//            } else {

//                view.canShowCallout = true
//                view.calloutOffset = CGPoint(x: -5, y: 5)
//                view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure) as UIView
//            }
//            return view
//        }
//        return nil
//    }
    
//    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
//        let loc = CLLocation(latitude: mapView.centerCoordinate.latitude, longitude: mapView.centerCoordinate.longitude)
//        let coordinate = CLLocationCoordinate2D(latitude: 37.3318, longitude: 122.0312)
//        let anno = ActivityPin(activityName: "Apple HQ", coordinate: coordinate)
//        self.mapView.addAnnotation(anno)
//    }
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        let location = locations.last!
//        let location : CLLocation = locations[0] as CLLocation
//        locationManager.stopUpdatingLocation()
//        self.mapView.showsUserLocation = true
//        centerMapOnLocation(location: location)
//    }
    
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        print("Before location")
//        print(locations)
//        print("After location")
    
//        let userLocation : CLLocation = locations[0] as CLLocation
//        locationManager.stopUpdatingLocation()
//        let span: MKCoordinateSpan = MKCoordinateSpanMake(0.01, 0.01)
//        let lat: Double = userLocation.coordinate.latitude
//        let long: Double = userLocation.coordinate.longitude
//        let loc: CLLocationCoordinate2D = CLLocationCoordinate2DMake(lat, long)
//        let region: MKCoordinateRegion = MKCoordinateRegionMake(loc, span)
        
//        print("Latitude PRINT: \(lat) Longitude PRINT: \(long)")

//        mapView.setRegion(region, animated: true)
      
//        self.mapView.showsUserLocation = true
        
//
//        let annotation : MKPointAnnotation = MKPointAnnotation()
//        annotation.coordinate = CLLocationCoordinate2DMake(userLocation.coordinate.latitude, userLocation.coordinate.longitude)
//        annotation.title = "Current location"
//        mapView.addAnnotation(annotation)
//        let coordinate = CLLocationCoordinate2D(latitude: 37.3318, longitude: 122.0312)
//        pin = ActivityPin(activityName: "Apple HQ", coordinate: coordinate)
//        mapView.addAnnotation(pin)
//    }
    


//    func determineCurrentLocation() {
//        locationManager = CLLocationManager()
//        locationManager.delegate = self
//        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        locationManager.requestWhenInUseAuthorization()
//
//        if CLLocationManager.locationServicesEnabled() {
//            locationManager.startUpdatingLocation()
//        }
//    }

    //Write the didUpdateLocations method here: such as airplane mode, or no tracking allows
//    func locationManager(_ manager: CLLocationManager, didFailWithError error: NSError) {
//        print("Error \(error)")
//    }
//}


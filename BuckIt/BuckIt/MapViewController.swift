//
//  MapViewController.swift
//  BuckIt
//
//  Created by WilliamH on 1/23/18.
//  Copyright © 2018 Samnang Sok. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    let locationManager = CLLocationManager()
    var initialLocation : CLLocation!
    
    var mapHasCenteredOnce = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
//
//        mapView.delegate = self
//        mapView.userTrackingMode = MKUserTrackingMode.follow
//        initialLocation = CLLocation(latitude: 37.33467, longitude: -121.87533)
//        centerMapOnLocation(location: initialLocation)
    }
    
//    func locationAuthStatus() {
//        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
//            mapView.showsUserLocation = true
//        } else {
//            locationManager.requestWhenInUseAuthorization()
//            locationAuthStatus()
//        }
//    }

//    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
//        if status == .authorizedWhenInUse {
//            mapView.showsUserLocation = true
//        }
//    }

    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, 1000, 1000)
        mapView.setRegion(coordinateRegion, animated: true)
    }

//    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
//        if let loc = userLocation.location {
//            if !mapHasCenteredOnce {
//                centerMapOnLocation(location: loc)
//                mapHasCenteredOnce = true
//            }
//        }
//    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(locations)
        let location = locations[locations.count - 1]
        if location.horizontalAccuracy > 0 {
            locationManager.stopUpdatingLocation()
            
            print("longitude = \(location.coordinate.longitude), latitude = \(location.coordinate.latitude)")
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            let currentLoc = CLLocation(latitude: lat, longitude: lon)
            centerMapOnLocation(location: currentLoc)
        }
    }
    
    //Write the didUpdateLocations method here: such as airplane mode, or no tracking allows
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}

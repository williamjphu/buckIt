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
    var mapHasCenteredOnce = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        locationManager.delegate = self
        //        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        //        locationManager.requestWhenInUseAuthorization()
        //        locationManager.startUpdatingLocation()
        
//        mapView.delegate = self
//        mapView.userTrackingMode = MKUserTrackingMode.follow
    }
    
//    func locationAuthStatus() {
//        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
//            mapView.showsUserLocation = true
//        } else {
//            locationManager.requestWhenInUseAuthorization()
//        }
//    }
//
//    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
//        if status == .authorizedWhenInUse {
//            mapView.showsUserLocation = true
//        }
//    }
//
//    func centerMapOnLocation(location: CLLocation) {
//        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, 2000, 2000)
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

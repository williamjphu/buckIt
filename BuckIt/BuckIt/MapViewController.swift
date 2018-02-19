//
//  MapViewController.swift
//  BuckIt
//
//  Created by WilliamH on 1/23/18.
//  Copyright © 2018 Samnang Sok. All rights reserved.
//

import Mapbox

class MapViewController: UIViewController, MGLMapViewDelegate {

//    @IBOutlet weak var mapView: MKMapView!
//    var locationManager : CLLocationManager!
    //var initialLocation : CLLocation!
    
//    var mapHasCenteredOnce = false
    var mapboxView: MGLMapView!
//    var directionsRoute: Route?
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        locationManager.delegate = self
//        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
//        locationManager.requestWhenInUseAuthorization()
//        locationManager.startUpdatingLocation()
//
//        mapView.delegate = self
//        mapView.userTrackingMode = MKUserTrackingMode.follow
//        initialLocation = CLLocation(latitude: 37.33467, longitude: -121.87533)
//        centerMapOnLocation(location: initialLocation)
//        determineCurrentLocation()
        
        view.addSubview(mapboxView)
        mapboxView = MGLMapView(frame: view.bounds)
        
//        mapboxView.delegate = self
//        mapboxView.showsUserLocation = true
//        mapboxView.userTrackingMode(.follow, animated: true)
        //mapboxView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        //mapboxView.setCenter(CLLocationCoordinate2D(latitude: 37.33, longitude: 121.88), zoomLevel: 9, animated: false)
        //view.addSubview(mapboxView)
//        let userLocation : CLLocation = locations[0] as CLLocation
      
        
    }
    
//    func mapViewDidFinishLoadingMap(_ mapView: MGLMapView) {
//        mapboxView.setCenter((mapboxView.userLocation?.coordinate)!, animated: false)
//    }
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

//    func centerMapOnLocation(location: CLLocation) {
//        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, 1000, 1000)
//        mapView.setRegion(coordinateRegion, animated: true)
//    }

//    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
//        if let loc = userLocation.location {
//            if !mapHasCenteredOnce {
//                centerMapOnLocation(location: loc)
//                mapHasCenteredOnce = true
//            }
//        }
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
//
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        print(locations)
//        let location = locations[locations.count - 1]
//        if location.horizontalAccuracy > 0 {
//            locationManager.stopUpdatingLocation()
//
//            print("longitude = \(location.coordinate.longitude), latitude = \(location.coordinate.latitude)")
//            let lat = location.coordinate.latitude
//            let lon = location.coordinate.longitude
//            let currentLoc = CLLocation(latitude: lat, longitude: lon)
//            centerMapOnLocation(location: currentLoc)
//        }
        
//        let userLocation : CLLocation = locations[0] as CLLocation
        
        
//        locationManager.stopUpdatingLocation()
//        let center = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
//        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
//        mapView.setRegion(region, animated: true)
        
        
//        let annotation : MKPointAnnotation = MKPointAnnotation()
//        annotation.coordinate = CLLocationCoordinate2DMake(userLocation.coordinate.latitude, userLocation.coordinate.longitude)
//        annotation.title = "Current location"
//        mapView.addAnnotation(annotation)
//    }
    
    //Write the didUpdateLocations method here: such as airplane mode, or no tracking allows
//    func locationManager(_ manager: CLLocationManager, didFailWithError error: NSError) {
//        print("Error \(error)")
//    }
}

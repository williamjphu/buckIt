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
    
    var activitiesPin: Array<ActivityPin> = Array()
    
    @IBOutlet weak var mapView: MKMapView!
    
    class CPA: MKPointAnnotation {
        var imageName: String?
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
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
    
    private func fetchActivities(childName: String, imageFile: String) {
        print("fetchActivites called")
        let reference = Database.database().reference()
        reference.child("activities").child(childName).observeSingleEvent(of: .value, with: { (snap) in
            if snap.exists() {
                let activitySnap = snap.value as! [String: AnyObject]
                
                for (_,activity) in activitySnap {
                    if let title = activity["activityName"] as? String,
                        let subtitle = activity["description"] as? String,
                        let latitude = activity["latitude"] as? Double,
                        let longitude = activity["longitude"] as? Double {
                        
                        let coordinate = CLLocationCoordinate2DMake(latitude, longitude)
                        let actitivyItem = ActivityPin(title: title, subtitle: subtitle, coordinate: coordinate, imageName: imageFile)
                        
                        self.activitiesPin.append(actitivyItem)
                        self.mapView.addAnnotation(actitivyItem)
                    }
                }
            }
        })
        reference.removeAllObservers()
    }
    
    private func addAnnotations() {
        let categoriesDictionary = [ "Food" : "fried-chicken",
                                     "Music" : "music-player",
                                     "Meet-up" : "bucket",
                                     "Recreation" : "tent",
                                     "Fundraiser" : "money-bag"]
    
        for (key, value) in categoriesDictionary {
            fetchActivities(childName: "\(key)", imageFile: "\(value)")
        }
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
            for activity in activitiesPin {
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

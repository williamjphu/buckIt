//
//  FirebaseDataController.swift
//  BuckIt
//
//  Created by WilliamH on 4/14/18.
//  Copyright © 2018 Samnang Sok. All rights reserved.
//

import Foundation
import Firebase
import MapKit

class FirebaseDataContoller {
    private init() {}
    
    // This allows to have a singleton object:
    // Benefits: Establish connection once for fetching data, and avoid multiple connection
    // which can slow the application down in the future
    static let sharedInstance = FirebaseDataContoller()
    var activitiesPin = [ActivityPin]()
    
    var activitiesPinGetter: Array<ActivityPin> {
        get {
            return self.activitiesPin
        }
    }
    
    let categoriesDictionary = [ "Food" : "fried-chicken",
                                 "Music" : "music-player",
                                 "Meet-up" : "bucket",
                                 "Recreation" : "tent",
                                 "Fundraiser" : "money-bag"]

    var reference: DatabaseReference = Database.database().reference()
    var mapViewObj: MKMapView!
    
    func fetchActivitiesToTrending() {
        for (key, value) in categoriesDictionary {
            print("INSIDE fetchActivitiesToTrending")
            fetchActivities(childName: "\(key)", imageFile: "\(value)", mapObject: nil)
            print("INSIDE fetchActivitiesToTrending: \(self.activitiesPin.count)")
        }
    }
    
    func fetchActivitiesToMap() {
        for (key, value) in categoriesDictionary {
            print("INSIDE fetchActivitiesToMap")
            fetchActivities(childName: "\(key)", imageFile: "\(value)", mapObject: self.mapViewObj)
            print("INSIDE fetchActivitiesToMap: \(self.activitiesPin.count)")
        }
    }
    
    private func fetchActivities(childName: String, imageFile: String, mapObject: MKMapView?) {
        print("fetchActivites called from Singleton")
        let reference = self.reference
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
                        self.mapViewObj.addAnnotation(actitivyItem)
                    }
                }
            }
        })
        reference.removeAllObservers()
    }
    
    func printResults() {
        print("Controller \t\(self.activitiesPinGetter.count)")
    }
}

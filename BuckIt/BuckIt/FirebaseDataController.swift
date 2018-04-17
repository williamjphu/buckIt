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

var reference: DatabaseReference = Database.database().reference()

class FirebaseDataContoller {
    // This allows to have a singleton object:
    // Benefits: Establish connection once for fetching data, and avoid multiple connection
    // which can slow the application down in the future
    static let sharedInstance = FirebaseDataContoller()
    
    private let _categoriesDictionary = [ "Food" : "fried-chicken",
                                 "Music" : "music-player",
                                 "Meet-up" : "bucket",
                                 "Recreation" : "tent",
                                 "Fundraiser" : "money-bag"]

    private var _refToFirebase : DatabaseReference = reference
    
    var refToFirebase : DatabaseReference {
        return _refToFirebase
    }

    var categoriesDictionary : [String : String] {
        return _categoriesDictionary
    }
}

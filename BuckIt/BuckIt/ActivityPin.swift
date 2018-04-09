//
//  ActivityPin.swift
//  BuckIt
//
//  Created by WilliamH on 4/6/18.
//  Copyright © 2018 Samnang Sok. All rights reserved.
//

import MapKit

class ActivityPin: NSObject, MKAnnotation {
    var activityName: String?
    var coordinate = CLLocationCoordinate2D()
    
    init(activityName: String, coordinate: CLLocationCoordinate2D) {
        self.activityName = activityName
        self.coordinate = coordinate
    }
}

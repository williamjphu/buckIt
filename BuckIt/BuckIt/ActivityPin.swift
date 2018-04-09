//
//  ActivityPin.swift
//  BuckIt
//
//  Created by WilliamH on 4/6/18.
//  Copyright © 2018 Samnang Sok. All rights reserved.
//

import MapKit

// MKPointAnnotation
class ActivityPin: NSObject, MKAnnotation {
    var title: String?
    var subtitle: String?
    var coordinate: CLLocationCoordinate2D
    var imageName: String
    
    init(title: String, subtitle: String, coordinate: CLLocationCoordinate2D, imageName: String) {
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
        self.imageName = imageName
    }
}

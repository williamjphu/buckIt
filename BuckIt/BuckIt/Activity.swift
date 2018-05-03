//
//  Activity.swift
//  BuckIt
//
//  Created by Michael Hyun on 1/23/18.
//  Copyright © 2018 Samnang Sok. All rights reserved.
//

import UIKit

class Activity : NSObject {
    
    var theDescription : String?
    var pathToImage : String?
    var activityID : String?
    var title : String?
    var userID : String?
    var locationName : String?
    var latitude : Double?
    var longitude : Double?
    var category : String?
    var likes : Int?
    var peopleWhoLike: [String] = [String]()
//    init(title: String?="", description: String?="", category: String?="", pathToImage: String?="", activityID: String?="", userID: String?="", locationName: String?="") {
//        self.title = title
//        self.theDescription = description
//        self.category = category
//        self.pathToImage = pathToImage
//        self.activityID = activityID
//        self.userID = userID
//        self.locationName = locationName
//    }
}

//
//  TrendingViewController.swift
//  BuckIt
//
//  Created by Michael Hyun on 1/31/18.
//  Copyright © 2018 Samnang Sok. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase

class TrendingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    //array of activities that are displayed on the page
    var activities = [Activity]()
    
    override func viewWillAppear(_ animated: Bool) {
        activities.removeAll()
    }
    
    override func viewDidLoad() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        fetchAllActivities()
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.activities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableCell = tableView.dequeueReusableCell(withIdentifier: "activityCell", for: indexPath) as! ActivityTableViewCell
        tableCell.activityTitle.text = self.activities[indexPath.row].title
        tableCell.activityDescription.text = self.activities[indexPath.row].theDescription
        return tableCell
    }
    
    //this gets all the activities and puts it in activity array
    func fetchAllActivities(){
        let ref = Database.database().reference()
        ref.child("Activities").queryOrderedByKey().observeSingleEvent(of: .value, with: {(snap) in
            let activitySnap = snap.value as? [String: AnyObject]

            for(_,activity) in activitySnap! {
                    let theActivity = Activity()
                    if let description = activity["description"] as? String,
                        let activityID = activity["activityID"] as? String,
                        let uid = activity["userID"] as? String,
                        let pathToImage = activity["pathToImage"] as? String,
                        let title = activity["title"] as? String,
                        let location = activity["location"] as? String{

                        theActivity.theDescription = description
                        theActivity.activityID = activityID
                        theActivity.pathToImage = pathToImage
                        theActivity.title = title
                        theActivity.userID = uid
                        theActivity.location = location

                        self.activities.append(theActivity)
                    }
                    self.tableView.reloadData()
            }
        })
        ref.removeAllObservers()
    }

}

//class for the add to Bucket Page
class addToBucketViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //lists all the buckits you can add to
    @IBOutlet weak var tableView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        buckits.removeAll()
    }
    
    override func viewDidLoad() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        fetchAllBuckets()
    }
    
    //where the buckits are stored
    var buckits = [BuckIt]()
    
    func fetchAllBuckets(){
        let ref  = Database.database().reference()
        ref.child("BuckIts").queryOrderedByKey().observeSingleEvent(of: .value, with: { (snap) in
            let buckitSnap = snap.value as! [String: AnyObject]
            
            for (_,buckit) in buckitSnap {
                if let uid = buckit["userID"] as? String{
                    if uid == Auth.auth().currentUser?.uid{
                        let buckitItem = BuckIt()
                        if let description = buckit["description"] as? String,
                            let buckitID = buckit["buckitID"] as? String,
                            let pathToImage = buckit["pathToImage"] as? String,
                            let title = buckit["title"] as? String {
                            
                            buckitItem.desc = description
                            buckitItem.buckitId = buckitID
                            buckitItem.pathToImage = pathToImage
                            buckitItem.title = title
                            buckitItem.userId = uid
                            
                            self.buckits.append(buckitItem)
                        }
                        self.tableView.reloadData()
                    }
                }
            }
        })
        ref.removeAllObservers()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.buckits.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableCell = tableView.dequeueReusableCell(withIdentifier: "chooseBuckit", for: indexPath) as! chooseBuckitTableViewCell
        tableCell.buckitTitle.text = self.buckits[indexPath.row].title
        return tableCell
    }
}


















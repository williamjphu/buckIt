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
        return tableCell
    }
    
    
    func fetchAllActivities(){
        let ref = Database.database().reference()
        ref.child("Activities").queryOrderedByKey().observeSingleEvent(of: .value, with: {(snap) in
            let activitySnap = snap.value as? [String: AnyObject]
            //this gets all the activities and puts it in activity array

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
                print("THIS IS THE NUMBER: ")
                print(self.activities.count)
            }
        })
        ref.removeAllObservers()
    }

}

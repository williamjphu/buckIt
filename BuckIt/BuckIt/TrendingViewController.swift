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
import PopupDialog

class TrendingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    //array of activities that are displayed on the page
    var activities = [Activity]()
    
    override func viewDidLoad() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        fetchAllActivities()
    }
  
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "activityProfile", sender: self.activities[indexPath.row])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? ActivityProfileViewController{
            if let activity = sender as? Activity{
                destination.activity = activity
            }
        }
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
        let ref = FirebaseDataContoller.sharedInstance.refToFirebase
        ref.child("Activities").observe(.value) { (snap) in
            let activitySnap = snap.value as? [String: AnyObject]

            for(_,activity) in activitySnap! {
                    let theActivity = Activity()
                    if let description = activity["description"] as? String,
                        let activityID = activity["activityID"] as? String,
                        let uid = activity["userID"] as? String,
                        let pathToImage = activity["pathToImage"] as? String,
                        let location = activity["locationName"] as? String,
                        let title = activity["activityName"] as? String {

                        theActivity.locationName = location
                        theActivity.theDescription = description
                        theActivity.activityID = activityID
                        theActivity.pathToImage = pathToImage
                        theActivity.title = title
                        theActivity.userID = uid

                        self.activities.append(theActivity)
                    }
                    self.tableView.reloadData()
            }
        }
        ref.removeAllObservers()
    }
}

//class for the add to Bucket Page
class addToBucketViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //lists all the buckits you can add to
    @IBOutlet weak var tableView: UITableView!
    var activity = Activity()
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
//        let ref = FirebaseDataContoller.sharedInstance.refToBuckits
        let ref = FirebaseDataContoller.sharedInstance.refToFirebase
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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedBuckit = self.buckits[indexPath.row]
        let message = selectedBuckit.title
        let title = "Added to BuckIt!"
        let popup = PopupDialog(title: title, message: message)
        // Create dialogue
        let buttonOne = DefaultButton(title: "Got it") {
            print("Created Buckit")
            
            //should replace the true with upvotes
            let activityFeed = [ self.activity.activityID! : true] as [String: Any]
            
            //add to buckit
            let ref = FirebaseDataContoller.sharedInstance.refToFirebase
            ref.child("BuckIts").child(selectedBuckit.buckitId).child("Activities")
            ref.updateChildValues(activityFeed)
            
            //go back to trending page
            _ = self.navigationController?.popViewController(animated: true)
        }
        let buttonTwo = CancelButton(title: "Cancel") {
            print("You canceled the car dialog.")
            _ = self.navigationController?.popViewController(animated: true)
        }
        
        popup.addButtons([buttonOne, buttonTwo])
        
        //Present dialog
        self.present(popup, animated: true, completion: nil)
    }
    
    
}


















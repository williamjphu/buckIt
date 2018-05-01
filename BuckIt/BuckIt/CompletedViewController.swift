//
//  CompletedViewController.swift
//  BuckIt
//
//  Created by Michael Hyun on 1/31/18.
//  Copyright © 2018 Samnang Sok. All rights reserved.
//

import UIKit
import Firebase
class CompletedViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{
 
    

    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var tableView: UICollectionView!

    var completeCount = 0
    var activities = [Activity]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        activities.removeAll()
        fetchAllCompleted()
    }
    
    //this gets all the activities and puts it in activity array
    func fetchAllCompleted(){

        let ref = FirebaseDataContoller.sharedInstance.refToFirebase
        //Loop through the Activity array inside each Buckit and find the ActivityID's --> key
            let uid = Auth.auth().currentUser?.uid
        ref.child("users").child(uid!).child("Completed").observeSingleEvent(of: .value, with: {(snap) in
            //if snap.value is nil, the buckit has no activities
            if(snap.exists()){
                let completeSnap = snap.value as! [String: AnyObject]
                //for each activity inside this buckit
                for key in completeSnap.keys {
                    
                    ref.child("Activities").observeSingleEvent(of: .value, with: {(activitySnap) in
                        let snapshot = activitySnap.value as! [String: AnyObject]
                        
                        //Loop through the Activity Node and add the activities that has an activityID == key
                        for (_,activity) in snapshot{
                            //If the current Activity matches the key from the Buckit, add it
                            if activity["activityID"] as? String == key {
                                let theActivity = Activity()
                                if let description = activity["description"] as? String,
                                    //                                    let category = activity["category"] as? String,
                                    //                                    let latitude = activity["latitude"] as? String,
                                    //                                    let longitude = activity["longitude"] as? String,
                                    let activityID = activity["activityID"] as? String,
                                    let pathToImage = activity["pathToImage"] as? String,
                                    let title = activity["activityName"] as? String,
                                    let uid = activity["userID"] as? String,
                                    let location = activity["locationName"] as? String{
                                    
                                    theActivity.theDescription = description
                                    theActivity.activityID = activityID
                                    theActivity.pathToImage = pathToImage
                                    theActivity.title = title
                                    theActivity.userID = uid
                                    theActivity.locationName = location
                                    
                                    //add activity to the list
                                    self.activities.append(theActivity)
                                }
                                self.tableView.reloadData()
                            }
                        }
                    })
                }
            }
        })
        ref.removeAllObservers()
    }


    //section number
    func numberOfSections(in tableView: UICollectionView) -> Int {
        if activities.count > 0 {
            print("IT WORKS")
            tableView.backgroundView = nil
            return 1
        } else {
            tableView.backgroundView = emptyView
            return 0
        }
    }
    
    //return the number of buckit
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        completeCount = self.activities.count
        return completeCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "activityCell", for: indexPath) as! ActivityCell
        cell.activityName.text = self.activities[indexPath.row].title
        
        return cell
    }
    
    //got to activity profile when clicked
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
   
        performSegue(withIdentifier: "activityProfile", sender: self.activities[indexPath.row])
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        //if youre going to segue to the activityProfile, do this
        if let destination = segue.destination as? ActivityProfileViewController{
            if let activity = sender as? Activity{
                //send the selected activity to the activityProfile
                destination.activity = activity
            }
        }
    }

}

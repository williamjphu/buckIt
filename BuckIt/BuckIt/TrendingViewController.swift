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

class TrendingViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet var collectionView: UICollectionView!
    
    //array of activities that are displayed on the page
    var activities = [Activity]()
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        self.navigationController?.navigationBar.shadowImage = nil
    }
    
    override func viewDidLoad() {
        fetchAllActivities()
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? ActivityProfileViewController{
            if let activity = sender as? Activity{
                destination.activity = activity
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.activities.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let ref  = FirebaseDataContoller.sharedInstance.refToFirebase
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "activityCell", for: indexPath) as! ActivityCollectionViewCell
        cell.activityTitle.text = self.activities[indexPath.row].title
        cell.activityDescription.text = self.activities[indexPath.row].theDescription
        cell.activityPicture.downloadImage(from: self.activities[indexPath.row].pathToImage)
        cell.locationLabel.text = self.activities[indexPath.row].locationName
     
        //get the image and name of the person who posted the activity
        ref.child("users").child(self.activities[indexPath.row].userID!).observeSingleEvent(of: .value) { (snap) in
            let user = snap.value as! [String: AnyObject]
            cell.userPicture.downloadImage(from: user["picture"] as! String)
            cell.username.text = user["name"] as? String
        }
        
        //make the picture a circle
        cell.userPicture.layer.cornerRadius = cell.userPicture.bounds.width / 2.0
        cell.userPicture.layer.masksToBounds = true
        cell.userPicture.layer.shadowColor = UIColor.red.cgColor
        cell.userPicture.layer.shadowRadius = 2
        cell.userPicture.layer.shadowOpacity = 0.5
        cell.userPicture.layer.shadowOffset = CGSize(width: 1, height: 1)
        cell.userPicture.layer.shadowPath = UIBezierPath(roundedRect: cell.activityPicture.bounds, cornerRadius: 10).cgPath
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "activityProfile", sender: self.activities[indexPath.row])
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
                        let title = activity["activityName"] as? String,
                        let longitude = activity["longitude"] as? Double,
                        let latitude = activity["latitude"] as? Double {

                        theActivity.locationName = location
                        theActivity.theDescription = description
                        theActivity.activityID = activityID
                        theActivity.pathToImage = pathToImage
                        theActivity.title = title
                        theActivity.userID = uid
                        theActivity.latitude = latitude
                        theActivity.longitude = longitude
                        print("\n\n\tLong: \(longitude)")
                        self.activities.append(theActivity)
                    }
                    self.collectionView.reloadData()
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
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        self.navigationController?.navigationBar.shadowImage = nil
    }
    
    override func viewDidLoad() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        fetchAllBuckets()
    }
    
    //where the buckits are stored
    var buckits = [BuckIt]()
    
    func fetchAllBuckets(){
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
            ref.child("BuckIts").child(selectedBuckit.buckitId).child("Activities").updateChildValues(activityFeed)
            
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


















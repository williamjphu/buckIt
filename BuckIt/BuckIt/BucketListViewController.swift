//
//  BucketListViewController.swift
//  BuckIt
//
//  Created by Michael Hyun on 1/16/18.
//  Copyright © 2018 Samnang Sok. All rights reserved.
//

import UIKit
import SwipeCellKit
import PopupDialog
import Firebase

class BucketListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, SwipeTableViewCellDelegate {

    //call the buckit model
    var buckit = BuckIt()
    
    @IBOutlet weak var buckitTitle: UILabel!
    @IBOutlet weak var buckitDescription: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var buckitImage: UIImageView!

    var activities = [Activity]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fillActivityInfo()

        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(SwipeTableViewCell.self, forCellReuseIdentifier: "cell")

    }
    //Retrieve the title,desc,image from BuckitCell class
    func fillActivityInfo(){
        buckitTitle.text! = buckit.title!
        buckitDescription.text! = buckit.desc!
        buckitImage.downloadImage(from: buckit.pathToImage!)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        activities.removeAll()
        fetchActivities()
    }
    //send data and delegate to edit buckit
    @IBAction func editBuckitPressed(_ sender: Any) {
        performSegue(withIdentifier: "editBuckit", sender: self.buckit)
    }
    
    //Go to edit Buckit
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? BuckitEditViewController{
            if let buckit = sender as? BuckIt{
                //send the selected post to the editBuckit
                print("SENT")
                destination.buckit = buckit
            }
        }
    }
    
    //the number of items in the list
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.activities.count
    }
    
    //makes the row able to be edited
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true;
    }
    
    //creating the list items
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SwipeTableViewCell
        row.delegate = self
        
        //create label from database
        let label = UILabel(frame: CGRect(x: 140.0, y: 14.0, width: 200.0, height: 30.0))
        label.text = self.activities[indexPath.row].title
        label.tag = indexPath.row
        row.contentView.addSubview(label)
        
        return row
    }
    
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
//        delete functionality
        if orientation == .right{
            let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
                print("Deleted")
            }
            return [deleteAction]
        }
            
//        completed the activity, shows a popup dialogue
        else if orientation == .left {
            
            let addAction = SwipeAction(style: .default , title: "Complete") { action, indexPath in
                print("Complete")
                
                // Prepare the popup assets
                let title = "Completed!"
                let message = "Visit the North Pole"
//                let message = self.activities[indexPath.row].title
                let image = UIImage(named: "pexels-photo-103290")
                
                // Create the dialog
                let popup = PopupDialog(title: title, message: message, image: image)
                
                // Create buttons
                let buttonOne = CancelButton(title: "Share it!") {
                    print("You canceled the car dialog.")
                }
                let buttonTwo = DefaultButton(title: "  ", height: 60) {
                    print("Ah, maybe next time :)")
                }
                let buttonThree = DefaultButton(title: "OK", height: 60) {
                    print("Ah, maybe next time :)")
                }
                
//              Add buttons to dialog
                popup.addButtons([buttonOne, buttonTwo, buttonThree])
                
//              Present dialog
                self.present(popup, animated: true, completion: nil)
                
            }
            addAction.backgroundColor = UIColor.green
            return [addAction]
        }
        return nil
    }
    
    //This function details how the delete tab expands
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeTableOptions {
        var options = SwipeTableOptions()
        if orientation == .right{
            options.expansionStyle = .none
        }
        else if orientation == .left {
            options.expansionStyle = .selection
        }
        
        return options
    }

    func fetchActivities(){
        let ref = FirebaseDataContoller.sharedInstance.refToFirebase
        //Loop through the Activity array inside each Buckit and find the ActivityID's --> key
        ref.child("BuckIts").child(buckit.buckitId).child("Activities").observeSingleEvent(of: .value, with: {(snap) in
            //if snap.value is nil, the buckit has no activities
            if(snap.exists()){
                let buckitSnap = snap.value as! [String: AnyObject]
                //for each activity inside this buckit
                for key in buckitSnap.keys {
                    
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

}

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

class BucketListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, SwipeTableViewCellDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var activities = [Activity]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(SwipeTableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        activities.removeAll()
//        fetchActivities()
    }
    
    //the number of items in the list
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
        //      return self.activities.count
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
        let label = UILabel(frame: CGRect(x: 140.0, y: 14.0, width: 100.0, height: 30.0))
        label.text = "Visit the North Pole"
//        label.text = self.activities[indexPath.row].title
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

//    func fetchActivities(){
//        let ref = FIRDatabase.database().reference()
//        ref.child("Activities").queryOrderedByKey().observeSingleEvent(of: .value, with: {(snap) in
//            let activitySnap = snap.value as? [String: AnyObject]
//            //this gets all the activities and puts it in activity array
//
//            if (activitySnap?.count != nil){
//
//                for(_,activities) in activitySnap! {
//                    if let uid = activities["userID"] as? String{
//                        let theActivity = Activity()
//                        if let description = activity["description"] as? String,
//                            let activityID = activity["activityID"] as? String,
//                            let pathToImage = activity["pathToImage"] as? String,
//                            let title = activity["title"] as? String,
//                            let location = activity["location"] as? String{
//
//                            theActivity.theDescription = description
//                            theActivity.activityID = activityID
//                            theActivity.pathToImage = pathToImage
//                            theActivity.title = title
//                            theActivity.userID = uid
//                            theActivity.location = location
//
//                            self.activities.append(theActivity)
//                        }
                            // Need to reload data here
//                        self._____________.reloadData()
//                    }
//
//                }
//            }
//        })
//        ref.removeAllObservers()
//    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

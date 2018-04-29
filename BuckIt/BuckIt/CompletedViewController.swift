//
//  CompletedViewController.swift
//  BuckIt
//
//  Created by Michael Hyun on 1/31/18.
//  Copyright © 2018 Samnang Sok. All rights reserved.
//

import UIKit

//sub class to prevent outlets cannot be connected
class ActCell: UITableViewCell
{
    @IBOutlet weak var checkBoxImage: UIImageView!
    
    @IBOutlet weak var activityTitle: UILabel!
}

class CompletedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var tableView: UITableView!

    var activities = [Activity]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        fetchAllActivities()
    }

    
    
    
    //this gets all the activities and puts it in activity array
    func fetchAllActivities(){
        let ref = FirebaseDataContoller.sharedInstance.refToFirebase
        ref.child("Activities").observe(.value) { (snap) in
            let activitySnap = snap.value as? [String: AnyObject]
            
            for(_,activity) in activitySnap! {
                let theActivity = Activity()
                if let activityID = activity["activityID"] as? String,
                let title = activity["activityName"] as? String
                {
                    theActivity.activityID = activityID
                    theActivity.title = title
                }
                self.tableView.reloadData()
            }
        }
        ref.removeAllObservers()
    }

    //section number
    func numberOfSections(in tableView: UITableView) -> Int {
        if activities.count > 0 {
            tableView.backgroundView = nil
            return 1
        } else {
            tableView.backgroundView = emptyView
            return 0
        }
    }
    
    //return the number of buckit
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.activities.count
    }
    //
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tCell = tableView.dequeueReusableCell(withIdentifier: "activityCell", for: indexPath) as! ActivityCell
        tCell.activityName.text = self.activities[indexPath.row].title
        
        return tCell
    }
    
    
}

//
//  CompletedViewController.swift
//  BuckIt
//
//  Created by Michael Hyun on 1/31/18.
//  Copyright © 2018 Samnang Sok. All rights reserved.
//

import UIKit

class CompletedViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{
 
    

    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var tableView: UICollectionView!

    var activities = [Activity]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        fetchAllActivities()
//        fetchActivities()
    }

    
    
    
    //this gets all the activities and puts it in activity array
    func fetchAllActivities(){
        let ref = FirebaseDataContoller.sharedInstance.refToFirebase
        ref.child("Completed").observe(.value) { (snap) in
            let activitySnap = snap.value as? [String: AnyObject]

//            for(_,activity) in activitySnap! {
//                let theActivity = Activity()
//                if let title = activity["activityTitle"] as? String
//                {
//                    theActivity.title = title
//                }
//                self.tableView.reloadData()
//            }
        }
        ref.removeAllObservers()
    }

    
    //section number
    func numberOfSections(in tableView: UICollectionView) -> Int {
        if activities.count > 0 {
            tableView.backgroundView = nil
            return 1
        } else {
            tableView.backgroundView = emptyView
            return 0
        }
    }
    
    //return the number of buckit
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.activities.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "activityCell", for: indexPath) as! ActivityCell
        cell.activityName.text = self.activities[indexPath.row].title
        
        return cell
    }
    
}

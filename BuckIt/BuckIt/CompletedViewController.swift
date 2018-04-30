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

    var activities = [Complete]()
    
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
//        let ref = FirebaseDataContoller.sharedInstance.refToFirebase
//        ref.child("Complete").observe(.value) { (snap) in
//            let activitySnap = snap.value as? [String: AnyObject]
//
//            for(_,activity) in activitySnap! {
//                let theActivity = Complete()
//                print(activity)
//                if let title = activity as? String
//                {
//                    theActivity.title = title
//                self.activities.append(theActivity)
//                }
//                self.tableView.reloadData()
//            }
//        }
//        ref.removeAllObservers()
        
        let ref = FirebaseDataContoller.sharedInstance.refToFirebase
        ref.child("Complete").queryOrderedByKey().observeSingleEvent(of: .value, with: { (snap) in
            let completeSnap = snap.value as! [String: AnyObject]
            
            for (_,completed) in completeSnap {
                if let uid = completed["userId"] as? String{
                    if uid == Auth.auth().currentUser?.uid{
                        let completeItem = Complete()
                    
                        if let title = completed["activityTitle"] as? String {
                            
                            completeItem.title = title
                            
                            self.activities.append(completeItem)
                        }
                        self.tableView.reloadData()
                    }
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
        return self.activities.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "activityCell", for: indexPath) as! ActivityCell
        cell.activityName.text = self.activities[indexPath.row].title
        
        return cell
    }
    
}

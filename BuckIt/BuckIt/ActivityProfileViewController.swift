//
//  ActivityProfileViewController.swift
//  BuckIt
//
//  Created by Michael Hyun on 4/15/18.
//  Copyright © 2018 Samnang Sok. All rights reserved.
//

import UIKit
import MapKit
import Firebase

class ActivityProfileViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UITextFieldDelegate {
    
    //activity that is passed to this VC
    var activity = Activity()
    
    @IBOutlet weak var activityTitle: UILabel!
    @IBOutlet weak var activityDescription: UILabel!
    @IBOutlet weak var activityImage: UIImageView!
    @IBOutlet weak var upVoteCount: UILabel!
    @IBOutlet weak var downVoteCount: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var locationLabel: UILabel!
    
    @IBOutlet weak var userProfilePic: UIImageView!
    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet var addTipTextField: UITextField!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewWillAppear(_ animated: Bool) {
        loadUserData()
    }
    
    override func viewDidLoad() {
        fillActivityData()
        addTipTextField.delegate = self
        super.viewDidLoad()
    }
    
    //load the specific activity clicked
    func fillActivityData(){
        activityTitle.text = activity.title
        activityDescription.text = activity.theDescription
        activityImage.downloadImage(from: activity.pathToImage)
        locationLabel.text = activity.locationName
        //load location and pin on map
        print("\n\nName: \(activity.longitude)")
        print("\n\nName: \(activity.latitude)")
//        addAnnotation()
    }
    
    //fetch for the current_user to display their picture on the tips section
    func loadUserData(){
        let ref  = FirebaseDataContoller.sharedInstance.refToFirebase
        let uid = Auth.auth().currentUser?.uid
        ref.child("users").child(uid!).observeSingleEvent(of: .value) { (snap) in
            let user = snap.value as! [String: AnyObject]
            self.userProfilePic.downloadImage(from: user["picture"] as! String)
            self.userName.text = user["name"] as? String
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        performSegue(withIdentifier: "addTip", sender: self.activity)
    }
    
    func loadTips(){
        //fetch all tips here
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print("HELLO")
        //dequeue cell with identifier: tip cell
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "tipCell", for: indexPath) as! TipCollectionViewCell
        
        //        cell.tipDescription.text = "Description"
        //        cell.tipOwnerName.text = "Username"
        //        cell.tipTitle.text = "Try In-n-Out"
        return cell
    }


    //segue to choose a buckit to add the activity to
    @IBAction func addToBucketPressed(_ sender: Any) {
        performSegue(withIdentifier: "addToBuckit", sender: self.activity)
    }
    
    //send the activity to the nextVC
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? addToBucketViewController{
            if let activity = sender as? Activity{
                //send the selected buckit to the buckitlistview
                destination.activity = activity
            }
        }
        else if let destination = segue.destination as? createTipViewController{
            if let activity = sender as? Activity{
                //send the selected buckit to the buckitlistview
                destination.activity = activity
            }
        }
    }

    func addAnnotation() {
//        let span = MKCoordinateSpanMake(0.05, 0.05)
//        let lon: Double = activity.longitude!
//        let lat: Double = activity.latitude!
//        let activityLocation: CLLocationCoordinate2D = CLLocationCoordinate2DMake(lon, lat)
//        let region = MKCoordinateRegionMake(activityLocation, span)
//        mapView.setRegion(region, animated: true)
//
//        let annotation = MKPointAnnotation()
//        annotation.coordinate = activityLocation
//        annotation.title = activity.title
//        annotation.subtitle = activity.theDescription
//        mapView.addAnnotation(annotation)
    }
}

class createTipViewController : UIViewController{
    
    let ref = FirebaseDataContoller.sharedInstance.refToFirebase
    let store = FirebaseDataContoller.sharedInstance.refToStorage
    
    var activity = Activity()
    @IBOutlet var tipText: UITextView!
    
    @IBAction func backPressed(_ sender: Any) {
        self.dismiss(animated: true)
    }
    @IBAction func postTipPressed(_ sender: Any) {
        //create a Tip Node in the Database
        let uid = Auth.auth().currentUser!.uid
        let key = self.ref.child("Tips").childByAutoId().key
        let tip = ["title" : tipText.text,
                   "tipID" : key,
                   "userID" : uid] as [String : Any]
        let tipFeed = ["\(key)" : tip]
        self.ref.child("Tips").setValue(tipFeed)
        
        //need to add it to the specific Activity
        let tipID = [ key : "true" ] as [String : Any]
        let ref = self.ref.child("Activities").child(activity.activityID!).child("Tips")
        ref.updateChildValues(tipID)
        
        
        self.dismiss(animated: true)
    }
}

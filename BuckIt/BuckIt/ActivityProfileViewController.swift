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
    var tips = [Tip]()
    
    @IBOutlet weak var activityTitle: UILabel!
    @IBOutlet weak var activityDescription: UILabel!
    @IBOutlet weak var activityImage: UIImageView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var locationLabel: UILabel!
    
    @IBOutlet weak var userProfilePic: UIImageView!
    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet var addTipTextField: UITextField!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewWillAppear(_ animated: Bool) {
        loadUserData()
        tips.removeAll()
        loadTips()
        setupLikeButton()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fillActivityData()
        addTipTextField.delegate = self
       
    }
    
    override func viewWillDisappear(_ animated: Bool) {
    }
    
    //load the specific activity clicked
    func fillActivityData(){
        activityTitle.text = activity.title
        activityDescription.text = activity.theDescription
        CacheImage.getImage(withURL: URL(string: self.activity.pathToImage!)!) { image in
            self.activityImage.image = image
        }
        locationLabel.text = activity.locationName
        addAnnotation()
    }
    
    //fetch for the current_user to display their picture on the tips section
    func loadUserData(){
        let ref  = FirebaseDataContoller.sharedInstance.refToFirebase
        let uid = Auth.auth().currentUser?.uid
        ref.child("users").child(uid!).observeSingleEvent(of: .value) { (snap) in
            let user = snap.value as! [String: AnyObject]
            CacheImage.getImage(withURL: URL(string: user["picture"] as! String)!) { image in
                self.userProfilePic.image = image
                self.userProfilePic.layer.cornerRadius = self.userProfilePic.bounds.width/2
            }
            self.userName.text = user["name"] as? String
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        performSegue(withIdentifier: "addTip", sender: self.activity)
        addTipTextField.resignFirstResponder()
    }
    func setupLikeButton(){
        let ref = FirebaseDataContoller.sharedInstance.refToFirebase
        ref.child("Activities").child(activity.activityID!).observeSingleEvent(of: .value) { (snapshot) in
            if let activity = snapshot.value as? [String : AnyObject]{
                
                //the activity has some likes
                if let like = activity["likes"] as? Int{
                    self.likeCount.text = "\(like)"
                    if let people = activity["peopleWhoLike"] as? [String : AnyObject]{
                        for (id,person) in people{
                            //the user liked the activity already
                            if person as? String == Auth.auth().currentUser!.uid{
                                print("ALREADY LIKED")
                                self.likeButton.isHidden = true
                                self.unlikeButton.isHidden = false
                                return
                            }
                        }
                        //the user did not like the activity yet
                        print("NOT LIKED, BUT HAS LIKES")
                        self.likeButton.isHidden = false
                        self.unlikeButton.isHidden = true
                        return
                    }

                }
                //the activity is not liked by any users
                print("NOT LIKED YET")
                self.likeButton.isHidden = false
                self.unlikeButton.isHidden = true
                self.likeCount.text = "0"
                return
            }
        }

    }
    @IBOutlet weak var unlikeButton: UIButton!
    @IBOutlet weak var likeCount: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBAction func likePressed(_ sender: Any) {
        self.likeButton.isEnabled = false
        let ref = FirebaseDataContoller.sharedInstance.refToFirebase
        let keyToActivity = ref.child("Activities").childByAutoId().key
        
        ref.child("Activities").child(self.activity.activityID!).observeSingleEvent(of: .value) { (snapshot) in
            if let activity = snapshot.value as? [String : AnyObject] {
                let updateLikes: [String: Any] = ["peopleWhoLike/\(keyToActivity)": Auth.auth().currentUser!.uid]
                ref.child("Activities").child(self.activity.activityID!).updateChildValues(updateLikes, withCompletionBlock: { (error, reff) in
                    if error == nil {
                        ref.child("Activities").child(self.activity.activityID!).observeSingleEvent(of: .value, with: { (snap) in
                            if let properties = snap.value as? [String : AnyObject]{
                                if let likes = properties["peopleWhoLike"] as? [String : Any]{
                                    let count = likes.count
                                    self.likeCount.text = "\(count)"
                                    
                                    let update = ["likes" : count]
                                    ref.child("Activities").child(self.activity.activityID!).updateChildValues(update)
                                    self.likeButton.isHidden = true
                                    self.unlikeButton.isHidden = false
                                    self.likeButton.isEnabled = true
                                   
                                }
                            }
                        })
                    }
                })
            }
        }
        ref.removeAllObservers()
    }
    
    @IBAction func unlikePressed(_ sender: Any) {
        self.unlikeButton.isEnabled = false
        let ref = FirebaseDataContoller.sharedInstance.refToFirebase
        
        
        ref.child("Activities").child(self.activity.activityID!).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let properties = snapshot.value as? [String : AnyObject] {
                if let peopleWhoLike = properties["peopleWhoLike"] as? [String : AnyObject] {
                    for (id,person) in peopleWhoLike {
                        if person as? String == Auth.auth().currentUser!.uid {
                            ref.child("Activities").child(self.activity.activityID!).child("peopleWhoLike").child(id).removeValue(completionBlock: { (error, reff) in
                                if error == nil {
                                    ref.child("Activities").child(self.activity.activityID!).observeSingleEvent(of: .value, with: { (snap) in
                                        if let prop = snap.value as? [String : AnyObject] {
                                            if let likes = prop["peopleWhoLike"] as? [String : AnyObject] {
                                                let count = likes.count
                                                self.likeCount.text = "\(count)"
                                                ref.child("Activities").child(self.activity.activityID!).updateChildValues(["likes" : count])
                                            }else {
                                                self.likeCount.text = "0"
                                            ref.child("Activities").child(self.activity.activityID!).updateChildValues(["likes" : 0])
                                            }
                                        }
                                    })
                                }
                            })
                            
                            self.likeButton.isHidden = false
                            self.unlikeButton.isHidden = true
                            self.unlikeButton.isEnabled = true
                            break
                        }
                    }
                }
            }
            
        })
        ref.removeAllObservers()
    }
    
    func loadTips(){
        //fetch all tips here
        let ref = FirebaseDataContoller.sharedInstance.refToFirebase
        ref.child("Activities").child(activity.activityID!).child("Tips").observeSingleEvent(of: .value, with: {(snap) in
            //if snap.value is nil, the Activity has no Tips
            if(snap.exists()){
                let mysnap = snap.value as! [String: AnyObject]
                //for each Tip inside this Activity
                for key in mysnap.keys {
                    print(key)
                    ref.child("Tips").observeSingleEvent(of: .value, with: {(tipSnap) in
                        let snapshot = tipSnap.value as! [String: AnyObject]
                        
                        for (_,tip) in snapshot{
                            //If the current Tip matches the key from the Activity, add it
                            if tip["tipID"] as? String == key {
                                let theTip = Tip()
                                if let desc = tip["desc"] as? String,
                                    let userID = tip["userID"] as? String,
                                    let tipID = tip["tipID"] as? String{
                                    
                                    theTip.desc = desc
                                    theTip.tipId = tipID
                                    theTip.userId = userID
                                    //add Tip to the list
                                    self.tips.append(theTip)
                                }
                                self.collectionView.reloadData()
                            }
                        }
                    })
                }
            }
        })
        ref.removeAllObservers()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.tips.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "tipCell", for: indexPath) as! TipCollectionViewCell
        //set the text of the tip Cell
        cell.tipDescription.text = self.tips[indexPath.row].desc
        
        //get the image and name of the person who posted the tip
        let ref  = FirebaseDataContoller.sharedInstance.refToFirebase
        ref.child("users").child(self.tips[indexPath.row].userId).observeSingleEvent(of: .value) { (snap) in
            if(snap.exists()){
                let user = snap.value as! [String: AnyObject]
                CacheImage.getImage(withURL: URL(string: user["picture"] as! String)!) { image in
                    cell.tipImage.image = image
                    cell.tipImage.layer.cornerRadius = cell.tipImage.bounds.width/2
                }
                cell.tipOwnerName.text = user["name"] as? String
            }
        }
        
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

    @IBAction func getDirections(){
        let lon: Double = activity.longitude!
        let lat: Double = activity.latitude!
        let regionDistance : CLLocationDistance = 1000;
        let coordinate = CLLocationCoordinate2DMake(lat, lon)
        let regionSpan = MKCoordinateRegionMakeWithDistance(coordinate, regionDistance, regionDistance)
        let options = [MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center), MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)]
        
        let placemark = MKPlacemark(coordinate: coordinate)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = activity.locationName
        mapItem.openInMaps(launchOptions: options)
        
    }
    func addAnnotation() {
        let span = MKCoordinateSpanMake(0.075, 0.075)
        let lon: Double = activity.longitude!    
        let lat: Double = activity.latitude!
        let activityLocation: CLLocationCoordinate2D = CLLocationCoordinate2DMake(lat, lon)
        let region = MKCoordinateRegionMake(activityLocation, span)
        mapView.setRegion(region, animated: true)

        let annotation = MKPointAnnotation()
        annotation.coordinate = activityLocation
        annotation.title = activity.title
        annotation.subtitle = activity.theDescription
        mapView.addAnnotation(annotation)
    }
}

class createTipViewController : UIViewController, UITextViewDelegate{
    
    let ref = FirebaseDataContoller.sharedInstance.refToFirebase
    let store = FirebaseDataContoller.sharedInstance.refToStorage
    
    @IBOutlet weak var postButton: UIButton!
    var activity = Activity()
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        self.navigationController?.navigationBar.shadowImage = nil
    }

    
    override func viewWillDisappear(_ animated: Bool) {
    }
    //textbox for the creating the tip
    var alert: UIAlertController!
    
    @IBOutlet weak var textView: UITextView!
    //needed to dismiss the keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        textView.endEditing(true)
    }
    
    //doesnt work
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    //Need to post the tip under the Tip Node and also under the activity Node
    @IBAction func postTipPressed(_ sender: Any) {
        //if there is a tip written, add the tip
        if(textView.text != ""){
            print(textView.text)
            //create a Tip Node in the Database
            let uid = Auth.auth().currentUser!.uid
            let key = self.ref.child("Tips").childByAutoId().key
            let tip = ["desc" : textView.text,
                       "tipID" : key,
                       "userID" : uid] as [String : Any]
            let tipFeed = ["\(key)" : tip]
            self.ref.child("Tips").updateChildValues(tipFeed)
            
            //need to add it to the specific Activity
            let tipID = [ key : "true" ] as [String : Any]
            let ref = self.ref.child("Activities").child(activity.activityID!).child("Tips")
            ref.updateChildValues(tipID)
        
            self.navigationController?.popViewController(animated: true)
        }
        else{
            
            //otherwise, throw an error
            alert = UIAlertController(title: "Error",
                                          message: "Please write a Tip",
                                          preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
    }
}

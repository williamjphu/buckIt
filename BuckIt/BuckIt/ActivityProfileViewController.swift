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
            }
            self.userName.text = user["name"] as? String
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        performSegue(withIdentifier: "addTip", sender: self.activity)
        addTipTextField.resignFirstResponder()
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

class createTipViewController : UIViewController{
    
    let ref = FirebaseDataContoller.sharedInstance.refToFirebase
    let store = FirebaseDataContoller.sharedInstance.refToStorage
    
    @IBOutlet weak var postButton: UIButton!
    var activity = Activity()
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
    }
    override func viewDidLoad() {
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    //textbox for the creating the tip
    @IBOutlet var tipText: UITextView!
    var alert: UIAlertController!
    
    @IBAction func backPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //Need to post the tip under the Tip Node and also under the activity Node
    @IBAction func postTipPressed(_ sender: Any) {
        //if there is a tip written, add the tip
        if(tipText.text != ""){
            print(tipText.text)
            //create a Tip Node in the Database
            let uid = Auth.auth().currentUser!.uid
            let key = self.ref.child("Tips").childByAutoId().key
            let tip = ["desc" : tipText.text,
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

class CustomView: UIView {
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        // Get Height and Width
        let layerHeight = layer.frame.height
        let layerWidth = layer.frame.width
        // Create Path
        let bezierPath = UIBezierPath()
        //  Points
        let pointA = CGPoint(x: 0, y: 0)
        let pointB = CGPoint(x: layerWidth, y: 0)
        let pointC = CGPoint(x: layerWidth, y: layerHeight*9/10)
        let pointD = CGPoint(x: 0, y: layerHeight)
        // Draw the path
        bezierPath.move(to: pointA)
        bezierPath.addLine(to: pointB)
        bezierPath.addLine(to: pointC)
        bezierPath.addLine(to: pointD)
        bezierPath.close()
        // Mask to Path
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = bezierPath.cgPath
        layer.mask = shapeLayer
    }
}

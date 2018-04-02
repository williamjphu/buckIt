//
//  NewActivityViewController.swift
//  BuckIt
//
//  Created by Michael Hyun on 1/31/18.
//  Copyright © 2018 Samnang Sok. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import FirebaseDatabase
import FirebaseStorage
import Firebase
import UITextView_Placeholder

class NewActivityViewController: UIViewController, UINavigationControllerDelegate, UITextViewDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate {


    @IBOutlet weak var titleText: UITextView!
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var activityPic: UIImageView!
    @IBOutlet weak var descriptionText: UITextView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var useMyLocationButton: UISwitch!
    @IBOutlet weak var locationText: UITextField!
    var theCoordinates: CLLocationCoordinate2D?
    var refActivity: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTitleTextArea()
    }

    //needed to dismiss the keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        titleText.endEditing(true)
        descriptionText.endEditing(true)
        locationText.endEditing(true)
    }
    //needed to dismiss keyboard when you press return on the location text field
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.locationText.endEditing(true)
        return false
    }
    
    //add placeholders and make the profile pic circular
    func setupTitleTextArea(){
        titleText.delegate = self
        titleText.placeholder = "Add a Title..."
        
        descriptionText.delegate = self
        descriptionText.placeholder = "Add a Description..."
        
        locationText.delegate = self
        
        profilePic.layer.borderWidth = 1
        profilePic.layer.masksToBounds = false
        profilePic.layer.cornerRadius = self.profilePic.frame.height/2
        profilePic.clipsToBounds = true
    }
    
    //import an image when you click the activity pic
    @IBAction func importImage(_ sender: Any) {
        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerControllerSourceType.photoLibrary
        
        image.allowsEditing = false
        self.present(image, animated: true)
    }
    
    //image chooser functionality
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
            activityPic.layer.borderColor = UIColor.white.cgColor
            activityPic.translatesAutoresizingMaskIntoConstraints = false
            activityPic.layer.masksToBounds = true
            activityPic.image = image
        }
        else{
            print("Error")
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    /* create the post for activities made when hitting the post button */
    @IBAction func postActivity(_ sender: Any) {
        
        refActivity = Database.database().reference().child("activities")   /* reference the activities key */
        let user = Auth.auth().currentUser!.uid     /* the user ID */
        let storage = Storage.storage().reference(forURL: "gs://buckit-ed26f.appspot.com")  /* reference URL path to Firebase storage */
        let key = refActivity.childByAutoId().key   /* generate a new unique key ID */
        let imageRef = storage.child("activity").child(user).child("\(key).jpeg")   /* designate file path */
        let data = UIImageJPEGRepresentation(self.activityPic.image!, 0.6)  /* return the image as .jpg */
        
        /* upload the file to its designated path */
        let uploadTask = imageRef.putData(data!, metadata: nil) { (metadata, error) in
            imageRef.downloadURL(completion: { (url, error) in
            if error != nil { /* print the proper error */
                print(error!.localizedDescription)
                return
            }
            if let url = url {
    
                /* use textfields for input and then write data in DB */
                /* also store image in database storage */
                let activity = ["userID": user,
                                "activityID": key,
                                "title": self.titleText.text,
                                "activityImagePath": url.absoluteString,
                                "description": self.descriptionText.text ] as [String : Any]
                
                let activityFeed = ["\(key)" : activity]
                self.refActivity.updateChildValues(activityFeed)    /* write and update all values */
    
            } })
            
        }
        
    } /* end func postActivity */
    
    //locates the address specified in the location text and finds it on the mapview
    @IBAction func getLocation(_ sender: Any) {
        let location = self.locationText.text
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(location! as String) { (placemarks, error) in
            if let placemarks = placemarks {
                if placemarks.count != 0 {
                    let annotation = MKPlacemark(placemark: placemarks.first!)
                    let location = MKPlacemark(placemark: placemarks.first!).location
                    self.theCoordinates = location!.coordinate
                    
                    self.mapView.setRegion(MKCoordinateRegionMakeWithDistance(self.theCoordinates!, 2000, 2000), animated: true)
                    
                    self.mapView.addAnnotation(annotation)
                }
            }
            
        }
    }
    
    


}

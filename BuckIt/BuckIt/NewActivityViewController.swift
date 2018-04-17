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

class NewActivityViewController: UIViewController, UINavigationControllerDelegate,UITextFieldDelegate, UITextViewDelegate, UIImagePickerControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var titleText: UITextField!
    @IBOutlet weak var descriptionText: UITextView!     /* text view for description box */
    @IBOutlet weak var activityPic: UIImageView!
    @IBOutlet weak var locationText: UITextField!           /* textfield for the location */
    @IBOutlet weak var categoryTextfield: UITextField!      /* textfield for the category picker */
    
    var manager: CLLocationManager!
    var theCoordinates: CLLocationCoordinate2D?
    var selection: String?
    
    /* categories for the picker view */
    let categories = [ "Food",
                       "Music",
                       "Meet-up",
                       "Recreation",
                       "Fundraiser"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationText.delegate = self
        setupDescriptionTextArea()
        createPicker()
        pickerToolbar()
        
        //listen for keyboard events
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)

    }
    
    /* triggers a segue to the next view */
    func textFieldDidBeginEditing(_ locationText: UITextField) {
        performSegue(withIdentifier: "setLocationSegue", sender: self)
        locationText.resignFirstResponder()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categories.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categories[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selection = categories[row]
        categoryTextfield.text = selection
    }
    
    /* the scrolling screen for picker */
    func createPicker() {
        let categoryPicker = UIPickerView()
        categoryPicker.delegate = self
        categoryTextfield.inputView = categoryPicker
    }
    
    /* create toolbar for the picker */
    func pickerToolbar() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(NewActivityViewController.dismissPicker))
    
        toolbar.setItems([doneButton], animated: false)
        toolbar.isUserInteractionEnabled = true
        
        categoryTextfield.inputAccessoryView = toolbar
    } /* end pickerToolbar() */
    
    @objc func dismissPicker() {
        view.endEditing(true)
    }
    
    
    /*
     *  setup description text view
     */
    func setupDescriptionTextArea() {
        descriptionText.delegate = self
        descriptionText.placeholder = "Describe event..."
        descriptionText.textColor = UIColor.lightGray
        descriptionText.layer.borderWidth = 3.0
        descriptionText.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).cgColor
    }
    
    //NEED TO CONNECT THIS TO SOMTHING
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
    
    
    //NEED FOR FUTURE REFERENCE
    //locates the address specified in the location text and finds it on the mapview
//    @IBAction func getLocation(_ sender: Any) {
//        let location = self.locationText.text
//        let geocoder = CLGeocoder()
//        geocoder.geocodeAddressString(location! as String) { (placemarks, error) in
//            if let placemarks = placemarks {
//                if placemarks.count != 0 {
//                    let annotation = MKPlacemark(placemark: placemarks.first!)
//                    let location = MKPlacemark(placemark: placemarks.first!).location
//                    self.theCoordinates = location!.coordinate
//
//                    self.mapView.setRegion(MKCoordinateRegionMakeWithDistance(self.theCoordinates!, 2000, 2000), animated: true)
//
//                    self.mapView.addAnnotation(annotation)
//                }
//            }
//
//        }
//    }
    
    //NEED TO DO THIS
    /* get the location of the user to store into DB */
    func fetchLocation() {
        let ref = Database.database().reference()
    }
    
    /* creates new activity and stores it in the database */
    @IBAction func createActivity(_ sender: Any) {
    
        let uid = Auth.auth().currentUser!.uid
        var ref = Database.database().reference()   /* reference to the database */
        let geoRef = Database.database().reference()  /* reference to the database for location */
        let storage = Storage.storage().reference(forURL: "gs://buckit-ed26f.appspot.com")
        
        let key = ref.child("Activities").childByAutoId().key /* stores key by category */
        let imageRef = storage.child("Activities").child(uid).child("\(key).jpeg") /* store images in "Activities" DB */
        let data = UIImageJPEGRepresentation(self.activityPic.image!, 0.6)
        
        /* get location of the address by taking the coordinates. this will take the location from the locationText
           input field find use the address to pinpoint to the MKMapView */
        let address = locationText.text!    /* the location address */
        let geocoder = CLGeocoder()
        
        geocoder.geocodeAddressString(address, completionHandler: {(placemarks, error) -> Void in
            if((error) != nil){
                print("Error", error)
            }
            if let placemark = placemarks?.first {
                self.theCoordinates = placemark.location!.coordinate       /* place the point on the map */
            }
        })
        
        let uploadTask = imageRef.putData(data!, metadata: nil) { (metadata, error) in
            if error != nil {
                print(error!.localizedDescription)
                return
            }
            imageRef.downloadURL(completion: { (url, error) in
                if let url = url {
                    let feed = ["userID" : uid,
                                "pathToImage" : url.absoluteString,
                                "activityName" : self.titleText.text!,
                                "description": self.descriptionText.text!,
                                "locationName": self.locationText.text!,
                                "latitude": self.theCoordinates?.latitude,      /* location latitude */
                                "longitude": self.theCoordinates?.longitude,    /* location longitude */
                                "category": self.categoryTextfield.text!,
                                "activityID" : key] as [String : Any]
                    
                    let activityFeed = ["\(key)" : feed]
                    
                    /* update child value in category field */
                    ref.child("Activities").updateChildValues(activityFeed)
                    
                }
            })
            
            let vc = UIStoryboard(name: "TabController" , bundle: nil).instantiateViewController(withIdentifier: "tabBarVC")
            self.present(vc, animated: true, completion: nil)
            
        }

        uploadTask.resume()
        
    } /* end createActivity() */

    //needed to dismiss the keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        titleText.endEditing(true)
        descriptionText.endEditing(true)
    }
    
    //hide the keyboard function
    func hideKeyBoard()
    {
        descriptionText.resignFirstResponder()
        titleText.resignFirstResponder()
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        hideKeyBoard()
        
        return true
    }
    
    //push the UI up the keyboard is out
    @objc func keyboardWillChange(notification: Notification){
        //get the keyboard length
        guard let keyboardRect = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        if notification.name == Notification.Name.UIKeyboardWillShow || notification.name == Notification.Name.UIKeyboardWillChangeFrame{
            view.frame.origin.y = -keyboardRect.height + 100
        } else
        {
            view.frame.origin.y = 0
        }
    }
} // end class

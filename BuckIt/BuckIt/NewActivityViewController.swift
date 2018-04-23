//
//  NewActivityViewController.swift
//  BuckIt
//
//  Created by WilliamH/Josh on 4/1/18.
//  Copyright © 2018 Samnang Sok. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Firebase
import UITextView_Placeholder
import PopupDialog


protocol HandleMapSearch: class {
    func dropPinZoomIn(_ placemark:MKPlacemark)
}

class NewActivityViewController: UIViewController, UINavigationControllerDelegate,UITextFieldDelegate, UITextViewDelegate, UIImagePickerControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var manager: CLLocationManager!
    var theCoordinates: CLLocationCoordinate2D?
    var selection: String?
    var selectedPin: MKPlacemark?
    var resultSearchController: UISearchController!
    var coordinateFromMap: CLLocationCoordinate2D?
    var locationNameFromMap: String?
    var succesfulAlert: UIAlertController?
    var categories = [String]()
    
    @IBOutlet weak var titleText: UITextField!
    @IBOutlet weak var descriptionText: UITextView!
    @IBOutlet weak var activityPic: UIImageView!
    @IBOutlet weak var categoryTextfield: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var startDateField: UITextField!
    @IBOutlet weak var endDateField: UITextField!
    
    let datePicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchBar()
        setupDescriptionTextArea()
        createPicker()
        createDatePicker(pickerObject: datePicker, pickerField: startDateField, objCall: #selector(starDonePressed))
        createDatePicker(pickerObject: datePicker, pickerField: endDateField, objCall: #selector(endDonePressed))
        pickerToolbar()
        populateCategoriesArray()
        keyboardListener()
    }
    
    // Setup UIPickerVIew components
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
    
    private func setupSearchBar() {
        let locationSearchTable = storyboard!.instantiateViewController(withIdentifier: "LocationSearchTable") as! LocationSearchTable
        resultSearchController = UISearchController(searchResultsController: locationSearchTable)
        resultSearchController.searchResultsUpdater = locationSearchTable
        
        let searchBar = resultSearchController!.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = "Search for places"
        navigationItem.titleView = resultSearchController?.searchBar
        resultSearchController.hidesNavigationBarDuringPresentation = false
        resultSearchController.dimsBackgroundDuringPresentation = true
        definesPresentationContext = true
        locationSearchTable.mapView = mapView
        locationSearchTable.handleMapSearchDelegate = self
    }
    
    // Setup Picker for Categories
    private func populateCategoriesArray() {
        let categoryDictionary = FirebaseDataContoller.sharedInstance.categoriesDictionary
        for (key, _) in categoryDictionary {
            self.categories.append("\(key)")
        }
    }
    
    /* the scrolling screen for picker */
    private func createPicker() {
        let categoryPicker = UIPickerView()
        categoryPicker.delegate = self
        categoryTextfield.inputView = categoryPicker
    } /* end createPicker() */
    
    /* create toolbar for the picker */
    private func pickerToolbar() {
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
    
    private func createDatePicker(pickerObject: UIDatePicker, pickerField: UITextField, objCall: Any) {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        // done button for Toolbar
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: objCall as! Selector)
        toolbar.setItems([done], animated: false)
        
        pickerField.inputAccessoryView = toolbar
        pickerField.inputView = pickerObject
        
        // Format picker for date
        pickerObject.datePickerMode = .dateAndTime
    }
    
    @objc func starDonePressed() {
        startDateDonePressed(pickerObject: datePicker, pickerField: startDateField)
    }
    
    @objc func endDonePressed() {
        startDateDonePressed(pickerObject: datePicker, pickerField: endDateField)
    }
    
    private func startDateDonePressed(pickerObject: UIDatePicker, pickerField: UITextField) {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        let dateString = formatter.string(from: pickerObject.date)
        
        pickerField.text = "\(dateString)"
        self.view.endEditing(true)
    }
    
    // Setup text area
    private func setupDescriptionTextArea() {
        descriptionText.delegate = self
        descriptionText.placeholder = "Describe your activity..."
        descriptionText.textColor = UIColor.black
        descriptionText.layer.borderWidth = 0.5
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
    
    /* creates new activity and stores it in the database */
    @IBAction func createActivity(_ sender: Any) {
        var emptyText: UIAlertController
        guard titleText.text != "", activityPic.image != nil, categoryTextfield.text != nil
            else {
                // alert the user when fields are empty
                if( (titleText.text?.isEmpty)! && (activityPic.image == nil) && (categoryTextfield.text?.isEmpty)!) {
                    emptyText = UIAlertController(title: "Error",
                                                  message: "Please fill in all the fields",
                                                  preferredStyle: UIAlertControllerStyle.alert)
                    emptyText.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                    self.present(emptyText, animated: true)
                } else if ((titleText.text?.isEmpty)!)
                {
                    emptyText = UIAlertController(title: "Error",
                                                  message: "Please fill out the event name",
                                                  preferredStyle: UIAlertControllerStyle.alert)
                    emptyText.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                    self.present(emptyText, animated: true)
                }
                else if (activityPic.image == nil)
                {
                    emptyText = UIAlertController(title: "Error",
                                                  message: "Please upload the picture",
                                                  preferredStyle: UIAlertControllerStyle.alert)
                    emptyText.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                    self.present(emptyText, animated: true)
                }else if ((categoryTextfield.text?.isEmpty)!)
                {
                    emptyText = UIAlertController(title: "Error",
                                                  message: "Please select the category",
                                                  preferredStyle: UIAlertControllerStyle.alert)
                    emptyText.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                    self.present(emptyText, animated: true)
                }
                // NEED TO CHECK FOR MAP PINPOINT
                return
        }

        let uid = Auth.auth().currentUser!.uid
        let ref = FirebaseDataContoller.sharedInstance.refToFirebase  /* reference to the database */
        let storage = FirebaseDataContoller.sharedInstance.refToStorage
        
        let key = ref.child("Activities").child(categoryTextfield.text!).childByAutoId().key /* stores key by category */
        let imageRef = storage.child("Activities").child(uid).child("\(key).jpeg") /* store images in "Activities" DB */
        let data = UIImageJPEGRepresentation(self.activityPic.image!, 0.6)
    
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
                                "locationName": self.locationNameFromMap ?? "N/A",
                                "latitude": self.coordinateFromMap?.latitude ?? "N/A",
                                "longitude": self.coordinateFromMap?.longitude ?? "N/A",
                                "category": self.categoryTextfield.text!,
                                "startDate": self.startDateField.text!,
                                "endDate": self.endDateField.text!,
                                "activityID" : key] as [String : Any]
                    let activityFeed = ["\(key)" : feed]
                    
                    /* update child value in category field */
                    ref.child("Activities").updateChildValues(activityFeed)
                }
            })
            
            let title = "Created Activity!"
            let message = "Your activity was succesfully added"
            let popup = PopupDialog(title: title, message: message)
            // Create buttons
            let buttonOne = DefaultButton(title: "Got it!", height: 60) {
                print("Activity added to Firebase")
                // Show the main profile when this is completed
                let vc = UIStoryboard(name: "TabController" , bundle: nil).instantiateViewController(withIdentifier: "tabBarVC")
                self.present(vc, animated: true, completion: nil)
            }
            //Add buttons to dialog
            popup.addButtons([buttonOne])
            
            //Present dialog
            self.present(popup, animated: true, completion: nil)
        }
        uploadTask.resume()
    } /* end createActivity() */

    //listen for keyboard events
    private func keyboardListener() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    }
    
    //needed to dismiss the keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        titleText.endEditing(true)
        descriptionText.endEditing(true)
    }
    
    //hide the keyboard function
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        descriptionText.resignFirstResponder()
        titleText.resignFirstResponder()
        self.categoryTextfield.resignFirstResponder()
        return true
    }
    //push the UI up the keyboard is out
    @objc func keyboardWillChange(notification: Notification){
        //get the keyboard length
        guard let keyboardRect = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        if notification.name == Notification.Name.UIKeyboardWillShow || notification.name == Notification.Name.UIKeyboardWillChangeFrame{
            view.frame.origin.y = -keyboardRect.height + 48
        } else
        {
            view.frame.origin.y = 0
        }
    }
}

// Use extension for protocol and delegate dropPinZoomI()
extension NewActivityViewController: HandleMapSearch {
    func dropPinZoomIn(_ placemark: MKPlacemark){
        // clear existing pins
        mapView.removeAnnotations(mapView.annotations)
        // Create a new pin
        let annotation = MKPointAnnotation()
        annotation.coordinate = placemark.coordinate
        annotation.title = placemark.name
        // Setup the subtitle on the annotation
        if let city = placemark.locality,
            let state = placemark.administrativeArea {
            annotation.subtitle = "\(city) \(state)"
        }
        // Update values for variable
        coordinateFromMap = placemark.coordinate
        locationNameFromMap = placemark.name
        // Add annotation to the map within the defined region
        mapView.addAnnotation(annotation)
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegionMake(placemark.coordinate, span)
        mapView.setRegion(region, animated: true)
    }
}

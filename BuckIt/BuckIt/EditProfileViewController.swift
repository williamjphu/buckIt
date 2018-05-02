//
//  EditProfileViewController.swift
//  BuckIt
//
//  Created by Samnang Sok on 1/18/18.
//  Copyright © 2018 Samnang Sok. All rights reserved.
//
import UIKit
import Firebase

class EditProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    let ref = FirebaseDataContoller.sharedInstance.refToFirebase
    let store = FirebaseDataContoller.sharedInstance.refToStorage
    let picker = UIImagePickerController()
    
    @IBOutlet weak var imageView: UIImageView!
        
    @IBOutlet weak var descriptionText: UITextField!
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var userNameText: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var formView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
        
        //round edges for the save button
        saveButton.layer.cornerRadius = 5
        formView.layer.cornerRadius = 5
        
        //listen for keyboard events
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        
        //maximize text input to 80 character
        descriptionText.delegate = self
        userNameText.delegate = self
        nameText.delegate = self
        
        //retrieve data from Firebase
        let ref  = FirebaseDataContoller.sharedInstance.refToFirebase
        ref.child("users").queryOrderedByKey().observeSingleEvent(of: .value, with: {snapshot in
            let users = snapshot.value as! [String: AnyObject]
            
            for(_, value) in users {
                if let uid = value["uid"] as? String {
                    if uid == Firebase.Auth.auth().currentUser!.uid{
                        
                        self.nameText.text = value["name"] as? String
                        self.userNameText.text = value["username"] as? String
                        self.descriptionText.text = value["description"] as? String
                        CacheImage.getImage(withURL: URL(string: value["picture"] as! String)!) { image in
                            self.imageView.image = image
                        }
//                        self.imageView.downloadImage(from: value["picture"] as! String)
                        self.imageView.layer.cornerRadius = self.imageView.bounds.width / 2.0
                        self.imageView.layer.masksToBounds = true
                    }
                }
            }
        })
        ref.removeAllObservers()
    }
    
    deinit {
        //stop listening for keyboard hide/show events
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    }
    
    
    //change image
    @IBAction func changeImagePressed(_ sender: Any) {
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        
        present(picker, animated: true, completion: nil)
        hideKeyBoard()

    }
    
    //change image
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage{
            self.imageView.image = image
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    //maximize text input to 80 character
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let newLength = text.count + string.count - range.length
        return newLength <= 45 // Bool
    }

    
    
    //Override the edit data to the database
    @IBAction func saveChange(_ sender: Any) {
        hideKeyBoard()
        var emptyText: UIAlertController
        //alert user if username is empty
        guard userNameText.text != ""
            else {
                // alert the user when fields are empty
                if( (userNameText.text?.isEmpty)!) {
                    emptyText = UIAlertController(title: "Error",
                                                  message: "Please fill in the username",
                                                  preferredStyle: UIAlertControllerStyle.alert)
                    emptyText.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                    self.present(emptyText, animated: true)
                }
                return
        }
        
        
        let uid = Firebase.Auth.auth().currentUser!.uid
        let imageRef = self.store.child("profile").child("\(uid).jpg")
        let data = UIImageJPEGRepresentation(self.imageView.image!, 0.5)
        let usersReference = self.ref.child("users").child(uid)
        
        let uploadTask = imageRef.putData(data!, metadata: nil, completion: { (metadata, err) in
            imageRef.downloadURL(completion: { (url, er) in
                if er != nil
                {
                    print(er!.localizedDescription)
                }
                if let url = url
                {
                    let values = ["username": self.userNameText.text,
                                  "picture": url.absoluteString,
                                  "name": self.nameText.text,
                    "description": self.descriptionText.text] as [String : Any]
                    usersReference.updateChildValues(values)
                    self.navigationController?.popToRootViewController(animated: true)
                }
            })
        })
    }
    
    //needed to dismiss the keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        nameText.endEditing(true)
        descriptionText.endEditing(true)
        userNameText.endEditing(true)
    }
    
    //hide the keyboard function
    func hideKeyBoard()
    {
        descriptionText.resignFirstResponder()
        nameText.resignFirstResponder()
        userNameText.resignFirstResponder()
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
}

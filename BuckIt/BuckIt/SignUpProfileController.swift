//
//  SignUpProfileController.swift
//  BuckIt
//
//  Created by Joshua Ventocilla on 2/1/18.
//  Copyright © 2018 Samnang Sok. All rights reserved.
//

import UIKit
import Firebase
class SignUpProfileController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let picker = UIImagePickerController()
    var store = FirebaseDataContoller.sharedInstance.refToStorage
    let ref = FirebaseDataContoller.sharedInstance.refToFirebase
    @IBOutlet var profilePicture: UIImageView!
    @IBOutlet var usernameTextField: UITextField!
    
    //let userNameTextField = UITextField(frame: CGRect(x: 150, y: 150, width: 300, height: 30))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
    }
    
    @IBAction func choosePicturePressed(_ sender: Any) {
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        
        present(picker, animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage{
            self.profilePicture.image = image
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func submitPressed(_ sender: Any) {
        let uid = Firebase.Auth.auth().currentUser!.uid
        guard usernameTextField.text != ""
            else {
                // alert the user when fields are empty
                let alert = UIAlertController(title: "Error",
                                                  message: "Please choose a username",
                                                  preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                self.present(alert, animated: true)
                return
        }
        guard profilePicture.image != nil
            else{
                // alert the user when fields are empty
                let alert = UIAlertController(title: "Error",
                                              message: "Please choose a profile picture",
                                              preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                self.present(alert, animated: true)
                return
        }
        
        
        let imageRef = self.store.child("profile").child("\(uid).jpg")
        let data = UIImageJPEGRepresentation(self.profilePicture.image!, 0.5)
        let uploadTask = imageRef.putData(data!, metadata: nil, completion: { (metadata, err) in
            
            if err != nil{
                print(err!.localizedDescription)
            }
            imageRef.downloadURL(completion: { (url, er) in
                if er != nil
                {
                    print(er!.localizedDescription)
                }
                if let url = url
                {
                    let picture = ["picture": url.absoluteString]
                    let username = ["username": self.usernameTextField.text!]
                    self.ref.child("users").child(uid).updateChildValues(picture)
                    self.ref.child("users").child(uid).updateChildValues(username)
                
                    let vc = UIStoryboard(name: "TabController" , bundle: nil).instantiateViewController(withIdentifier: "tabBarVC")
                    
                    self.present(vc, animated: true, completion: nil)
                }
                
            })
        })
        
        uploadTask.resume()
    }
    
    //needed to dismiss the keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        usernameTextField.endEditing(true)
    }
    
}


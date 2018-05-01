//
//  SignUpController.swift
//  BuckIt
//
//  Created by Joshua Ventocilla on 1/22/18.
//  Copyright © 2018 Samnang Sok. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import FBSDKLoginKit
import GoogleSignIn

//@IBDesignable extension UIButton {
//    
//    @IBInspectable var borderWidth: CGFloat {
//        set {
//            layer.borderWidth = newValue
//        }
//        get {
//            return layer.borderWidth
//        }
//    }
//    
//    @IBInspectable var cornerRadius: CGFloat {
//        set {
//            layer.cornerRadius = newValue
//        }
//        get {
//            return layer.cornerRadius
//        }
//    }
//    
//    @IBInspectable var borderColor: UIColor? {
//        set {
//            guard let uiColor = newValue else { return }
//            layer.borderColor = uiColor.cgColor
//        }
//        get {
//            guard let color = layer.borderColor else { return nil }
//            return UIColor(cgColor: color)
//        }
//    }
//    
//}

class SignUpController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    //firebase storing
    let ref = FirebaseDataContoller.sharedInstance.refToFirebase
    let picker = UIImagePickerController()
    var store = FirebaseDataContoller.sharedInstance.refToStorage
    
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var confirmTextField: UITextField!
    
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
    
    @IBAction func createAccountPressed(_ sender: Any) {
        //if all fields are not filled out, display an alert
        if(nameTextField.text == "" || emailTextField.text == "" || passwordTextField.text == "" || confirmTextField.text == "" || usernameTextField.text == ""){
            // alert the user when fields are empty
            let emptyText = UIAlertController(title: "Error",
                                              message: "Please fill in all the fields",
                                              preferredStyle: UIAlertControllerStyle.alert)
            emptyText.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            self.present(emptyText, animated: true)
            return
        }
        //if passwords do not match, display alert
        else if passwordTextField.text != confirmTextField.text
        {
            // alert the user when fields are empty
            let emptyText = UIAlertController(title: "Error",
                                              message: "Passwords do not match",
                                              preferredStyle: UIAlertControllerStyle.alert)
            emptyText.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            self.present(emptyText, animated: true)
            return
            
        }
        else if profilePicture.image == nil
        {
            // alert the user when fields are empty
            let alert = UIAlertController(title: "Error",
                                          message: "Please choose a profile picture",
                                          preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            self.present(alert, animated: true)
            return
        }
        else{
            Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
                if error != nil {
                    // alert the user when fields are empty
                    let alert = UIAlertController(title: "Error",
                                                  message: error!.localizedDescription,
                                                  preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                    self.present(alert, animated: true)
                    return
                }
                print("You have successfully signed up")
                guard let uid = user?.uid else {
                    return
                }
                let imageName = NSUUID().uuidString
                let storage = Storage.storage().reference().child("ProfilePictures").child("\(imageName).png")
                
                if let uploadData = UIImagePNGRepresentation(self.profilePicture.image!){
                    storage.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                        if error != nil{
                            print(error ?? "")
                            return
                        }
                        
                        if let profilePicture = metadata?.downloadURL()?.absoluteString{
                            let userInfo: [String: Any] = ["uid": user!.uid,
                                                           "name": self.nameTextField.text!,
                                                           "email": self.emailTextField.text!,
                                                           "username": self.usernameTextField.text!,
                                                           "picture": profilePicture]
                            let userReference = self.ref.child("users").child(uid)
                            userReference.updateChildValues(userInfo) { (error, ref) in
                                if error != nil{
                                    print(error ?? "")
                                    return
                                }
                            }
                            
                            let vc = UIStoryboard(name: "TabController" , bundle: nil).instantiateViewController(withIdentifier: "tabBarVC")
                            self.present(vc, animated: true, completion: nil)                        }
                        
                        
                    })
                }
                
            }

        }
    }
    
    
}


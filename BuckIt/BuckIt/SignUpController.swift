//
//  SignUpController.swift
//  BuckIt
//
//  Created by Joshua Ventocilla on 1/22/18.
//  Copyright © 2018 Samnang Sok. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit
import GoogleSignIn

class SignUpController: UIViewController {
    //firebase storing
    let ref = FirebaseDataContoller.sharedInstance.refToFirebase
    
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var confirmTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    

    @IBAction func createAccountPressed(_ sender: Any) {
        //if all fields are not filled out, display an alert
        if(nameTextField.text == "" || emailTextField.text == "" || passwordTextField.text == "" || confirmTextField.text == ""){
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
            
        } else{
            //CREATE A USER
            Firebase.Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!, completion: { (user, error) in
                if let user = user{
                    let userInfo: [String: Any] = ["uid": user.uid,
                                                   "name": self.nameTextField.text!,
                                                   "email": self.emailTextField.text!]
                    self.ref.child("users").child(user.uid).setValue(userInfo)
                }
            })
            performSegue(withIdentifier: "choosePicture", sender: self)
        }
        
    }
    
    
    @objc func handleRegister() {
        

    }
    
    
    //needed to dismiss the keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        nameTextField.endEditing(true)
        emailTextField.endEditing(true)
        passwordTextField.endEditing(true)
        confirmTextField.endEditing(true)
    }
    
    
    
}


//
//  LoginController.swift
//  BuckIt
//
//  Created by Joshua Ventocilla on 1/18/18.
//  Copyright © 2018 Samnang Sok. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit
import GoogleSignIn

class LoginController: UIViewController {
    
    @IBOutlet var userNameText: UITextField!
    @IBOutlet var passwordText: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Display Google and Facebook login
 
    }

    /****
     ** Handle logging in. Make sure the credentials are correct and
     ** alerts the user when fields are empty or when credentials are
     ** incorrect.
     ****/
    @IBAction func loginButtonPressed(_ sender: Any) {
        view.endEditing(true)
        
        // alert the user when email or password is empty
        if( (userNameText.text?.isEmpty)! || (passwordText.text?.isEmpty)! ) {
            let emptyText = UIAlertController(title: "Error",
                                              message: "Enter email or password",
                                              preferredStyle: UIAlertControllerStyle.alert)
            emptyText.addAction(UIAlertAction(title: "Dismiss",
                                              style: .default,
                                              handler: nil))
            self.present(emptyText, animated: true)
        }
        
        // authenticate the user
        Auth.auth().signIn(withEmail: userNameText.text!, password: passwordText.text!, completion:
        { (user, error) in
            if error == nil {
                print("User logged in")//print for testing purposes
                let vc = UIStoryboard(name: "TabController" , bundle: nil).instantiateViewController(withIdentifier: "tabBarVC")
                self.present(vc, animated: true, completion: nil)
            }
                
            //login FAILED
            else{
                let alert2 = UIAlertController(title: "Error",
                                               message: "Incorrect user name or password. Please try again",
                                               preferredStyle: UIAlertControllerStyle.alert)
                // dismiss alert when pressed
                alert2.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                self.present(alert2, animated: true)
            }
        })
    }
}




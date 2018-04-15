////
////  HomeViewController.swift
////  BuckIt
////
////  Created by Samnang Sok on 11/4/17.
////  Copyright © 2017 Samnang Sok. All rights reserved.
////

import UIKit
import GoogleSignIn
import FBSDKLoginKit
import Firebase

class SettingsController: UIViewController{
    
    
    @IBAction func didTapSignOut(sender: AnyObject) {
        
        
        if Auth.auth().currentUser != nil {
            GIDSignIn.sharedInstance().signOut()
            let loginManager = FBSDKLoginManager()
            loginManager.logOut()
            let firebaseAuth = Auth.auth()
            do {
                try firebaseAuth.signOut()
            } catch let signOutError as NSError {
                print ("Error signing out: %@", signOutError)
            }
            
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Login")
            present(vc, animated: true, completion: nil)
            
        }
        
        
    }
}

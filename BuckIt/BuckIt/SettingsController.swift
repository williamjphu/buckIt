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
            do {
                try
                    GIDSignIn.sharedInstance().signOut()
                    let loginManager = FBSDKLoginManager()
                    loginManager.logOut()
                    let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Login")
                present(vc, animated: true, completion: nil)
                
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
        
        
        
//        self.performSegue(withIdentifier: "login", sender: self)
    }
    
//
//
//    /*
//    // MARK: - Navigation
//
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destinationViewController.
//        // Pass the selected object to the new view controller.
//    }
//    */
//
}


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

class HomeViewController: UIViewController{

    @IBAction func didTapSignOut(sender: AnyObject) {
        GIDSignIn.sharedInstance().signOut()
        let loginManager = FBSDKLoginManager()
        loginManager.logOut()
        self.performSegue(withIdentifier: "login", sender: self)
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


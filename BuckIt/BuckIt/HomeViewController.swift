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

// THIS IS THE SETTINGS PAGE
class HomeViewController: UIViewController{

    @IBAction func didTapSignOut(sender: AnyObject) {
        GIDSignIn.sharedInstance().signOut()
        let loginManager = FBSDKLoginManager()
        loginManager.logOut()
        self.performSegue(withIdentifier: "login", sender: self)
    }
    
    @IBAction func next(sender: UIButton) {
        let storyboard = UIStoryboard(name: "Profile", bundle: nil)
        var controller = storyboard.instantiateViewController(withIdentifier:"InitialControllerInitialController") as UIViewController
        
        self.present(controller, animated: true, completion: nil)
    }
   
}


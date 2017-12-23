//
//  ViewController.swift
//  BuckIt
//
//  Created by Samnang Sok on 11/4/17.
//  Copyright © 2017 Samnang Sok. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import GoogleSignIn

class ViewController: UIViewController , FBSDKLoginButtonDelegate, GIDSignInUIDelegate{
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupFacebookButton()
        
        setupGoogleButton()
        
    }
    
    fileprivate func setupFacebookButton(){
        //Draw Facebook sign in button
        let loginButton = FBSDKLoginButton()
        view.addSubview(loginButton)
        loginButton.frame = CGRect(x: 16, y: 50, width: view.frame.width - 32, height: 50)
        loginButton.delegate = self
    }
    
    fileprivate func setupGoogleButton(){
        //Draw Google sign in button
        let googleButton = GIDSignInButton()
        googleButton.frame = CGRect(x: 16, y: 50+66, width: view.frame.width - 32, height: 50)
        view.addSubview(googleButton)
        
        GIDSignIn.sharedInstance().uiDelegate = self
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if FBSDKAccessToken.current() != nil {
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "showHome", sender: self)
            }
        }

    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if error != nil {
            print(error)
            return
        } else if FBSDKAccessToken.current() == nil {
            //welcomeMessage.text = "Authentication was canceled"
        }
        else if error == nil {
            print("Successfully logged in via facebook")
            self.performSegue(withIdentifier: "showHome", sender: self)
        }
    }
    

    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("Logged out of Facebook")
    }


}


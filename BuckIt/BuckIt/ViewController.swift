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

// THIS WILL BE THE LOGIN PAGE

class ViewController: UIViewController {
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Change background
        view.backgroundColor = UIColor(r: 255, g: 255, b: 255)
        view.addSubview(registerButton)
        view.addSubview(alreadyUserButton)
        view.addSubview(logoImage)
        
        
        // Layout constraints
        setupBuckitLogo()
        setupRegisterButton()
        setupAlreadyUserButton()
        
        // setupFacebookButton()
        
        // setupGoogleButton()
        
    }
    
    /**
     *  Draw the BuckIt Logo
     **/
    let logoImage: UIImageView = {
        let logo = UIImageView()
        logo.image = UIImage(named: "Buckit")
        logo.translatesAutoresizingMaskIntoConstraints = false
        return logo
    }()
    
    /**
     *  Draw the Register button
     **/
    let registerButton: UIButton = {
        
        let signUpButton = UIButton(type: .system)
        signUpButton.backgroundColor = UIColor(r: 247, g: 146, b: 30)
        signUpButton.setTitle("SIGNUP", for: [])
        signUpButton.translatesAutoresizingMaskIntoConstraints = false
        signUpButton.setTitleColor(UIColor.white, for: [])
        signUpButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 24)
        signUpButton.layer.borderWidth = 1
        signUpButton.layer.borderColor = UIColor.clear.cgColor
        signUpButton.layer.cornerRadius = 5
        
        return signUpButton
    }()
    
    /**
     *  Draw Already Member button
     **/
    let alreadyUserButton: UIButton = {
        
        let registered = UIButton(type: .system)
        registered.backgroundColor = UIColor(r: 255, g: 255, b: 255)
        registered.setTitle("ALREADY A MEMBER? LOGIN", for: [])
        registered.translatesAutoresizingMaskIntoConstraints = false
        registered.setTitleColor(UIColor.orange, for: [])
        registered.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        registered.layer.borderWidth = 1
        registered.layer.borderColor = UIColor.clear.cgColor
        registered.layer.cornerRadius = 5
        
        return registered
    }()
    
    /**
     *  Layout for the logo
     **/
    func setupBuckitLogo() {
        
        logoImage.centerXAnchor.constraint(equalTo:
            view.centerXAnchor).isActive = true
        logoImage.topAnchor.constraint(equalTo:
            view.topAnchor, constant: 158).isActive = true
        logoImage.widthAnchor.constraint(equalTo:
            view.widthAnchor, constant: -24).isActive = true
        logoImage.heightAnchor.constraint(equalToConstant: 150).isActive
            = true
  
    }
    
    /**
     *  Layout for the "REGISTER" button
     **/
    func setupRegisterButton() {
        
        // set x, y, width, height constraints
        registerButton.centerXAnchor.constraint(equalTo:
            view.centerXAnchor).isActive = true
        registerButton.bottomAnchor.constraint(equalTo:
            view.bottomAnchor, constant: -45).isActive = true
        registerButton.widthAnchor.constraint(equalTo:
            view.widthAnchor, constant: -24).isActive = true
        registerButton.heightAnchor.constraint(equalToConstant: 45).isActive
            = true
    }
    
    /**
     *  Layout for the "ALREADY MEMEBER" button
     **/
    func setupAlreadyUserButton() {
        
        // set x, y, width, height constraints
        alreadyUserButton.centerXAnchor.constraint(equalTo:
            view.centerXAnchor).isActive = true
        alreadyUserButton.bottomAnchor.constraint(equalTo:
            view.bottomAnchor, constant: -95).isActive = true
        alreadyUserButton.widthAnchor.constraint(equalTo:
            view.widthAnchor, constant: -24).isActive = true
        alreadyUserButton.heightAnchor.constraint(equalToConstant: 25).isActive
            = true
    }
    /*
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
    */

}

// Create UIColor RGB object
extension UIColor {
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
}


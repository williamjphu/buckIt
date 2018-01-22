//
//  LoginController.swift
//  BuckIt
//
//  Created by Joshua Ventocilla on 1/18/18.
//  Copyright © 2018 Samnang Sok. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import GoogleSignIn

class LoginController: UIViewController, FBSDKLoginButtonDelegate, GIDSignInUIDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        view.addSubview(inputsContainerView)
        view.addSubview(signinButton)
        
        
        // Display Google and Facebook login
        setupFacebookButton()
        setupGoogleButton()
        setupInputsContainer()
        setupSigninButton()
        
    }
    
    let inputsContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()
    
    /*
     *
     */
    func setupInputsContainer() {
        inputsContainerView.centerXAnchor.constraint(equalTo:
            view.centerXAnchor).isActive = true
        inputsContainerView.centerYAnchor.constraint(equalTo:
            view.centerYAnchor).isActive = true
        inputsContainerView.widthAnchor.constraint(equalTo:
            view.widthAnchor, constant: -24).isActive = true
        inputsContainerView.heightAnchor.constraint(equalToConstant:
            100).isActive = true
    }
    
    let signinButton: UIButton = {
       
        let signin = UIButton(type: .system)
        signin.backgroundColor = UIColor(r: 247, g: 146, b: 30)
        signin.setTitle("SIGN IN", for: [])
        signin.translatesAutoresizingMaskIntoConstraints = false
        signin.setTitleColor(UIColor.white, for: [])
        signin.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        signin.layer.borderWidth = 1
        signin.layer.borderColor = UIColor.clear.cgColor
        signin.layer.cornerRadius = 5
        
        return signin
    }()
    
    func setupSigninButton() {
        
        // set x, y, width, height constraints
        signinButton.centerXAnchor.constraint(equalTo:
            view.centerXAnchor).isActive = true
        signinButton.bottomAnchor.constraint(equalTo:
            view.bottomAnchor, constant: -45).isActive = true
        signinButton.widthAnchor.constraint(equalTo:
            view.widthAnchor, constant: -24).isActive = true
        signinButton.heightAnchor.constraint(equalToConstant: 45).isActive
            = true
        
    }
    
    /*
     *  Login button for Facebook login
     */
    fileprivate func setupFacebookButton() {
        //Draw Facebook sign in button
        let loginButton = FBSDKLoginButton()
        loginButton.frame = CGRect(x: 15, y: 85, width: view.frame.width - 32, height: 50)
        loginButton.delegate = self as! FBSDKLoginButtonDelegate
        view.addSubview(loginButton)
    }
 
    
    /*
     *  Login button for Gmail login
     */
    fileprivate func setupGoogleButton(){
        
        //Draw Google sign in button
        let googleButton = GIDSignInButton()
        googleButton.frame = CGRect(x: 15, y: 145, width: view.frame.width - 32, height: 50)
        GIDSignIn.sharedInstance().uiDelegate = self as! GIDSignInUIDelegate
        view.addSubview(googleButton)
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        if FBSDKAccessToken.current() != nil
        {
            DispatchQueue.main.async
            {
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



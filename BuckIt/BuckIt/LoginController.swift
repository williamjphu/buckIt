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

class LoginController: UIViewController, FBSDKLoginButtonDelegate, GIDSignInUIDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // back button
       
        
        // change background color
        view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        view.addSubview(textLabel)
        view.addSubview(inputsContainerView)
        view.addSubview(signinButton)
        
        
        // Display Google and Facebook login
        setupFacebookButton()
        setupGoogleButton()
        setupInputsContainer()
        setupSigninButton()
        
    }
    
    let textLabel: UILabel = {
        
        let orText = UILabel()
        orText.textColor = UIColor.darkGray
        orText.text = "OR"

        return orText
        
    }()
    
    let emailTextField: UITextField = {
       
        let emailText = UITextField()
        emailText.placeholder = "First and last name"
        emailText.translatesAutoresizingMaskIntoConstraints = false
        
        return emailText
        
    }()
    
    let nameSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r:220, g:220, b:220)
        view.layer.cornerRadius = 5
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
        
    let passwordTextField: UITextField = {
        
        let passwordText = UITextField()
        passwordText.placeholder = "Password"
        passwordText.translatesAutoresizingMaskIntoConstraints = false
        passwordText.isSecureTextEntry = true
        return passwordText
        
    }()
    
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
        inputsContainerView.topAnchor.constraint(equalTo:
            view.topAnchor, constant: 220).isActive = true
        inputsContainerView.widthAnchor.constraint(equalTo:
            view.widthAnchor, constant: -24).isActive = true
        inputsContainerView.heightAnchor.constraint(equalToConstant:
            100).isActive = true
        
        view.addSubview(emailTextField)
        view.addSubview(nameSeparatorView)
        view.addSubview(passwordTextField)
        
        // setup x, y, height, and width for nameText field
        emailTextField.leftAnchor.constraint(equalTo:
            inputsContainerView.leftAnchor, constant: 12).isActive = true
        emailTextField.topAnchor.constraint(equalTo:
            inputsContainerView.topAnchor).isActive = true
        emailTextField.heightAnchor.constraint(equalTo:
            inputsContainerView.heightAnchor, multiplier: 1/2).isActive = true
        emailTextField.widthAnchor.constraint(equalTo:
            inputsContainerView.widthAnchor).isActive = true
        
        // setup x, y, height, and width for field separator
        nameSeparatorView.leftAnchor.constraint(equalTo:
            inputsContainerView.leftAnchor).isActive = true
        nameSeparatorView.topAnchor.constraint(equalTo:
            emailTextField.bottomAnchor).isActive = true
        nameSeparatorView.widthAnchor.constraint(equalTo:
            inputsContainerView.widthAnchor).isActive = true
        nameSeparatorView.heightAnchor.constraint(equalToConstant:
            1).isActive = true
        
        // setup x, y, height, and width for passwordText field
        passwordTextField.leftAnchor.constraint(equalTo:
            inputsContainerView.leftAnchor, constant: 12).isActive = true
        passwordTextField.topAnchor.constraint(equalTo:
            emailTextField.bottomAnchor).isActive = true
        passwordTextField.heightAnchor.constraint(equalTo:
            inputsContainerView.heightAnchor, multiplier: 1/2).isActive = true
        passwordTextField.widthAnchor.constraint(equalTo:
            inputsContainerView.widthAnchor).isActive = true
    }
    
    let signinButton: UIButton = {
       
        let signin = UIButton(type: .system)
        signin.backgroundColor = UIColor(r: 247, g: 146, b: 30)
        signin.setTitle("SIGN IN", for: [])
        signin.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        signin.translatesAutoresizingMaskIntoConstraints = false
        signin.setTitleColor(UIColor.white, for: [])
        signin.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        signin.layer.borderWidth = 1
        signin.layer.borderColor = UIColor.clear.cgColor
        signin.layer.cornerRadius = 5
        
        signin.addTarget(self , action: #selector(handleSignIn), for: .touchUpInside)
        
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
    
    @objc func handleSignIn() {
        
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!, completion: { (user, error) in
            if error == nil {
                //Print into the console if successfully logged in
                print("You have successfully logged in")
                
            }
            
            
        })
        
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
        googleButton.frame = CGRect(x: 15, y: 160, width: view.frame.width - 32, height: 50)
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



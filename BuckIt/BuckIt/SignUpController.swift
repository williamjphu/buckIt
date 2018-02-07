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

class SignUpController: UIViewController, FBSDKLoginButtonDelegate, GIDSignInUIDelegate {
    //firebase storing
    var ref = DatabaseReference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //storing users for firebase
        ref = Firebase.Database.database().reference()
        
        
        // setup navigation bar
        let navBar: UINavigationBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: 425, height: 250))
        self.view.addSubview(navBar)
        let navItem = UINavigationItem()
        let backItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: #selector(handleBackButton))
        navItem.leftBarButtonItem = backItem
        navBar.setItems([navItem], animated: false)
        
        // change background color
        view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        
        // display views
        view.addSubview(inputsContainerView)
        view.addSubview(createAccountButton)
        
        // layout UI
        setupGoogleButton()
        setupFacebookButton()
        setupInputsContainer()
        setupCreateAccountButton()
        // setupNavigationBar()
    }
    
    func setupNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    let nameTextField: UITextField = {
        
        let nameText = UITextField()
        nameText.placeholder = "First and last name"
        nameText.translatesAutoresizingMaskIntoConstraints = false
        
        return nameText
        
    }()
    
    let nameSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r:220, g:220, b:220)
        view.layer.cornerRadius = 5
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    let emailTextField: UITextField = {
        
        let emailText = UITextField()
        emailText.placeholder = "Email"
        emailText.translatesAutoresizingMaskIntoConstraints = false
        
        return emailText
        
    }()
    
    let emailSeparatorView: UIView = {
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
    
    let passwordSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r:220, g:220, b:220)
        view.layer.cornerRadius = 5
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    let confirmTextField: UITextField = {
        
        let confirmText = UITextField()
        confirmText.placeholder = "Confirm Password"
        confirmText.translatesAutoresizingMaskIntoConstraints = false
        confirmText.isSecureTextEntry = true
        return confirmText
        
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
            180).isActive = true
        
        view.addSubview(nameTextField)
        view.addSubview(nameSeparatorView)
        view.addSubview(emailTextField)
        view.addSubview(emailSeparatorView)
        view.addSubview(passwordTextField)
        view.addSubview(passwordSeparatorView)
        view.addSubview(confirmTextField)

        // setup x, y, height, and width for name text field
        nameTextField.leftAnchor.constraint(equalTo:
            inputsContainerView.leftAnchor, constant: 12).isActive = true
        nameTextField.topAnchor.constraint(equalTo:
            inputsContainerView.topAnchor).isActive = true
        nameTextField.heightAnchor.constraint(equalTo:
            inputsContainerView.heightAnchor, multiplier: 1/4).isActive = true
        nameTextField.widthAnchor.constraint(equalTo:
            inputsContainerView.widthAnchor).isActive = true

        // setup x, y, height, and width for field separator
        nameSeparatorView.leftAnchor.constraint(equalTo:
            inputsContainerView.leftAnchor).isActive = true
        nameSeparatorView.topAnchor.constraint(equalTo:
            nameTextField.bottomAnchor).isActive = true
        nameSeparatorView.widthAnchor.constraint(equalTo:
            inputsContainerView.widthAnchor).isActive = true
        nameSeparatorView.heightAnchor.constraint(equalToConstant:
            1).isActive = true

        // setup x, y, height, and width for emailText field
        emailTextField.leftAnchor.constraint(equalTo:
            inputsContainerView.leftAnchor, constant: 12).isActive = true
        emailTextField.topAnchor.constraint(equalTo:
            nameTextField.bottomAnchor).isActive = true
        emailTextField.heightAnchor.constraint(equalTo:
            inputsContainerView.heightAnchor, multiplier: 1/4).isActive = true
        emailTextField.widthAnchor.constraint(equalTo:
            inputsContainerView.widthAnchor).isActive = true

        // setup x, y, height, and width for emailText field separator
        emailSeparatorView.leftAnchor.constraint(equalTo:
            inputsContainerView.leftAnchor).isActive = true
        emailSeparatorView.topAnchor.constraint(equalTo:
            emailTextField.bottomAnchor).isActive = true
        emailSeparatorView.widthAnchor.constraint(equalTo:
            inputsContainerView.widthAnchor).isActive = true
        emailSeparatorView.heightAnchor.constraint(equalToConstant:
            1).isActive = true

        // setup x, y, height, and width for password text field
        passwordTextField.leftAnchor.constraint(equalTo:
            inputsContainerView.leftAnchor, constant: 12).isActive = true
        passwordTextField.topAnchor.constraint(equalTo:
            emailTextField.bottomAnchor).isActive = true
        passwordTextField.heightAnchor.constraint(equalTo:
            inputsContainerView.heightAnchor, multiplier: 1/4).isActive = true
        passwordTextField.widthAnchor.constraint(equalTo:
            inputsContainerView.widthAnchor).isActive = true

        // setup x, y, height, and width for password field separator
        passwordSeparatorView.leftAnchor.constraint(equalTo:
            inputsContainerView.leftAnchor).isActive = true
        passwordSeparatorView.topAnchor.constraint(equalTo:
            passwordTextField.bottomAnchor).isActive = true
        passwordSeparatorView.widthAnchor.constraint(equalTo:
            inputsContainerView.widthAnchor).isActive = true
        passwordSeparatorView.heightAnchor.constraint(equalToConstant:
            1).isActive = true

        // setup x, y, height, and width for confirm password text field
        confirmTextField.leftAnchor.constraint(equalTo:
            inputsContainerView.leftAnchor, constant: 12).isActive = true
        confirmTextField.topAnchor.constraint(equalTo:
            passwordTextField.bottomAnchor).isActive = true
        confirmTextField.heightAnchor.constraint(equalTo:
            inputsContainerView.heightAnchor, multiplier: 1/4).isActive = true
        confirmTextField.widthAnchor.constraint(equalTo:
            inputsContainerView.widthAnchor).isActive = true
    }
    
    let createAccountButton: UIButton = {
        
        let createAccount = UIButton(type: .system)
        createAccount.backgroundColor = UIColor(r: 247, g: 146, b: 30)
        createAccount.setTitle("CREATE ACCOUNT", for: [])
        createAccount.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        createAccount.translatesAutoresizingMaskIntoConstraints = false
        createAccount.setTitleColor(UIColor.white, for: [])
        createAccount.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        createAccount.layer.borderWidth = 1
        createAccount.layer.borderColor = UIColor.clear.cgColor
        createAccount.layer.cornerRadius = 5
        
        createAccount.addTarget(self, action: #selector(handleRegister), for: .touchUpInside)
        
        return createAccount
    }()
    
    func setupCreateAccountButton() {
        
        // set x, y, width, height constraints
        createAccountButton.centerXAnchor.constraint(equalTo:
            view.centerXAnchor).isActive = true
        createAccountButton.bottomAnchor.constraint(equalTo:
            view.bottomAnchor, constant: -45).isActive = true
        createAccountButton.widthAnchor.constraint(equalTo:
            view.widthAnchor, constant: -24).isActive = true
        createAccountButton.heightAnchor.constraint(equalToConstant: 45).isActive
            = true
        
    }
    
    @objc func handleRegister() {
        
        let vc = UIStoryboard(name: "TabController" , bundle: nil).instantiateViewController(withIdentifier: "tabBarVC")
        
        
        guard let email = emailTextField.text, let password = passwordTextField.text
        else {
                print("Form is not valid")
            return
        }
        
        // register the user using their email and password
        Auth.auth().createUser(withEmail: email, password: password,
                                         completion: { (user, error) in
                                                
                                            if error != nil {
                                                print(error)
                                                return
                                            } // end if error !=
                
                // once the credentials have been input, move on to user profile set up
                self.present(vc, animated: true, completion: nil)
                                                
        }) // successfully registered user
        
    } // end handle
    
    @objc func handleBackButton() {
        
        let landing = HomepageController()
        present(landing, animated: true, completion: nil)
        
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
        
        navigationController?.navigationItem.title = "TITLE"
        
        
        if FBSDKAccessToken.current() != nil
        {
            DispatchQueue.main.async
                {
                    let vc = UIStoryboard(name: "TabController" , bundle: nil).instantiateViewController(withIdentifier: "tabBarVC")
                    
                    self.present(vc, animated: true, completion: nil)
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
            let vc = UIStoryboard(name: "TabController" , bundle: nil).instantiateViewController(withIdentifier: "tabBarVC")
            
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("Logged out of Facebook")
    }
    
    
    
}

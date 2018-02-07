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
        
        // setup navigation bar
        let navBar: UINavigationBar = UINavigationBar(frame: CGRect(x: 0, y: 10, width: 425, height: 1000))
        self.view.addSubview(navBar)
        let navItem = UINavigationItem()
        let backItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: #selector(handleBackButton))
        navItem.leftBarButtonItem = backItem            // back button
        navBar.setItems([navItem], animated: false)
        
        // change background color
        view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        view.addSubview(textLabel)
        view.addSubview(inputsContainerView)
        view.addSubview(signinButton)
        view.addSubview(forgotPassword)
        
        
        // Display Google and Facebook login
        setupFacebookButton()
        setupGoogleButton()
        setupInputsContainer()
        setupSigninButton()
        setupForgotPassword()
        
    }
    
    /****
     ** Set the transition for the back button. Hitting the back button will return
     ** to the BuckIt! screen
     ****/
    @objc func handleBackButton() {
        
        let landing = HomepageController()
        let navigate = UINavigationController()
        
        navigate.popToViewController(landing, animated: true)
        present(landing, animated: true, completion: nil)
        
    }
    
    let textLabel: UILabel = {
        
        let orText = UILabel()
        orText.textColor = UIColor.darkGray
        orText.text = "OR"
        orText.frame = CGRect(x: 175, y: 125, width: 50, height: 50)

        return orText
        
    }()
  
    let emailTextField: UITextField = {
       
        let emailText = UITextField()
        emailText.placeholder = "Email"
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
    
    /****
     ** Setup container for the text fields
     ****/
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
    
    let forgotPassword: UIButton = {
       
        let recover = UIButton(type: .system)
        recover.backgroundColor = UIColor.clear
        recover.setTitle("Forgot Password?", for: [])
        recover.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        recover.setTitleColor(UIColor.blue, for: [])
        recover.translatesAutoresizingMaskIntoConstraints = false
        
        return recover
        
    }()
    
    /****
     ** Setup position for Forgot Password
     ****/
    func setupForgotPassword() {
        
        // set x, y, widht, height constraints
        forgotPassword.centerXAnchor.constraint(equalTo:
            view.centerXAnchor).isActive = true
        forgotPassword.topAnchor.constraint(equalTo:
            view.topAnchor, constant: 325).isActive = true
        forgotPassword.widthAnchor.constraint(equalTo:
            view.widthAnchor, constant: -24).isActive = true
        forgotPassword.heightAnchor.constraint(equalToConstant: 45).isActive
            = true
        
    }
    
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
    
    /****
     ** Handle logging in. Make sure the credentials are correct and
     ** alerts the user when fields are empty or when credentials are
     ** incorrect.
     ****/
    @objc func handleSignIn() {
        view.endEditing(true)
        
        // alert the user when email or password is empty
        if( (emailTextField.text?.isEmpty)! || (passwordTextField.text?.isEmpty)! ) {
            let emptyText = UIAlertController(title: "Error",
                                          message: "Enter email or password",
                                          preferredStyle: UIAlertControllerStyle.alert)
            emptyText.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            self.present(emptyText, animated: true)
        }
        
        // authenticate the user
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!, completion:
            { (user, error) in
                if error == nil {
                    print("User logged in") // print for testing purposes
                
                    // alert the user that they have logged in
                    let alert = UIAlertController(title: "User has logged in",
                                                  message: "You have successfully logged in",
                                                  preferredStyle: UIAlertControllerStyle.alert)
                
                    // dismiss alert when pressed
                    alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                    
                    // display alert
                    self.present(alert, animated: true)
                }
                else if ( !(error == nil) ){
                    let alert2 = UIAlertController(title: "Error",
                                                  message: "Incorrect user name or password. Please try again",
                                                  preferredStyle: UIAlertControllerStyle.alert)
                    
                    // dismiss alert when pressed
                    alert2.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                    self.present(alert2, animated: true)
                }
            })
    }
    
    
    
    /****
     ** Login button for Facebook login
     ****/
    fileprivate func setupFacebookButton() {
        //Draw Facebook sign in button
        let loginButton = FBSDKLoginButton()
        loginButton.frame = CGRect(x: 15, y: 85, width: view.frame.width - 32, height: 50)
        loginButton.delegate = self as! FBSDKLoginButtonDelegate
        view.addSubview(loginButton)
    }
 
    /****
     ** Login button for Gmail login
     ****/
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
                let vc = UIStoryboard(name: "TabController" , bundle: nil).instantiateViewController(withIdentifier: "tabBarVC")
                
                self.present(vc, animated: true, completion: nil)            }
        }
    }
    
    /****
     ** Login button using Facebook
     ****/
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if error != nil {
            print(error)
            return
        } else if FBSDKAccessToken.current() == nil {
            //welcomeMessage.text = "Authentication was canceled"
        }
        else if error == nil {
            print("Successfully logged in via facebook")
            let accessToken = FBSDKAccessToken.current()
            let credentials = FacebookAuthProvider.credential(withAccessToken: (accessToken?.tokenString)!)
            var imageStringUrl : String?
            
            let graphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"picture.type(large)"])
            graphRequest?.start(completionHandler: { (connection, result, error) in
                if error != nil {
                    print(error ?? "")
                }
                
                if let resultDic = result as? NSDictionary {
                    let data = resultDic["picture"] as? NSDictionary
                    let dataDict = data!["data"] as? NSDictionary
                    imageStringUrl = dataDict!["url"] as? String
                }
            })
            
            
            Auth.auth().signIn(with: credentials, completion: { (user, err) in
                if err != nil{
                    print("FB User is wrong", err ?? "")
                }
                print("User successfully logged in to Firebase with: ", user ?? "")
                guard let uid = user?.uid else{
                    return
                }
                let ref = Database.database().reference()
                let usersReference = ref.child("users").child(uid)
                let values = ["uid": user?.uid,
                              "name": user?.displayName,
                              "email": user?.email,
                              "profilePicture": imageStringUrl]
                usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
                    if let err = err {
                        print(err)
                        return
                    }
                })
                
                
            })
            
            
            let vc = UIStoryboard(name: "TabController" , bundle: nil).instantiateViewController(withIdentifier: "tabBarVC")
            
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("Logged out of Facebook")
    }
    
    
}



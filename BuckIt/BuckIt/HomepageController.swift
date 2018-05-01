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
import Firebase

class HomepageController: UIViewController, FBSDKLoginButtonDelegate, GIDSignInUIDelegate{
    
    @IBOutlet var loginButton: FBSDKLoginButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    //if users already login through facebook. Take to profile
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)

        super.viewWillAppear(animated)
        let vc = UIStoryboard(name: "TabController" , bundle: nil).instantiateViewController(withIdentifier: "tabBarVC")
        if FBSDKAccessToken.current() != nil {
            DispatchQueue.main.async {
                self.present(vc, animated: true, completion: nil)
            }
        } else if Firebase.Auth.auth().currentUser != nil{
            DispatchQueue.main.async {
                self.present(vc, animated: true, completion: nil)
            }
        } else if GIDSignIn.sharedInstance().hasAuthInKeychain(){
            DispatchQueue.main.async {
                self.present(vc, animated: true, completion: nil)
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        loginButton.delegate = self
        setupGoogleButton()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    @IBAction func signUpClicked(_ sender: Any) {
        performSegue(withIdentifier: "signUp", sender: self)
    }
    
    /****
     ** Handle logging in. Make sure the credentials are correct and
     ** alerts the user when fields are empty or when credentials are
     ** incorrect.
     ****/
    @IBAction func loginButtonPressed(_ sender: Any) {
        view.endEditing(true)
        
        // alert the user when email or password is empty
        if( (emailTextField.text?.isEmpty)! || (passwordTextField.text?.isEmpty)! ) {
            let emptyText = UIAlertController(title: "Error",
                                              message: "Enter email or password",
                                              preferredStyle: UIAlertControllerStyle.alert)
            emptyText.addAction(UIAlertAction(title: "Dismiss",
                                              style: .default,
                                              handler: nil))
            self.present(emptyText, animated: true)
        }
        
        // authenticate the user
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!, completion:
            { (user, error) in
                if error == nil {
                    print("User logged in")//print for testing purposes
                    let vc = UIStoryboard(name: "TabController" , bundle: nil).instantiateViewController(withIdentifier: "tabBarVC")
                    self.present(vc, animated: true, completion: nil)
                }
                    
                    //login FAILED
                else{
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
     ** Login button for Gmail login
     ****/
    fileprivate func setupGoogleButton(){
        
        //Draw Google sign in button
        let googleButton = GIDSignInButton()
        googleButton.frame = CGRect(x: 58, y: 470, width: 258, height: 30)
        GIDSignIn.sharedInstance().uiDelegate = self
        view.addSubview(googleButton)
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("Logged out of Facebook")
    }
    
    /****
     ** Login button using Facebook
     ****/
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        
        let ref = FirebaseDataContoller.sharedInstance.refToFirebase
        
        
        if error != nil {
            print(error)
            return
        } else if FBSDKAccessToken.current() == nil {
            //welcomeMessage.text = "Authentication was canceled"
        }
        else if error == nil {
            let accessToken = FBSDKAccessToken.current()
            let credentials = FacebookAuthProvider.credential(withAccessToken: (accessToken?.tokenString)!)
            
            let graphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"picture.type(large)"])
            graphRequest?.start(completionHandler: { (connection, result, error) in
                if error != nil {
                    print(error ?? "")
                }
                
                if let resultDic = result as? NSDictionary {
                    let data = resultDic["picture"] as? NSDictionary
                    let dataDict = data!["data"] as? NSDictionary
                    
                }
            })
            
            //Facebook login
            Auth.auth().signIn(with: credentials, completion: { (user, err) in
                if err != nil{
                    print("FB User is wrong", err ?? "")
                }
                
                // check to see if the user is in the database
                let theUserUID = Auth.auth().currentUser?.uid
                ref.child("users").observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
                    if snapshot.hasChild(theUserUID!)
                    {
                        print("User successfully logged in to Firebase with: ", user ?? "")
                        let vc = UIStoryboard(name: "TabController" , bundle: nil).instantiateViewController(withIdentifier: "tabBarVC")
                        
                        self.present(vc, animated: true, completion: nil)
                    } else {
                        let loginManager = FBSDKLoginManager()
                        loginManager.logOut()
                        
                        let emptyText1 = UIAlertController(title: "Error",
                                                           message: "Please go sign up",
                                                           preferredStyle: UIAlertControllerStyle.alert)
                        emptyText1.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                        self.present(emptyText1, animated: true)
                        
                    }
                    
                    
                })
                
            })
        }
    }
}

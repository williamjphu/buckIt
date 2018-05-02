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

class HomepageController: UIViewController, FBSDKLoginButtonDelegate, GIDSignInUIDelegate, GIDSignInDelegate{
    
    @IBOutlet var loginButton: FBSDKLoginButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    //if users already login through facebook. Take to profile
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)

        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        loginButton.readPermissions = ["email", "public_profile"]
        reloadPage()
    }
    
    func reloadPage()
    {
        if FBSDKAccessToken.current() != nil {
            DispatchQueue.main.async {
                let vc = UIStoryboard(name: "TabController" , bundle: nil).instantiateViewController(withIdentifier: "tabBarVC")
                self.present(vc, animated: true, completion: nil)
            }
        } else if Firebase.Auth.auth().currentUser != nil{
            DispatchQueue.main.async {
                  let vc = UIStoryboard(name: "TabController" , bundle: nil).instantiateViewController(withIdentifier: "tabBarVC")
                self.present(vc, animated: true, completion: nil)
            }
        } else if GIDSignIn.sharedInstance().hasAuthInKeychain(){
            DispatchQueue.main.async {
                  let vc = UIStoryboard(name: "TabController" , bundle: nil).instantiateViewController(withIdentifier: "tabBarVC")
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
    
    //Google sign in
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let err = error {
            print("Failed to log into Google: ", err)
            return
        }
        
        guard let idToken = user.authentication.idToken else { return }
        guard let accessToken = user.authentication.accessToken else { return }
        let credentials = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
        
        Auth.auth().signIn(with: credentials, completion: {(user , error) in
            if let err = error {
                print("Failed to create a Firebase User with Google Account: " , err)
                return
            }
            guard let uid = user?.uid else {return}
            
            let ref = FirebaseDataContoller.sharedInstance.refToFirebase
            let theUserUID = Auth.auth().currentUser?.uid
            
            ref.child("users").observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
                if !snapshot.hasChild(theUserUID!)
                {
                    let usersReference = ref.child("users").child(uid)
                    let values : [String : Any] = ["uid": user!.uid,
                                                   "name": user!.displayName,
                                                   "email": user!.email,
                                                   "picture" : user!.photoURL?.absoluteString,
                                                   "username" : "",
                                                   "description" : ""]
                    usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
                        if let err = err {
                            print(err)
                            return
                        }
                    })
                    
                    print("Sucessfully logging to Firebase with Google" , uid)
                    let newViewController = UIStoryboard(name: "TabController", bundle: nil).instantiateViewController(withIdentifier: "tabBarVC")
                    UIApplication.topViewController()?.present(newViewController, animated: true, completion: nil)
                }
                else{
                    let newViewController = UIStoryboard(name: "TabController", bundle: nil).instantiateViewController(withIdentifier: "tabBarVC")
                    UIApplication.topViewController()?.present(newViewController, animated: true, completion: nil)
                }
            })
        })
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
                    
                    let newViewController = UIStoryboard(name: "TabController", bundle: nil).instantiateViewController(withIdentifier: "tabBarVC")
                    UIApplication.topViewController()?.present(newViewController, animated: true, completion: nil)
                }
                    
                    //login FAILED
                else{
                    let alert2 = UIAlertController(title: "Error",
                                                   message: "Incorrect user name or password. Please try again",
                                                   preferredStyle: UIAlertControllerStyle.alert)
                    // dismiss alert when pressed
                    alert2.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                }
        })
    }
    
    /****
     ** Login button for Gmail login
     ****/
    fileprivate func setupGoogleButton(){
        
        //Draw Google sign in button
        let googleButton = GIDSignInButton()
        googleButton.frame = CGRect(x: 55, y: 525, width: 265, height: 30)
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
            
            //Facebook login
            Auth.auth().signIn(with: credentials, completion: { (user, err) in
                if err != nil{
                    print("FB User is wrong", err ?? "")
                }
                
                // check to see if the user is in the database
                let theUserUID = Auth.auth().currentUser?.uid
                ref.child("users").observeSingleEvent(of: .value, with: { (snapshot) in
                    if snapshot.hasChild(theUserUID!)
                    {
//                        let newViewController = UIStoryboard(name: "TabController", bundle: nil).instantiateViewController(withIdentifier: "tabBarVC")
//                        UIApplication.topViewController()?.present(newViewController, animated: true, completion: nil)
                    } else {
                        let usersReference = ref.child("users").child(user!.uid)
                        let values : [String : Any] = ["uid": user!.uid,
                                                       "name": user!.displayName,
                                                       "email": user!.email,
                                                       "picture" : user!.photoURL!.absoluteString,
                                                       "username" : "",
                                                       "description" : ""]
                        usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
                            if let err = err {
                                print(err)
                                return
                            }
                            let newViewController = UIStoryboard(name: "TabController", bundle: nil).instantiateViewController(withIdentifier: "tabBarVC")
                            UIApplication.topViewController()?.present(newViewController, animated: true, completion: nil)
                        })

                    }
                })
                
            })
            

        }
    }
}

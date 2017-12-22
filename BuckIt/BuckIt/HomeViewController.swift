////
////  HomeViewController.swift
////  BuckIt
////
////  Created by Samnang Sok on 11/4/17.
////  Copyright © 2017 Samnang Sok. All rights reserved.
////
//
//import UIKit
//import FBSDKLoginKit
//
//class HomeViewController: UIViewController, FBSDKLoginButtonDelegate{
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        let loginButton = FBSDKLoginButton()
//        view.addSubview(loginButton)
//        loginButton.frame = CGRect(x: 16, y: 50, width: view.frame.width - 32, height: 50)
//        loginButton.delegate = self
//
//    }
//
//
//    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
//        if error != nil {
//            print(error)
//            return
//        } else if FBSDKAccessToken.current() == nil {
//            //welcomeMessage.text = "Authentication was canceled"
//        }
//        else if error == nil {
//            print("Successfull logged in via facebook")
//            self.performSegue(withIdentifier: "login", sender: self)
//        }
//    }
//    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
//        print("Logged out of Facebook")
//    }
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
//}
//

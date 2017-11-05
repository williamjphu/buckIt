//
//  ViewController.swift
//  BuckIt
//
//  Created by Samnang Sok on 11/4/17.
//  Copyright © 2017 Samnang Sok. All rights reserved.
//

import UIKit
import FBSDKLoginKit
class ViewController: UIViewController , FBSDKLoginButtonDelegate{
  
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let loginButton = FBSDKLoginButton()
        view.addSubview(loginButton)
        loginButton.frame = CGRect(x: 16, y: 50, width: view.frame.width - 32, height: 50)
        
        loginButton.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if FBSDKAccessToken.current() != nil {
            
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "ShowHome", sender: self)
            }
        }
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if error != nil
        {
            print(error)
            return
        } else
        {
            print("Successfully logged in with Facebook")
            self.performSegue(withIdentifier: "ShowHome", sender: self)
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("Did log out of Facebook")
    }


}


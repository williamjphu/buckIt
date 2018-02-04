//
//  SignUpProfileController.swift
//  BuckIt
//
//  Created by Joshua Ventocilla on 2/1/18.
//  Copyright © 2018 Samnang Sok. All rights reserved.
//

import UIKit

class SignUpProfileController: UIViewController {

    //let userNameTextField = UITextField(frame: CGRect(x: 150, y: 150, width: 300, height: 30))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // change background color
        view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        
        //
        view.addSubview(profilePicture)
        view.addSubview(usernameTextField)
    
        // set up views
        setupProfilePicture()
        setupUserNameTextField()

    }
    
    /****
     ** Set the attributes for the textfield such as color, radius,
     ** and left padding
     ****/
    let usernameTextField: UITextField = {
        
        let text = UITextField()
        let padding  = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        text.placeholder = "Username"
        text.leftView = padding
        text.leftViewMode = .always
        text.layer.backgroundColor = UIColor.white.cgColor
        text.layer.cornerRadius = 5
        text.translatesAutoresizingMaskIntoConstraints = false
        
        return text
        
    }()
    
    /****
     ** Set the attributes for the profile picture
     ****/
    let profilePicture: UIImageView = {
        let image = UIImageView()
        image.layer.backgroundColor = UIColor.white.cgColor
        image.translatesAutoresizingMaskIntoConstraints = false
        
        return image
    }()
    
    /****
     ** Setup round image for the user's profile picture.
     ****/
    func setupProfilePicture() {
        
        profilePicture.layer.masksToBounds = true
        
        // set the placement of the layer
        profilePicture.centerXAnchor.constraint(equalTo:
            view.centerXAnchor).isActive = true
        profilePicture.topAnchor.constraint(equalTo:
            view.topAnchor, constant: 100).isActive = true
        profilePicture.widthAnchor.constraint(equalToConstant:
            150).isActive = true
        profilePicture.heightAnchor.constraint(equalToConstant:
            150).isActive = true
        profilePicture.layer.cornerRadius = 75
    }
    
    func setupUserNameTextField() {
        usernameTextField.centerXAnchor.constraint(equalTo:
            view.centerXAnchor).isActive = true
        usernameTextField.topAnchor.constraint(equalTo:
            view.topAnchor, constant: 300).isActive = true
        usernameTextField.widthAnchor.constraint(equalTo:
            view.widthAnchor, constant: -50).isActive = true
        usernameTextField.heightAnchor.constraint(equalToConstant:
            25).isActive = true
    }
    
    //func setupAltProfilePicture() {
    //    altProfilePicture.layer.cornerRadius = self.altProfilePicture.frame.size.width/2
    //    altProfilePicture.clipsToBounds = true
    //    altProfilePicture.translatesAutoresizingMaskIntoConstraints = false
    //}
    
}

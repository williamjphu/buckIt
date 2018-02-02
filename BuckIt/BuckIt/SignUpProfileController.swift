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
    
        // set up views
        setupProfilePicture()
        //setupUserNameTextField()

    }
    
    let textfieldContainerView: UIView = {
       
        let container = UIView()
        container.backgroundColor = UIColor.white
        container.layer.cornerRadius = 5
        container.layer.masksToBounds = true
        container.translatesAutoresizingMaskIntoConstraints = false
        
        return container
        
    }()
    
    let usernameTextField: UITextField = {
        
        let text = UITextField()
        text.placeholder = "Username"
        text.layer.backgroundColor = UIColor.white.cgColor
        text.translatesAutoresizingMaskIntoConstraints = false
        
        return text
        
    }()
    
    let profilePicture: UIImageView = {
        let image = UIImageView()
        image.layer.backgroundColor = UIColor.white.cgColor
        image.translatesAutoresizingMaskIntoConstraints = false
        
        return image
    }()
    
    func setupProfilePicture() {
        
        profilePicture.layer.masksToBounds = true
        profilePicture.layer.cornerRadius = 75
        profilePicture.centerXAnchor.constraint(equalTo:
            view.centerXAnchor).isActive = true
        profilePicture.topAnchor.constraint(equalTo:
            view.topAnchor, constant: 150).isActive = true
        profilePicture.widthAnchor.constraint(equalToConstant:
            150).isActive = true
        profilePicture.heightAnchor.constraint(equalToConstant:
            150).isActive = true
    }
    
    func setupUserNameTextField() {
        
        textfieldContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        textfieldContainerView.topAnchor.constraint(equalTo: view.topAnchor, constant: 200).isActive = true
        
    }
    
    //func setupAltProfilePicture() {
    //    altProfilePicture.layer.cornerRadius = self.altProfilePicture.frame.size.width/2
    //    altProfilePicture.clipsToBounds = true
    //    altProfilePicture.translatesAutoresizingMaskIntoConstraints = false
    //}
    
}

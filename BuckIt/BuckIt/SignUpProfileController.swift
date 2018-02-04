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
        
        // display views
        view.addSubview(profilePicture)
        view.addSubview(usernameTextField)
        view.addSubview(submitButton)
        view.addSubview(cancelButton)
    
        // set up views
        setupProfilePicture()
        setupUserNameTextField()
        setupSubmitButton()
        setupCancelButton()

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
     ** Set the attributes for the Submit button
     ****/
    let submitButton: UIButton = {
        let submit = UIButton(type: .system)
        submit.backgroundColor = UIColor(r: 50, g: 205, b: 50)
        submit.setTitle("SUBMIT", for: [])
        submit.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        submit.translatesAutoresizingMaskIntoConstraints = false
        submit.setTitleColor(UIColor.white, for: [])
        submit.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        submit.layer.borderWidth = 1
        submit.layer.borderColor = UIColor.clear.cgColor
        submit.layer.cornerRadius = 5
        
        // call the action of the button
        submit.addTarget(self, action: #selector(submitAction(sender:)), for: .touchUpInside)
        
        return submit
    }()
    
    /****
     ** Set the attributes for the Cancel button
     ****/
    let cancelButton: UIButton = {
        let cancel = UIButton(type: .system)
        cancel.backgroundColor = UIColor(r: 255, g: 0, b: 0)
        cancel.setTitle("CANCEL", for: [])
        cancel.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        cancel.translatesAutoresizingMaskIntoConstraints = false
        cancel.setTitleColor(UIColor.white, for: [])
        cancel.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        cancel.layer.borderWidth = 1
        cancel.layer.borderColor = UIColor.clear.cgColor
        cancel.layer.cornerRadius = 5
        
        // call the action of the button
        cancel.addTarget(self, action: #selector(cancelAction(sender:)), for: .touchUpInside)
        
        return cancel
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
    
    /****
     ** Setup the user name text field.
     ****/
    func setupUserNameTextField() {
        usernameTextField.centerXAnchor.constraint(equalTo:
            view.centerXAnchor).isActive = true
        usernameTextField.topAnchor.constraint(equalTo:
            view.topAnchor, constant: 275).isActive = true
        usernameTextField.widthAnchor.constraint(equalTo:
            view.widthAnchor, constant: -24).isActive = true
        usernameTextField.heightAnchor.constraint(equalToConstant:
            45).isActive = true
    }
    
    /****
     ** Setup for the Submit button
     ****/
    func setupSubmitButton() {
        submitButton.centerXAnchor.constraint(equalTo:
            view.centerXAnchor).isActive = true
        submitButton.bottomAnchor.constraint(equalTo:
            view.bottomAnchor, constant: -100).isActive = true
        submitButton.widthAnchor.constraint(equalTo:
            view.widthAnchor, constant: -24).isActive = true
        submitButton.heightAnchor.constraint(equalToConstant: 45).isActive
            = true
    }
    
    /****
     ** Setup for the Cancel button
     ****/
    func setupCancelButton() {
        cancelButton.centerXAnchor.constraint(equalTo:
            view.centerXAnchor).isActive = true
        cancelButton.bottomAnchor.constraint(equalTo:
            view.bottomAnchor, constant: -45).isActive = true
        cancelButton.widthAnchor.constraint(equalTo:
            view.widthAnchor, constant: -24).isActive = true
        cancelButton.heightAnchor.constraint(equalToConstant: 45).isActive
            = true
    }
    
    /****
     ** The action for when the submit button is tapped
     ****/
    @objc func submitAction(sender: UIButton) {
        // input function here
        print("Profile Submitted")  // test action
    }
    
    /****
     ** The action to cancel when inputting username and profile picture.
     ** Cancelling will go back to the sign up page.
     ****/
    @objc func cancelAction(sender: UIButton) {
        
        // transition from left to right and going back
        // to the sign up page
        let landInPage = SignUpController()
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromLeft
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        view.window!.layer.add(transition, forKey: kCATransition)
        
        // change to the designated screen modally
        present(landInPage, animated: false, completion: nil)
        
    }
    
}

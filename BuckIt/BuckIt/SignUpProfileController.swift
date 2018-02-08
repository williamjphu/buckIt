//
//  SignUpProfileController.swift
//  BuckIt
//
//  Created by Joshua Ventocilla on 2/1/18.
//  Copyright © 2018 Samnang Sok. All rights reserved.
//

import UIKit
import Firebase
class SignUpProfileController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let picker = UIImagePickerController()
    var userStorage = StorageReference()
    var ref = DatabaseReference()
    

    //let userNameTextField = UITextField(frame: CGRect(x: 150, y: 150, width: 300, height: 30))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // change background color
        view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        
        // display views
        view.addSubview(profilePicture)
        view.addSubview(uploadButton)
        view.addSubview(usernameTextField)
        view.addSubview(submitButton)
        view.addSubview(cancelButton)
        
        // set up views
        setupProfilePicture()
        setUploadButton()
        setupUserNameTextField()
        setupSubmitButton()
        setupCancelButton()
        
        
        picker.delegate = self
        let store = Storage.storage().reference(forURL: "gs://buckit-ed26f.appspot.com")
        
        ref = Firebase.Database.database().reference()
        userStorage = store.child("profile")
        
    }
    
    //Set the attributes for the Submit button
    let uploadButton: UIButton = {
        let upload = UIButton(type: .system)
        upload.backgroundColor = UIColor(r: 50, g: 205, b: 50)
        upload.setTitle("Upload", for: [])
        upload.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        upload.translatesAutoresizingMaskIntoConstraints = false
        upload.setTitleColor(UIColor.white, for: [])
        upload.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        upload.layer.borderWidth = 1
        upload.layer.borderColor = UIColor.clear.cgColor
        upload.layer.cornerRadius = 5
        
        // call the action of the button
        upload.addTarget(self, action: #selector(setUpload(sender:)), for: .touchUpInside)
        
        return upload
    }()
    
    /****
     ** Setup for the upload button
     ****/
    func setUploadButton() {
        uploadButton.centerXAnchor.constraint(equalTo:
            view.centerXAnchor).isActive = true
        uploadButton.bottomAnchor.constraint(equalTo:
            view.bottomAnchor, constant: -350).isActive = true
        uploadButton.widthAnchor.constraint(equalTo:
            view.widthAnchor, constant: -150).isActive = true
        uploadButton.heightAnchor.constraint(equalToConstant: 45).isActive
            = true
    }
    
    // upload button action
    @objc func setUpload(sender: UIButton)
    {
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        
        present(picker, animated: true, completion: nil)
        

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
            view.topAnchor, constant: 370).isActive = true
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
    

    @objc func selectImagePressed(_ sender: Any) {
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage{
            self.profilePicture.image = image
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    /****
     ** The action for when the submit button is tapped
     ****/
    @objc func submitAction(sender: UIButton) {
        // input function here
        print("Profile Submitted")  // test action
        let uid = Firebase.Auth.auth().currentUser!.uid
        let ref = Firebase.Database.database().reference()
        
        guard usernameTextField.text != "" else { return }
        
        
        let imageRef = self.userStorage.child("\(uid).jpg")
        let data = UIImageJPEGRepresentation(self.profilePicture.image!, 0.5)
        let uploadTask = imageRef.putData(data!, metadata: nil, completion: { (metadata, err) in
            
            if err != nil{
                print(err!.localizedDescription)
            }
            imageRef.downloadURL(completion: { (url, er) in
                if er != nil
                {
                    print(er!.localizedDescription)
                }
                if let url = url
                {
                    let picture = ["picture": url.absoluteString]
                    let username = ["username": self.usernameTextField.text!]
                    ref.child("users").child(uid).updateChildValues(picture)
                    ref.child("users").child(uid).updateChildValues(username)
                    
                    
                    let vc = UIStoryboard(name: "TabController" , bundle: nil).instantiateViewController(withIdentifier: "tabBarVC")
                    
                    self.present(vc, animated: true, completion: nil)
                }
                
            })
        })
        
        uploadTask.resume()

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
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Login")
        present(vc, animated: true, completion: nil)
        
    }
    
}


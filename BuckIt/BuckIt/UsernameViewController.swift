//
//  UsernameViewController.swift
//  BuckIt
//
//  Created by Samnang Sok on 1/31/18.
//  Copyright © 2018 Samnang Sok. All rights reserved.
//

import UIKit
import Firebase
class UsernameViewController: UIViewController , UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nextButton: UIButton!

    @IBOutlet weak var userName: UITextField!
    
    let picker = UIImagePickerController()
    var userStorage = StorageReference()
    var ref = DatabaseReference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
        let store = Storage.storage().reference(forURL: "gs://buckit-ed26f.appspot.com")
        
        ref = Firebase.Database.database().reference()
        userStorage = store.child("profile")
    }

    @IBAction func selectImagePressed(_ sender: Any) {
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage{
            self.imageView.image = image
            nextButton.isHidden = false
        }
        self.dismiss(animated: true, completion: nil)
    }

     @IBAction func nextPressed(_ sender: Any) {
        let uid = Firebase.Auth.auth().currentUser!.uid
        let ref = Firebase.Database.database().reference()
        
        guard userName.text != "" else { return }
        

        let imageRef = self.userStorage.child("\(uid).jpg")
        let data = UIImageJPEGRepresentation(self.imageView.image!, 0.5)
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
                    let username = ["username": self.userName.text!]
                    ref.child("users").child(uid).updateChildValues(picture)
                    ref.child("users").child(uid).updateChildValues(username)
                    
                    
                    let vc = UIStoryboard(name: "Profile" , bundle: nil).instantiateViewController(withIdentifier: "userVC")
                    
                    self.present(vc, animated: true, completion: nil)
                }
                
            })
        })
        
        uploadTask.resume()
    }
}

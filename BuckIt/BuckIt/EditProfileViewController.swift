//
//  EditProfileViewController.swift
//  BuckIt
//
//  Created by Samnang Sok on 1/18/18.
//  Copyright © 2018 Samnang Sok. All rights reserved.
//
import UIKit
import Firebase

class EditProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    var ref: DatabaseReference!
    
    let picker = UIImagePickerController()
    
    @IBOutlet weak var imageView: UIImageView!
    
    
    @IBOutlet weak var descriptionText: UITextField!
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var userNameText: UITextField!
    
    //draw line for the input field
    override func viewDidLayoutSubviews() {
        let border = CALayer()
        let border1 = CALayer()
        let border2 = CALayer()
        
        let width = CGFloat(2.0)
        border.borderColor = UIColor.darkGray.cgColor
        border1.borderColor = UIColor.darkGray.cgColor
        border2.borderColor = UIColor.darkGray.cgColor
        
        //line for name
        border.frame = CGRect(x: 0, y: nameText.frame.size.height - width, width:   nameText.frame.size.width, height: nameText.frame.size.height)
        
        border.borderWidth = width
        nameText.layer.addSublayer(border)
        nameText.layer.masksToBounds = true
        
        //line for userName
        border1.frame = CGRect(x: 0, y: userNameText.frame.size.height - width, width:   userNameText.frame.size.width, height: userNameText.frame.size.height)
        
        border1.borderWidth = width
        userNameText.layer.addSublayer(border1)
        userNameText.layer.masksToBounds = true
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
        let store = Storage.storage().reference(forURL: "gs://buckit-ed26f.appspot.com")
        userStorage = store.child("profile")

        //maximize text input to 80 character
        descriptionText.delegate = self
        userNameText.delegate = self
        nameText.delegate = self
        
        //retrieve data from Firebase
        let ref  = Database.database().reference()
        ref.child("users").queryOrderedByKey().observeSingleEvent(of: .value, with: {snapshot in
            let users = snapshot.value as! [String: AnyObject]
            
            for(_, value) in users {
                if let uid = value["uid"] as? String {
                    if uid == Firebase.Auth.auth().currentUser!.uid{
                        
                        self.nameText.text = value["name"] as? String
                        self.userNameText.text = value["username"] as? String
                        self.descriptionText.text = value["description"] as? String
                        let databaseProfilePic = value["picture"] as? String
                        let data = NSData(contentsOf: NSURL(string: databaseProfilePic!)! as URL)
                        self.setProfilePicture(imageView: self.imageView, imageToSet: UIImage(data:data! as Data)!)
                    }
                }
            }
        })
        ref.removeAllObservers()
    }
    
    func setProfilePicture(imageView: UIImageView, imageToSet: UIImage){
        
        imageView.image = imageToSet
    }
    
    //change image
    @IBAction func changeImagePressed(_ sender: Any) {
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        
        present(picker, animated: true, completion: nil)
    }
    
    //change image
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage{
            self.imageView.image = image
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    //maximize text input to 80 character
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let newLength = text.characters.count + string.characters.count - range.length
        return newLength <= 45 // Bool
    }
    var userStorage = StorageReference()

    
    @IBAction func saveChange(_ sender: Any) {
        
        ref = Database.database().reference()
        
        let uid = Firebase.Auth.auth().currentUser!.uid
        
        let imageRef = self.userStorage.child("\(uid).jpg")
        let data = UIImageJPEGRepresentation(self.imageView.image!, 0.5)
        let usersReference = ref.child("users").child(uid)
        
        let uploadTask = imageRef.putData(data!, metadata: nil, completion: { (metadata, err) in
        imageRef.downloadURL(completion: { (url, er) in
            if er != nil
            {
                print(er!.localizedDescription)
            }
            if let url = url
            {
                let picture = ["picture": url.absoluteString]
                let values = ["username": self.userNameText.text,
                              "name": self.nameText.text,
                              "description": self.descriptionText.text]
                usersReference.updateChildValues(picture)
                usersReference.updateChildValues(values)
                
                let vc = UIStoryboard(name: "TabController" , bundle: nil).instantiateViewController(withIdentifier: "tabBarVC")
                
                self.present(vc, animated: true, completion: nil)

            }
            })
        })
    }
}

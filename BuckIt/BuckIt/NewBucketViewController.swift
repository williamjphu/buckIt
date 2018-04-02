//
//  NewBucketViewController.swift
//  BuckIt
//
//  Created by Michael Hyun on 2/14/18.
//  Copyright © 2018 Samnang Sok. All rights reserved.
//

import UIKit
import Firebase
import PopupDialog

class NewBucketViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var titleText: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var descriptionText: UITextView!
    var ref : DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func importImage(_ sender: Any) {
        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerControllerSourceType.photoLibrary
        
        image.allowsEditing = false
        self.present(image, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
            imageView.layer.cornerRadius = 10.0
            imageView.layer.borderColor = UIColor.white.cgColor
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.layer.masksToBounds = true
            imageView.image = image
        }
        else{
            print("Error")
        }
        //ERROR HERE: Everything is getting dismissed instead of just the imagepicker
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func createBuckit(_ sender: Any) {
        let uid = Auth.auth().currentUser!.uid
        ref = Database.database().reference()
        let storage = Storage.storage().reference(forURL: "gs://buckit-ed26f.appspot.com")
        let key = ref.child("BuckIts").childByAutoId().key
        let imageRef = storage.child("BuckIts").child(uid).child("\(key).jpeg")
        let data = UIImageJPEGRepresentation(self.imageView.image!, 0.6)
        
        let title = "Created BuckIt!"
        let message = self.titleText.text
        let popup = PopupDialog(title: title, message: message, image: self.imageView.image)
        // Create buttons
        let buttonOne = DefaultButton(title: "Got it") {
            print("Created Buckit")
            let uploadTask = imageRef.putData(data!, metadata: nil) { (metadata, error) in
                if error != nil {
                    print(error!.localizedDescription)
                    return
                }
                imageRef.downloadURL(completion: { (url, error) in
                    if let url = url {
                        let feed = ["userID" : uid,
                                    "pathToImage" : url.absoluteString,
                                    "title" : self.titleText.text!,
                                    "description": self.descriptionText.text!,
                                    "buckitID" : key] as [String : Any]
                        
                        let buckitFeed = ["\(key)" : feed]
                        self.ref.child("BuckIts").updateChildValues(buckitFeed)
                        
                    }
                })
                let vc = UIStoryboard(name: "TabController" , bundle: nil).instantiateViewController(withIdentifier: "tabBarVC")
                
                self.present(vc, animated: true, completion: nil)
            }
            uploadTask.resume()
        }
        let buttonTwo = CancelButton(title: "Cancel") {
            print("You canceled the car dialog.")
        }

        popup.addButtons([buttonOne, buttonTwo])
        
        //              Present dialog
        self.present(popup, animated: true, completion: nil)

    }
}

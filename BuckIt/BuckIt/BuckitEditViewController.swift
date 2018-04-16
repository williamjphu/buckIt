//
//  BuckitEditViewController.swift
//  BuckIt
//
//  Created by Samnang Sok on 4/5/18.
//  Copyright © 2018 Samnang Sok. All rights reserved.
//

import UIKit
import Firebase
class BuckitEditViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    var ref = Database.database().reference()
    var userStorage = StorageReference()
    
    var buckit = BuckIt()
    let picker = UIImagePickerController()
    
    @IBOutlet weak var imageView: UIImageView!
    
    
    @IBOutlet weak var descriptionText: UITextField!
    @IBOutlet weak var nameText: UITextField!
    
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
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
        let store = Storage.storage().reference(forURL: "gs://buckit-ed26f.appspot.com")
        userStorage = store.child("BuckIts")
        
        //maximize text input to 80 character
        descriptionText.delegate = self
        nameText.delegate = self
        fillActivityInfo()
    }
    
    func fillActivityInfo(){
        nameText.text! = buckit.title!
        descriptionText.text! = buckit.desc!
        imageView.downloadImage(from: buckit.pathToImage!)
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
    
    //Override the edit data to the database
    @IBAction func saveChange(_ sender: Any) {
        let buid = buckit.buckitId
        let imageRef = self.userStorage.child("\(buid).jpg")
        let data = UIImageJPEGRepresentation(self.imageView.image!, 0.5)
        let usersReference = ref.child("BuckIts").child(buid!)
        
        let uploadTask = imageRef.putData(data!, metadata: nil, completion: { (metadata, err) in
            imageRef.downloadURL(completion: { (url, er) in
                if er != nil
                {
                    print(er!.localizedDescription)
                }
                if let url = url
                {
                    let picture = ["pathToImage": url.absoluteString]
                    let values = ["title": self.nameText.text,
                                  "description": self.descriptionText.text]
                    usersReference.updateChildValues(picture)
                    usersReference.updateChildValues(values)
                    
                    let vc = UIStoryboard(name: "TabController" , bundle: nil).instantiateViewController(withIdentifier: "tabBarVC")
                    
                    self.present(vc, animated: true, completion: nil)
                    
                }
            })
        })
    }
    
    //the bucket is being deleted from Firebase
    @IBAction func deleteBuckitPressed(_ sender: Any) {
        let buid = buckit.buckitId
        ref.child("BuckIts").child(buid!).removeValue()
    }
    
}
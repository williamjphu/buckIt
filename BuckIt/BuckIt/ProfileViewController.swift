//
//  ProfileViewController.swift
//  BuckIt
//
//  Created by Samnang Sok on 1/16/18.
//  Copyright © 2018 Samnang Sok. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase
class ProfileViewController: UIViewController {
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        fetchUsers()
    }
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var quote: UILabel!
    func fetchUsers()
    {
        let ref  = Database.database().reference()
        ref.child("users").queryOrderedByKey().observeSingleEvent(of: .value, with: {snapshot in
            let users = snapshot.value as! [String: AnyObject]
            
            for(_, value) in users {
                if let uid = value["uid"] as? String {
                    if uid == Firebase.Auth.auth().currentUser!.uid{

                        self.name.text = value["name"] as? String
                        self.username.text = value["username"] as? String
                        let databaseProfilePic = value["picture"] as? String
                        let data = NSData(contentsOf: NSURL(string: databaseProfilePic!)! as URL)
                        self.setProfilePicture(imageView: self.profileImage, imageToSet: UIImage(data:data! as Data)!)
                    }
                }
            }
        })
        ref.removeAllObservers()
    }
    
    func setProfilePicture(imageView: UIImageView, imageToSet: UIImage){

        imageView.image = imageToSet
    }
    
    
}

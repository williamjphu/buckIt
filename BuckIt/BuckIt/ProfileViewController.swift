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
class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    
    @IBOutlet weak var tableView: UITableView!
    var buckits = [BuckIt]()
    
    override func viewWillAppear(_ animated: Bool) {
        fetchUsers()
        buckits.removeAll()
        
    }
    
    override func viewDidLoad() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        fetchUserBuckIts()
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
                        self.quote.text = value["description"] as? String
                        let databaseProfilePic = value["picture"] as? String
                        let data = NSData(contentsOf: (NSURL(string: databaseProfilePic!)! as URL))
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
    
    func fetchUserBuckIts(){
        let ref = Database.database().reference()
        ref.child("BuckIts").queryOrderedByKey().observeSingleEvent(of: .value, with: { (snap) in
            let buckitSnap = snap.value as! [String: AnyObject]
            
            for (_,buckit) in buckitSnap {
                if let uid = buckit["userID"] as? String{
                    if uid == Auth.auth().currentUser?.uid{
                        let buckitItem = BuckIt()
                        if let description = buckit["description"] as? String,
                            let buckitID = buckit["buckitID"] as? String,
                            let pathToImage = buckit["pathToImage"] as? String,
                            let title = buckit["title"] as? String {
                            
                            buckitItem.desc = description
                            buckitItem.buckitId = buckitID
                            buckitItem.pathToImage = pathToImage
                            buckitItem.title = title
                            buckitItem.userId = uid
                            
                            self.buckits.append(buckitItem)
                        }
                        self.tableView.reloadData()
                    }
                }
            }
        })
        ref.removeAllObservers()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(buckits.count)
        return self.buckits.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableCell = tableView.dequeueReusableCell(withIdentifier: "bucketCell", for: indexPath) as! BuckitTableViewCell
        tableCell.buckitImage.downloadImage(from: self.buckits[indexPath.row].pathToImage)
        tableCell.buckitTitle.text = self.buckits[indexPath.row].title
        return tableCell
    }
    
}

extension UIImageView {
    
    func downloadImage(from imgURL: String!) {
        let url = URLRequest(url: URL(string: imgURL)!)
        
        let task = URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            
            if error != nil {
                print(error!)
                return
            }
            
            DispatchQueue.main.async {
                self.image = UIImage(data: data!)
            }
            
        }
        
        task.resume()
    }
}

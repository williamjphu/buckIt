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
import Kingfisher

class ProfileViewController: UIViewController, UICollectionViewDelegate,UICollectionViewDataSource  {
    
    @IBOutlet weak var collectionview: UICollectionView!
    
    var buckits = [BuckIt]()

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        super.viewWillAppear(true)
        buckits.removeAll()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        fetchUserBuckIts()
    }
    
    override func viewDidLoad() {
        Auth.auth().addStateDidChangeListener { (auth, user) in
            if user != nil {
                self.fetchUsers()
            }
            else{
                print("NO USER YET")
            }
        }
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var quote: UILabel!
    
    @IBOutlet weak var numOfBuckIt: UILabel!
    var totalBuckit = 0;
    //retrieve users data
    func fetchUsers() {
        let ref  = FirebaseDataContoller.sharedInstance.refToFirebase
        ref.child("users").observeSingleEvent(of: .value, with: {snapshot in
            let users = snapshot.value as! [String: AnyObject]
            
            for(_, value) in users {
                if let uid = value["uid"] as? String {
                    if uid == Firebase.Auth.auth().currentUser!.uid{
                        self.name.text = value["name"] as? String
                        self.username.text = value["username"] as? String
                        if let descrip = value["description"] as? String {
                            self.quote.text = descrip
                        }
                        if let databaseProfilePic = value["picture"] as? String {
                            let data = NSData(contentsOf: (NSURL(string: databaseProfilePic)! as URL))
                            self.setProfilePicture(imageView: self.profileImage, imageToSet: UIImage(data:data! as Data)!)
                        }
                    }
                }
            }
        })
        ref.removeAllObservers()
    }
    //get the profile picture and make it round
    func setProfilePicture(imageView: UIImageView, imageToSet: UIImage){
        imageView.image = imageToSet
        imageView.layer.cornerRadius = imageView.bounds.width / 2.0
        imageView.layer.masksToBounds = true
    }
    
    //retrieve buckit data
    func fetchUserBuckIts(){
            let ref = FirebaseDataContoller.sharedInstance.refToFirebase
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
                        self.collectionview.reloadData()
                    }
                }
            }
        })
        ref.removeAllObservers()
    }

    
    //section number
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    //return the number of buckit
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        totalBuckit = self.buckits.count
        numOfBuckIt.text = String(totalBuckit)
        return totalBuckit
    }
    
    //create each cell for each buckit being added
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "buckItCell", for: indexPath) as! BuckitCell
        
        //creating the cell
//        cell.buckitImage.downloadImage(from: self.buckits[indexPath.row].pathToImage)
        let resource = ImageResource(downloadURL: URL(string: self.buckits[indexPath.row].pathToImage)!, cacheKey: self.buckits[indexPath.row].pathToImage)
        cell.buckitImage.kf.setImage(with: resource)
        cell.BuckitName.text = self.buckits[indexPath.row].title
        
        return cell
    }
    //buckit is clickable
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "BuckitList", sender: self.buckits[indexPath.row])
        
    }
    //send data to Buckit list view
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? BucketListViewController{
            if let buckit = sender as? BuckIt{
                //send the selected buckit to the buckitlistview
                destination.buckit = buckit
            }
        }
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

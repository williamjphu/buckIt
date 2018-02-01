//
//  NewActivityViewController.swift
//  BuckIt
//
//  Created by Michael Hyun on 1/31/18.
//  Copyright © 2018 Samnang Sok. All rights reserved.
//

import UIKit
import MapKit
import UITextView_Placeholder

class NewActivityViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var titleText: UITextView!
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var descriptionText: UITextView!
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTitleTextArea()
    }
    
    func setupTitleTextArea(){
        titleText.delegate = self
        titleText.placeholder = "Add a Title..."
        
        descriptionText.delegate = self
        descriptionText.placeholder = "Add a Description..."
        
        profilePic.layer.borderWidth = 1
        profilePic.layer.masksToBounds = false
        profilePic.layer.cornerRadius = self.profilePic.frame.height/2
        profilePic.clipsToBounds = true
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

//
//  ActivityProfileViewController.swift
//  BuckIt
//
//  Created by Michael Hyun on 4/15/18.
//  Copyright © 2018 Samnang Sok. All rights reserved.
//

import UIKit

class ActivityProfileViewController: UIViewController {
    var activity = Activity()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func addToBucketPressed(_ sender: Any) {
        performSegue(withIdentifier: "addToBuckit", sender: self.activity)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? addToBucketViewController{
            if let activity = sender as? Activity{
                //send the selected buckit to the buckitlistview
                destination.activity = activity
            }
        }
    }
    
    

}

//
//  TableViewCell.swift
//  BuckIt
//
//  Created by Samnang Sok on 1/21/18.
//  Copyright © 2018 Samnang Sok. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var bucketImage: UIImageView!
    @IBOutlet weak var bucketLabel: UILabel!

    @IBOutlet weak var followerImage: UIImageView!
    @IBOutlet weak var fwerLabel: UILabel!

    
    @IBOutlet weak var followingImage: UIImageView!
    @IBOutlet weak var fwingLabel: UILabel!
    
    var userId: String!

}

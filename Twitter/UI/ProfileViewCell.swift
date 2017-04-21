//
//  ProfileViewCell.swift
//  Twitter
//
//  Created by yanze on 4/21/17.
//  Copyright © 2017 yanzeliu. All rights reserved.
//

import UIKit

class ProfileViewCell: UITableViewCell {

   
    @IBOutlet weak var retweetedBy: UILabel!
    @IBOutlet weak var userProfileImgView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenName: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var favoCountLabel: UILabel!

    var tweet: Tweet? {
        didSet {
            
        }
    }
    

}

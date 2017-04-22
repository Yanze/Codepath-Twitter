//
//  ProfileViewCell.swift
//  Twitter
//
//  Created by yanze on 4/21/17.
//  Copyright © 2017 yanzeliu. All rights reserved.
//

import UIKit
import AFNetworking

class ProfileViewCell: UITableViewCell {

    @IBOutlet weak var userProfileImgView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var favoCountLabel: UILabel!

    var tweet: Tweet? {
        didSet {
            
            if let name = tweet?.retweetedStatus?.originalTweetUser?.name {
                nameLabel.text = name
            }
            if let discrip = tweet?.retweetedStatus?.tweetText {
                tweetTextLabel.text = discrip
            }
            if let screenName = tweet?.retweetedStatus?.originalTweetUser?.screenName {
                screenNameLabel.text = "@\(screenName)"
            }
            if let imgLink = tweet?.retweetedStatus?.originalTweetUser?.profileUrl {
                userProfileImgView.setImageWith(imgLink)
            }
            if let retweetCount = tweet?.retweetCount {
                retweetCountLabel.text = String(retweetCount)
            }
            if let favoCount = tweet?.favoCount {
                favoCountLabel.text = String(favoCount)
            }
            if let createdAt = tweet?.createdAt {
                timeLabel.text = timeAgoSince(createdAt)
            }
            
            
        }
    }
    

}

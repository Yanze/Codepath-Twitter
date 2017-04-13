//
//  TweetCell.swift
//  Twitter
//
//  Created by yanze on 4/12/17.
//  Copyright © 2017 yanzeliu. All rights reserved.
//

import UIKit
import AFNetworking


class TweetCell: UITableViewCell {
    
    @IBOutlet weak var retweetedByLabel: UILabel!
    @IBOutlet weak var userProfileImgView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var userIdLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var likeCountLabel: UILabel!
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var replyCountLabel: UILabel!
    

    var tweet: Tweet? {
        didSet {

            let userName = tweet?.user?["name"] as? String
            if let name = userName {
                nameLabel.text = name
            }
            
            if let text =  tweet?.text {
                tweetTextLabel.text = text
            }
            
            if let imgLink = tweet?.user?["profile_image_url"] as? String {
                print(imgLink)
                userProfileImgView.setImageWith(URL(string:imgLink)!)
            }
            
            if let likes = tweet?.favoCount {
                likeCountLabel.text = String(likes)
            }
            
            if let retweets = tweet?.retweetCount {
                retweetCountLabel.text = String(retweets)
            }
            
            replyCountLabel.text = String(0)
        }
        
        
    }
    

}

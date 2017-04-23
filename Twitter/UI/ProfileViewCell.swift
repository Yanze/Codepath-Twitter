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
            
            let name = (tweet?.isRetweeted)! ? tweet?.retweetedStatus?.originalTweetUser?.name : tweet?.user?.name
            nameLabel.text = name
            
            let tweetText = (tweet?.isRetweeted)! ? tweet?.retweetedStatus?.tweetText : tweet?.text
            tweetTextLabel.text = tweetText

            let screenName = (tweet?.isRetweeted)! ? tweet?.retweetedStatus?.originalTweetUser?.screenName : tweet?.user?.screenName
            if let sname = screenName {
                screenNameLabel.text = "@\(sname)"
            }

            let imgLink = (tweet?.isRetweeted)! ? tweet?.retweetedStatus?.originalTweetUser?.profileUrl : tweet?.user?.profileUrl
            userProfileImgView.setImageWith(imgLink!)

            let retweetCount = (tweet?.isRetweeted)! ? tweet?.retweetedStatus?.retweetCount : tweet?.retweetCount
            if let rtcount = retweetCount {
                retweetCountLabel.text = String(describing: rtcount)
            }
            let favoCount = (tweet?.isRetweeted)! ? tweet?.retweetedStatus?.favoCount : tweet?.favoCount
            if let favCount = favoCount {
               favoCountLabel.text = String(describing: favCount)
            }
   
            let createdAt = (tweet?.isRetweeted)! ? tweet?.retweetedStatus?.createdAt : tweet?.createdAt
            timeLabel.text = timeAgoSince(createdAt!)            
            
        }
    }
    

}

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
//                print(imgLink)
                userProfileImgView.setImageWith(URL(string:imgLink)!)
            }
            
            if let likes = tweet?.favoCount {
                likeCountLabel.text = String(likes)
            }
            
            if let retweets = tweet?.retweetCount {
                retweetCountLabel.text = String(retweets)
            }
            
            replyCountLabel.text = String(0)
            
            if let theDate = tweet?.createdAt {
//                print("time: \(theDate), timeago: \(timeAgoSince(theDate))")
                timeLabel.text = timeAgoSince(theDate)
            }
            
            
        }
        
        
    }
    
 

}

public func timeAgoSince(_ date: Date) -> String {
    
    let calendar = Calendar.current
    let now = Date()
    let unitFlags: NSCalendar.Unit = [.second, .minute, .hour, .day, .weekOfYear, .month, .year]
    let components = (calendar as NSCalendar).components(unitFlags, from: date, to: now, options: [])
    
    if let year = components.year, year >= 2 {
        return "\(year) years ago"
    }
    
    if let year = components.year, year >= 1 {
        return "Last year"
    }
    
    if let month = components.month, month >= 2 {
        return "\(month) months ago"
    }
    
    if let month = components.month, month >= 1 {
        return "Last month"
    }
    
    if let week = components.weekOfYear, week >= 2 {
        return "\(week) weeks ago"
    }
    
    if let week = components.weekOfYear, week >= 1 {
        return "Last week"
    }
    
    if let day = components.day, day >= 2 {
        return "\(day) days ago"
    }
    
    if let day = components.day, day >= 1 {
        return "Yesterday"
    }
    
    if let hour = components.hour, hour >= 2 {
        return "\(hour) hours ago"
    }
    
    if let hour = components.hour, hour >= 1 {
        return "An hour ago"
    }
    
    if let minute = components.minute, minute >= 2 {
        return "\(minute) minutes ago"
    }
    
    if let minute = components.minute, minute >= 1 {
        return "A minute ago"
    }
    
    if let second = components.second, second >= 3 {
        return "\(second) seconds ago"
    }
    
    return "Just now"
    
}

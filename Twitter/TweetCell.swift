//
//  TweetCell.swift
//  Twitter
//
//  Created by yanze on 4/12/17.
//  Copyright © 2017 yanzeliu. All rights reserved.
//

import UIKit
import AFNetworking

protocol RetweetDelegate {
    func cellRetweetButtonPressed(tweet: Tweet, cell: TweetCell)
}

protocol UnRetweetDelegate {
    func cellUnRetweet(tweet: Tweet, cell: TweetCell)
}

protocol FavoriteDelegate {
    func favoriteTweetButtonPressed(tweet: Tweet, cell: TweetCell)
}

protocol UnFavoTweetDelegate {
    func unfavoTweetButtonPressed(tweet: Tweet, cell: TweetCell)
}

protocol ReplyDelegate {
    func replyButtonPressed(tweet: Tweet, cell: TweetCell)
}


class TweetCell: UITableViewCell, DetailViewRetweetDelegate, DetailViewLikesDelegate {
    
    var retweetDelegate: RetweetDelegate?
    var favoTweetDelegate: FavoriteDelegate?
    var replyTweetDelegate: ReplyDelegate?
    
    var unRetweetDelegate: UnRetweetDelegate?
    var unFavoTweetDelegate: UnFavoTweetDelegate?
    
    @IBOutlet weak var userProfileImgView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var userIdLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var likeCountLabel: UILabel!
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var replyCountLabel: UILabel!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    
    
    @IBAction func retweetMessage(_ sender: UIButton) {
        if !(tweet?.isRetweeted)! {
            self.retweetDelegate?.cellRetweetButtonPressed(tweet: tweet!, cell: self)
        }else {
            self.unRetweetDelegate?.cellUnRetweet(tweet: tweet!, cell: self)
        }
       
    }
    
    @IBAction func favoriteTweet(_ sender: UIButton) {
        if !(tweet?.isFavorited)! {
            self.favoTweetDelegate?.favoriteTweetButtonPressed(tweet: tweet!, cell: self)
        }
        else {
            self.unFavoTweetDelegate?.unfavoTweetButtonPressed(tweet: tweet!, cell: self)
        }
    }
    
    @IBAction func replyButtonPressed(_ sender: UIButton) {
        self.replyTweetDelegate?.replyButtonPressed(tweet: tweet!, cell: self)
    }
    
    
    func increaseRetweetCount(newcount: Int) {
        tweet?.isRetweeted = true
        tweet?.retweetCount = newcount
        retweetCountLabel.text = String((tweet?.retweetCount)!)
        retweetButton.setImage(UIImage(named: "retweet@2xgreen"), for: .normal)
    }
    
    func decreaseRetweetCount(newcount: Int) {
        tweet?.isRetweeted = false
        tweet?.retweetCount = newcount
        retweetCountLabel.text = String((tweet?.retweetCount)!)
        retweetButton.setImage(UIImage(named: "retweet"), for: .normal)
    }
    
    func updateFavoCountAndImageColor(newcount: Int) {
        tweet?.isFavorited = true
        tweet?.favoCount = newcount
        likeCountLabel.text = String((tweet?.favoCount)!)
        likeButton.setImage(UIImage(named: "like-red"), for: .normal)
    }
    
    func decreaseFavoCountAndImageColor(newcount: Int) {
        tweet?.isFavorited = false
        tweet?.favoCount = newcount 
        likeCountLabel.text = String((tweet?.favoCount)!)
        likeButton.setImage(UIImage(named: "like"), for: .normal)
    }
    
    func updateCellRetweetIconState(tweet: Tweet) {
        increaseRetweetCount(newcount: tweet.retweetCount)
    }
    
    func updateCellLikeIconState(tweet: Tweet) {
        updateFavoCountAndImageColor(newcount: tweet.retweetCount)
    }

    var tweet: Tweet? {
        didSet {
            
            userProfileImgView.layer.cornerRadius = 4
            userProfileImgView.layer.masksToBounds = true

            
            if let screenName = tweet?.user?.screenName {
                userIdLabel.text = "@\(screenName)"
            }
            
            if let name = tweet?.user?.name{
                nameLabel.text = name
            }
            
            if let text =  tweet?.text {
                tweetTextLabel.text = text
            }
            
            if let imgLink = tweet?.user?.profileUrl {
                userProfileImgView.setImageWith(imgLink)
            }
            
            if let likes = tweet?.favoCount {
                likeCountLabel.text = String(likes)
            }
            
            if let retweets = tweet?.retweetCount {
                retweetCountLabel.text = String(retweets)
            }
            
            if (tweet?.isRetweeted)! {
                retweetButton.setImage(UIImage(named: "retweet@2xgreen"), for: .normal)
            }else {
                retweetButton.setImage(UIImage(named: "retweet"), for: .normal)
            }
            
            if (tweet?.isFavorited)! {
                likeButton.setImage(UIImage(named: "like-red"), for: .normal)
            }else {
                likeButton.setImage(UIImage(named: "like"), for: .normal)
            }
            
            replyCountLabel.text = String(0)
            
            if let theDate = tweet?.createdAt {
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

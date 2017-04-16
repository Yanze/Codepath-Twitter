//
//  DetailViewController.swift
//  Twitter
//
//  Created by yanze on 4/13/17.
//  Copyright © 2017 yanzeliu. All rights reserved.
//

import UIKit
import AFNetworking

protocol DetailViewRetweetDelegate {
    func updateCellRetweetIconState(tweet: Tweet)
}

protocol DetailViewLikesDelegate {
    func updateCellLikeIconState(tweet: Tweet)
}

class DetailViewController: UIViewController {
    
    @IBOutlet weak var userProfileImgView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var createdAtLabel: UILabel!
    @IBOutlet weak var favoCountLabel: UILabel!
    @IBOutlet weak var retweetsCountLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!

    
    
    var tweet: Tweet!
    var detailviewRetweetDelegate: DetailViewRetweetDelegate?
    var detailviewLikesDelegate: DetailViewLikesDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUserProfileImg()
        setupNameLabel()
        setupTweetTime()
        setuptext()
        setupRetweetsandFavoCount()
        
    }
    
    @IBAction func retweetButtonPressed(_ sender: UIButton) {
        TwitterClient.sharedInstance?.retweetMessage(tweet.id!, success: { (tweet) in
            DispatchQueue.main.async {
                self.retweetsCountLabel.text =  String(tweet.retweetCount)
                self.detailviewRetweetDelegate?.updateCellRetweetIconState(tweet: tweet)
            }
        }, failure: { (error) in
            print(error)
        })
    }
    
    @IBAction func replyButtonPressed(_ sender: UIButton) {

    }
    
    
    @IBAction func likeButtonPressed(_ sender: UIButton) {
        TwitterClient.sharedInstance?.favoriteTweet(tweet.id!, success: { (tweet) in
            DispatchQueue.main.async {
                self.favoCountLabel.text =  String(tweet.favoCount)
                self.detailviewLikesDelegate?.updateCellLikeIconState(tweet: tweet)
            }
        }, failure: { (error) in
            print(error)
        })
    }
    
    
    func setupUserProfileImg() {
        userProfileImgView.layer.cornerRadius = 4
        userProfileImgView.layer.masksToBounds = true
        if let imgLink = tweet.user?.profileUrl {
            userProfileImgView.setImageWith(imgLink)
        }
    }
    
    func setupNameLabel() {
        if let name = tweet.user?.name {
            nameLabel.text = name
        }
        if let username = tweet.user?.screenName {
            usernameLabel.text = username
        }
    }
    
    func setupTweetTime() {
        if let tweetTime = tweet.createdAt {
            let formatter = DateFormatter()
            formatter.dateFormat = "MM/dd/yyyy, h:mm a "
            formatter.amSymbol = "AM"
            formatter.pmSymbol = "PM"
            
            let dateStr = formatter.string(from: tweetTime)
            createdAtLabel.text = dateStr
        }
    }
    
    func setuptext() {
        if let tweetText = tweet.text {
            tweetTextLabel.text = tweetText
        }
    }
    
    func setupRetweetsandFavoCount() {
        retweetsCountLabel.text =  String(tweet.retweetCount)
        favoCountLabel.text = String(tweet.favoCount)
    }
    

}


    
    

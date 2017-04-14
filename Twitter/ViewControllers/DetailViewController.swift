//
//  DetailViewController.swift
//  Twitter
//
//  Created by yanze on 4/13/17.
//  Copyright © 2017 yanzeliu. All rights reserved.
//

import UIKit
import AFNetworking

class DetailViewController: UIViewController {
    
    @IBOutlet weak var userProfileImgView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var createdAtLabel: UILabel!
    @IBOutlet weak var favoCountLabel: UILabel!
    @IBOutlet weak var retweetsCountLabel: UILabel!
    
    
    var tweet: Tweet!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUserProfileImg()
        setupNameLabel()
        setupTweetTime()
        setuptext()
        setupRetweetsandFavoCount()

    }

    func setupUserProfileImg() {
        userProfileImgView.layer.cornerRadius = 4
        userProfileImgView.layer.masksToBounds = true
        if let imgLink = tweet.user?["profile_image_url_https"] as? String {
            userProfileImgView.setImageWith(URL(string: imgLink)!)
        }
    }
    
    func setupNameLabel() {
        if let name = tweet.user?["name"] as? String {
            nameLabel.text = name
        }
        if let username = tweet.user?["screen_name"] as? String {
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

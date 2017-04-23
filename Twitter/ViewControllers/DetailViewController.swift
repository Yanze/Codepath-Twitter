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

    
    var activeTextField: UITextField?
    var tweet: Tweet!
    var detailviewRetweetDelegate: DetailViewRetweetDelegate?
    var detailviewLikesDelegate: DetailViewLikesDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUserProfileImg()
        propulateData()
        setupTweetTime()
        setupRetweetsandFavoCount()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupIconColor()
    }
    
    @IBAction func retweetButtonPressed(_ sender: UIButton) {
        if tweet.isRetweeted! {
            TwitterClient.sharedInstance?.untweetMessage(tweet.id!, success: { (tweet) in
                DispatchQueue.main.async {
                    tweet.isRetweeted = false
                    self.retweetsCountLabel.text =  String(tweet.retweetCount - 1)
                    self.retweetButton.setImage(UIImage(named: "retweet"), for: .normal)
                    self.detailviewRetweetDelegate?.updateCellRetweetIconState(tweet: tweet)
                }
                
            }, failure: { (error) in
                print(error)
            })
            
        }else {
            TwitterClient.sharedInstance?.retweetMessage(tweet.id!, success: { (tweet) in
                DispatchQueue.main.async {
                    tweet.isRetweeted = true
                    self.retweetsCountLabel.text =  String(tweet.retweetCount)
                    self.retweetButton.setImage(UIImage(named: "retweet@2xgreen"), for: .normal)
                    self.detailviewRetweetDelegate?.updateCellRetweetIconState(tweet: tweet)
                }
            }, failure: { (error) in
                print(error)
            })
        }
    }
    
    @IBAction func replyButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "enterReplyMessageSegue", sender: nil)
    }
    
    
    @IBAction func likeButtonPressed(_ sender: UIButton) {
        if tweet.isFavorited! {
            TwitterClient.sharedInstance?.unfavoriteTweet(tweet.id!, success: { (tweet) in
                DispatchQueue.main.async {
                    tweet.isFavorited = false
                    self.favoCountLabel.text =  String(tweet.favoCount)
                    self.likeButton.setImage(UIImage(named: "like"), for: .normal)
                    self.detailviewLikesDelegate?.updateCellLikeIconState(tweet: tweet)
                }
            }, failure: { (error) in
                print(error)
            })
        }
        else {
            TwitterClient.sharedInstance?.favoriteTweet(tweet.id!, success: { (tweet) in
                DispatchQueue.main.async {
                    tweet.isFavorited = true
                    self.favoCountLabel.text =  String(tweet.favoCount)
                    self.likeButton.setImage(UIImage(named: "like-red"), for: .normal)
                    self.detailviewLikesDelegate?.updateCellLikeIconState(tweet: tweet)
                }
            }, failure: { (error) in
                print(error)
            })
        }
    }
    
    func setupIconColor() {
        if tweet.isRetweeted! {
            self.retweetButton.setImage(UIImage(named: "retweet@2xgreen"), for: .normal)
        }else {
            self.retweetButton.setImage(UIImage(named: "retweet"), for: .normal)
        }
        
        if tweet.isFavorited! {
            self.likeButton.setImage(UIImage(named: "like-red"), for: .normal)
        }else {
            self.likeButton.setImage(UIImage(named: "like"), for: .normal)
        }
    }
    
    
    func setupUserProfileImg() {
        userProfileImgView.layer.cornerRadius = 4
        userProfileImgView.layer.masksToBounds = true

        if tweet.retweetedStatus?.originalTweetUser?.profileUrl != nil {
            userProfileImgView.setImageWith((tweet.retweetedStatus?.originalTweetUser?.profileUrl)!)
        }else {
            userProfileImgView.setImageWith((tweet.user?.profileUrl)!)
        }
    }
    
    func propulateData() {
        let name = tweet.isRetweeted! ? tweet.retweetedStatus?.originalTweetUser?.name : tweet.user?.name
        nameLabel.text = name
        
        let screenName = tweet.isRetweeted! ? tweet.retweetedStatus?.originalTweetUser?.screenName : tweet.user?.screenName
        if let sname = screenName {
            usernameLabel.text = "@\(sname)"
        }
        let tweetText = tweet.isRetweeted! ? tweet.retweetedStatus?.tweetText : tweet.text
        tweetTextLabel.text = tweetText

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

    
    func setupRetweetsandFavoCount() {
        retweetsCountLabel.text =  String(tweet.retweetCount)
        favoCountLabel.text = String(tweet.favoCount)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "enterReplyMessageSegue" {
            let vc = segue.destination as! EnterReplyMessageViewController
            vc.tweet = tweet
        }
    }
    

}


    
    

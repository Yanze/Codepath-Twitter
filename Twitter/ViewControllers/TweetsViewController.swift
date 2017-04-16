//
//  TweetsViewController.swift
//  Twitter
//
//  Created by yanze on 4/12/17.
//  Copyright © 2017 yanzeliu. All rights reserved.
//

import UIKit
import DGElasticPullToRefresh
import SVProgressHUD




class TweetsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, InsertTweetDelegate, RetweetDelegate, FavoriteDelegate, ReplyDelegate, UnRetweetDelegate, UnFavoTweetDelegate {


    @IBOutlet weak var tableView: UITableView!


    var tweets: [Tweet]!
    var tweetfromReply: Tweet?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self

        getAllTweets()
        pullToRefresh()

    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        TwitterClient.sharedInstance?.homeTimeline(success: { (tweets: [Tweet]) in
//            self.tweets = tweets
//            self.tableView.reloadData()
//        }, failure: { (error: NSError) in
//            print(error.localizedDescription)
//        })
//    }


    func pullToRefresh() {
        navigationController?.navigationBar.barTintColor = UIColor(red: 29/255, green: 161/255, blue: 242/255, alpha: 1)
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]

        let loadingView = DGElasticPullToRefreshLoadingViewCircle()
        loadingView.tintColor = UIColor(red: 29/255, green: 161/255, blue: 242/255, alpha: 1)

        tableView.dg_addPullToRefreshWithActionHandler({ [weak self] () -> Void in
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(1.5 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: {
                TwitterClient.sharedInstance?.homeTimeline(success: { (tweets: [Tweet]) in
                    self?.tweets = tweets
                    self?.tableView.reloadData()

                }, failure: { (error: NSError) in
                    print(error.localizedDescription)
                })

                self?.tableView.dg_stopLoading()
            })
            }, loadingView: loadingView)
        tableView.dg_setPullToRefreshFillColor(UIColor(red: 225/255, green: 232/255, blue: 237/255, alpha: 1))
        tableView.dg_setPullToRefreshBackgroundColor(tableView.backgroundColor!)
    }

    deinit {
        tableView.dg_removePullToRefresh()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        SVProgressHUD.dismiss()
    }

    func getAllTweets() {
        SVProgressHUD.show()
        TwitterClient.sharedInstance?.homeTimeline(success: { (tweets: [Tweet]) in
            self.tweets = tweets
            self.tableView.reloadData()
            SVProgressHUD.dismiss()

        }, failure: { (error: NSError) in
            print(error.localizedDescription)
        })
    }
    

    @IBAction func logout(_ sender: UIButton) {
        TwitterClient.sharedInstance?.logout()
    }

    func InsertTweet(tweet: Tweet) {
        tweets.insert(tweet, at: 0)
        tableView.reloadData()
    }
    
    

}

extension TweetsViewController {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tweets == nil {
            return 0
        }
        return tweets.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tweetCell", for: indexPath) as! TweetCell
        cell.tweet = tweets[indexPath.row]
        cell.retweetDelegate = self
        cell.favoTweetDelegate = self
        cell.replyTweetDelegate = self
        cell.unRetweetDelegate = self
        cell.unFavoTweetDelegate = self
        return cell

    }
    
    func cellRetweetButtonPressed(tweet: Tweet, cell: TweetCell) {
        TwitterClient.sharedInstance?.retweetMessage(tweet.id!, success: { (tweet) in
            cell.increaseRetweetCount()
        }, failure: { (error) in
            print(error)
        })
    }
    
    func favoriteTweetButtonPressed(tweet: Tweet, cell: TweetCell) {
        TwitterClient.sharedInstance?.favoriteTweet(tweet.id!, success: { (tweet) in
            cell.updateFavoCountAndImageColor()
        }, failure: { (error) in
            print(error)
        })
    }
    
    func replyButtonPressed(tweet: Tweet, cell: TweetCell) {
        tweetfromReply = tweet
        performSegue(withIdentifier: "replySegue", sender: nil)
    }
    
    func cellUnRetweet(tweet: Tweet, cell: TweetCell) {
        TwitterClient.sharedInstance?.untweetMessage(tweet.id!, success: { (tweet) in
            cell.decreaseRetweetCount()
        }, failure: { (error) in
            print("TweetsVC unretweet error: \(error.localizedDescription)")
        })
        
    }
    
    func unfavoTweetButtonPressed(tweet: Tweet, cell: TweetCell) {
        TwitterClient.sharedInstance?.unfavoriteTweet(tweet.id!, success: { (tweet) in
            cell.decreaseFavoCountAndImageColor()
        }, failure: { (error) in
            print("TweetsVC unfavo tweet error: \(error.localizedDescription)")
        })
    }
    
//    func showActionSheet(tweet: Tweet, cell: TweetCell) {
//        let actionSheet = UIAlertController()
//        let retweet = UIAlertAction(title: "Retweet", style: UIAlertActionStyle.default) {(ACTION) in
//            // retweet
//            TwitterClient.sharedInstance?.retweetMessage(tweet.id!, success: { (tweet) in
//                cell.increaseRetweetCount()
//            }, failure: { (error) in
//                print(error)
//            })
//        }
//        let cancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) {(ACTION) in}
//        
//        actionSheet.addAction(retweet)
//        actionSheet.addAction(cancel)
//        self.present(actionSheet, animated: true, completion: nil)
//    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "tweetDetailSegue" {
            let vc = segue.destination as! DetailViewController
            if let indexPath = tableView.indexPathForSelectedRow {
                vc.tweet = self.tweets[indexPath.row]
                let cell = tableView.cellForRow(at: tableView.indexPathForSelectedRow!)
                vc.detailviewRetweetDelegate = cell as? DetailViewRetweetDelegate
                vc.detailviewLikesDelegate = cell as? DetailViewLikesDelegate

            }
        }
        else if segue.identifier == "composeSegue" {
            let composeVc = segue.destination as! ComposeViewController
            composeVc.delegate = self
        }
        else if segue.identifier == "replySegue" {
            let vc = segue.destination as! DetailViewController
            vc.tweet = tweetfromReply
        }
        
    }

}

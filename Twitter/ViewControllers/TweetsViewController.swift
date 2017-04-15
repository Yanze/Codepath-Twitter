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




class TweetsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, InsertTweetDelegate, RetweetDelegate, FavoriteDelegate {


    @IBOutlet weak var tableView: UITableView!


    var tweets: [Tweet]!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self

        getAllTweets()
        pullToRefresh()

    }


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
        return cell

    }
    
    func cellRetweetButtonPressed(tweet: Tweet) {
        showActionSheet(tweet: tweet)
    }
    
    func favoriteTweet(tweet: Tweet) {
        TwitterClient.sharedInstance?.favoriteTweet(tweet.id!)
    }
    
    func showActionSheet(tweet: Tweet) {
        let actionSheet = UIAlertController()
        let retweet = UIAlertAction(title: "Retweet", style: UIAlertActionStyle.default) {(ACTION) in
            // retweet
            TwitterClient.sharedInstance?.retweetMessage(tweet.id!)
        }
        let cancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) {(ACTION) in}
        
        actionSheet.addAction(retweet)
        actionSheet.addAction(cancel)
        self.present(actionSheet, animated: true, completion: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "tweetDetailSegue" {
            let vc = segue.destination as! DetailViewController

            if let indexPath = tableView.indexPathForSelectedRow {
                vc.tweet = self.tweets[indexPath.row]
            }

        }
        else if segue.identifier == "composeSegue" {
            let composeVc = segue.destination as! ComposeViewController
            composeVc.delegate = self
        }
    }

}

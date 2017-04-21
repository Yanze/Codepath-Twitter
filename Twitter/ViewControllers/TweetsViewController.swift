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




class TweetsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, InsertTweetDelegate, RetweetDelegate, FavoriteDelegate, ReplyDelegate, UnRetweetDelegate, UnFavoTweetDelegate, SideBardelegate  {


    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var leftBarItem: UIBarButtonItem!


    var tweets: [Tweet]!
    var tweetfromReply: Tweet?
    var sideBar = SideBar()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self

        sideBar = SideBar(sourceView: view, menuItems: ["Profile", "Timeline", "Mentioned", "Log out"])
        sideBar.delegate = self
        
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
    
    func sideBarModeChanged(_ mode: Bool) {
        view.layoutIfNeeded()
        leftBarItem.tintColor = mode ? .clear : .white
    }

    func sideBarDidSelecteButtonAtIndex(_ index: Int) {
        switch (index) {
        case 0:
            let profileVc = self.storyboard?.instantiateViewController(withIdentifier: "profileVC")
            self.navigationController?.pushViewController(profileVc!, animated: true)
        case 1:
            let timelineVc = self.storyboard?.instantiateViewController(withIdentifier: "timelineVC")
            self.navigationController?.pushViewController(timelineVc!, animated: true)
//        case 2:
            
        case 3:
            logout()
            break;
        default:
            break;
        }
    }
    
    func logout() {
        TwitterClient.sharedInstance?.logout()
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
            cell.increaseRetweetCount(newcount: tweet.retweetCount)
            print("ReTweet: \(tweet.retweetCount)")
        }, failure: { (error) in
            print(error)
        })
    }
    
    func cellUnRetweet(tweet: Tweet, cell: TweetCell) {
        TwitterClient.sharedInstance?.untweetMessage(tweet.id!, success: { (tweet) in
            cell.decreaseRetweetCount(newcount: tweet.retweetCount - 1)
            print("unReTweet: \(tweet.retweetCount)")
        }, failure: { (error) in
            print("TweetsVC unretweet error: \(error.localizedDescription)")
        })
        
    }
    
    func favoriteTweetButtonPressed(tweet: Tweet, cell: TweetCell) {
        TwitterClient.sharedInstance?.favoriteTweet(tweet.id!, success: { (tweet) in
            cell.updateFavoCountAndImageColor(newcount: tweet.favoCount)
        }, failure: { (error) in
            print(error)
        })
    }
    
    func unfavoTweetButtonPressed(tweet: Tweet, cell: TweetCell) {
        TwitterClient.sharedInstance?.unfavoriteTweet(tweet.id!, success: { (tweet) in
            cell.decreaseFavoCountAndImageColor(newcount: tweet.favoCount)
        }, failure: { (error) in
            print("TweetsVC unfavo tweet error: \(error.localizedDescription)")
        })
    }
    
    func replyButtonPressed(tweet: Tweet, cell: TweetCell) {
        tweetfromReply = tweet
        performSegue(withIdentifier: "replySegue", sender: nil)
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

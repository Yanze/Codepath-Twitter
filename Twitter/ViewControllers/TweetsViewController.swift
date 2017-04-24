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




class TweetsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, InsertTweetDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var leftBarItem: UIBarButtonItem!
    
    enum TweetDataSourceType {
        case timeLine
        case mentions
    }
    
    var tweets: [Tweet]!
    var tweetfromReply: Tweet?
    var sideBar = SideBar()
    var tweetDataSourceType: TweetDataSourceType = .timeLine
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self

        sideBar = SideBar(sourceView: view, menuItems: ["Profile", "Timeline", "Mentioned", "Log out"])
        sideBar.delegate = self
        
        if tweetDataSourceType == .timeLine {
            getAllTweets()
            self.navigationItem.title = "Timeline"
        }else if tweetDataSourceType == .mentions {
            getAllMentions()
            self.navigationItem.title = "Mentions"
        }
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

    func InsertTweet(tweet: Tweet) {
        tweets.insert(tweet, at: 0)
        tableView.reloadData()
    }
    
    func getAllMentions() {
        TwitterClient.sharedInstance?.getMentions(completionHandler: { (tweets) in
            self.tweets = tweets
            self.tableView.reloadData()
        })
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
        cell.tweetDelegate = self
        return cell

    }

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

extension TweetsViewController: SideBardelegate {
    func sideBarModeChanged(_ mode: Bool) {
        view.layoutIfNeeded()
        leftBarItem.tintColor = mode ? .clear : .white
    }
    
    func sideBarDidSelecteButtonAtIndex(_ index: Int) {
        Helpers.sharedInstance.shiftViewControllers(index, navController: self.navigationController!)
    }
}

extension TweetsViewController:  TweetDelegate{
    func userProfileImageTapped(screenName: String) {
        let profileVc = self.storyboard?.instantiateViewController(withIdentifier: "profileVC") as! ProfileViewController
        profileVc.screenName = screenName
        self.navigationController?.pushViewController(profileVc, animated: true)
    }
    
    func cellRetweetButtonPressed(tweet: Tweet, cell: TweetCell) {
        TwitterClient.sharedInstance?.retweetMessage(tweet.id!, success: { (tweet) in
            cell.increaseRetweetCount(newcount: tweet.retweetCount)
        }, failure: { (error) in
            print(error)
        })
    }
    
    func cellUnRetweet(tweet: Tweet, cell: TweetCell) {
        TwitterClient.sharedInstance?.untweetMessage(tweet.id!, success: { (tweet) in
            cell.decreaseRetweetCount(newcount: tweet.retweetCount - 1)
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
}

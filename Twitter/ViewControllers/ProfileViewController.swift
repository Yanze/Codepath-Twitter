//
//  ProfileViewController.swift
//  Twitter
//
//  Created by yanze on 4/20/17.
//  Copyright © 2017 yanzeliu. All rights reserved.
//

import UIKit
import AFNetworking
import SVProgressHUD

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var dividerView1: UIView!

    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var containsTableView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    
    @IBOutlet weak var tweetsCountLabel: UILabel!
    @IBOutlet weak var followingsCountLabel: UILabel!
    @IBOutlet weak var followersCountLabel: UILabel!
    
    @IBOutlet weak var settingsBgView: UIView!
    @IBOutlet weak var usersBgView: UIView!

    enum TweetDataSourceType {
        case currentLoggedInUser
    }
    
    var sideBar = SideBar()
    var user: User?
    var tweets = [Tweet]()
    var tweetDataSourceType: TweetDataSourceType?
    var screenName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        sideBar = SideBar(sourceView: view, menuItems: ["Profile", "Timeline", "Mentioned", "Log out"])
        sideBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        self.navigationItem.hidesBackButton = true

        if tweetDataSourceType == .currentLoggedInUser {
            getUserProfile(screenName: (User.currentUser?.screenName)!)
            getUserTimeLine(screenName: (User.currentUser?.screenName)!)
        }else if screenName != nil {
            getUserProfile(screenName: screenName!)
            getUserTimeLine(screenName: screenName!)
        }
        
    }
    
    func getUserProfile(screenName: String) {
        TwitterClient.sharedInstance?.getCurrentUserProfile(screenName, completionHandler: { (user) in
            self.user = user
            self.setupUserProfile()
            self.tableView.reloadData()
        })
    }
    
    func getUserTimeLine(screenName: String) {
        SVProgressHUD.show()
        TwitterClient.sharedInstance?.getUserTimeline(screenName, count: 20, completionHandler: { (tweets) in
            self.tweets = tweets
            self.tableView.reloadData()
            SVProgressHUD.dismiss()
        })
    }

    func setupUserProfile() {
        if let name = user?.name {
            nameLabel.text = name
        }
        if let screenName = user?.screenName {
            screenNameLabel.text = "@\(screenName)"
        }
        if let profileImgLink = user?.profileUrl {
            userImageView.setImageWith(profileImgLink)
        }
        if let tweetsCount = user?.statuses_count {
            tweetsCountLabel.text = String(tweetsCount)
        }
        if let followingCount = user?.followings_count {
            followingsCountLabel.text = String(followingCount)
        }
        if let followersCount = user?.followers_count {
            followersCountLabel.text = String(followersCount)
        }
    }
    
    func setupUI() {
        userImageView.layer.cornerRadius = 4
        userImageView.layer.masksToBounds = true
        
        tableView.layer.borderColor = UIColor(red: 234/255, green: 234/255, blue: 234/255, alpha: 1).cgColor
        tableView.layer.borderWidth = 1
        
        containsTableView.layer.borderColor = UIColor(red: 234/255, green: 234/255, blue: 234/255, alpha: 1).cgColor
        containsTableView.layer.borderWidth = 1
        
        dividerView1.backgroundColor = UIColor(red: 234/255, green: 234/255, blue: 234/255, alpha: 1)
//        dividerView2.backgroundColor = UIColor(red: 234/255, green: 234/255, blue: 234/255, alpha: 1)
//        deviderView3.backgroundColor = UIColor(red: 234/255, green: 234/255, blue: 234/255, alpha: 1)
        
        settingsBgView.layer.borderWidth = 1.5
        settingsBgView.layer.borderColor = UIColor(red: 234/255, green: 234/255, blue: 234/255, alpha: 1).cgColor
        settingsBgView.layer.cornerRadius = 4
        
        usersBgView.layer.borderWidth = 1.5
        usersBgView.layer.borderColor = UIColor(red: 234/255, green: 234/255, blue: 234/255, alpha: 1).cgColor
        usersBgView.layer.cornerRadius = 4
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "profilePageTweetDetail" {
            let vc = segue.destination as! DetailViewController
            if let indexPath = tableView.indexPathForSelectedRow {
                vc.tweet = self.tweets[indexPath.row]
                
            }
        }
    }
    
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.tweets.isEmpty {
            return 0
        }
        return self.tweets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "profileViewCell", for: indexPath) as! ProfileViewCell
        cell.tweet = self.tweets[indexPath.row]
        return cell
    }
}

extension ProfileViewController: SideBardelegate {
    func sideBarModeChanged(_ mode: Bool) {
        view.layoutIfNeeded()
    }
    
    func sideBarDidSelecteButtonAtIndex(_ index: Int) {
        Helpers.sharedInstance.shiftViewControllers(index, navController: self.navigationController!)
    }
}






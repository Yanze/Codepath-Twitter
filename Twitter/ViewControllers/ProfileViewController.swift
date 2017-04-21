//
//  ProfileViewController.swift
//  Twitter
//
//  Created by yanze on 4/20/17.
//  Copyright © 2017 yanzeliu. All rights reserved.
//

import UIKit
import AFNetworking

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var dividerView1: UIView!
    @IBOutlet weak var dividerView2: UIView!
    @IBOutlet weak var deviderView3: UIView!
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var usersButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var containsTableView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    
    @IBOutlet weak var tweetsCountLabel: UILabel!
    @IBOutlet weak var followingsCountLabel: UILabel!
    @IBOutlet weak var followersCountLabel: UILabel!
    
    @IBOutlet weak var settingsBgView: UIView!
    @IBOutlet weak var usersBgView: UIView!

    var sideBar = SideBar()
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        sideBar = SideBar(sourceView: view, menuItems: ["Profile", "Timeline", "Mentioned", "Log out"])
        sideBar.delegate = self


    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getUserProfile()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getUserProfile() {
        TwitterClient.sharedInstance?.getCurrentUserProfile((User.currentUser?.screenName!)!, completionHandler: { (user) in
            self.user = user
            self.setupUserProfile()
            self.tableView.reloadData()
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
        dividerView2.backgroundColor = UIColor(red: 234/255, green: 234/255, blue: 234/255, alpha: 1)
        deviderView3.backgroundColor = UIColor(red: 234/255, green: 234/255, blue: 234/255, alpha: 1)
        
        settingsBgView.layer.borderWidth = 1.5
        settingsBgView.layer.borderColor = UIColor(red: 234/255, green: 234/255, blue: 234/255, alpha: 1).cgColor
        settingsBgView.layer.cornerRadius = 4
        
        usersBgView.layer.borderWidth = 1.5
        usersBgView.layer.borderColor = UIColor(red: 234/255, green: 234/255, blue: 234/255, alpha: 1).cgColor
        usersBgView.layer.cornerRadius = 4
    }


}

extension ProfileViewController: SideBardelegate {
    func sideBarModeChanged(_ mode: Bool) {
        view.layoutIfNeeded()
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
            Helpers.sharedInstance.logout()
            break;
        default:
            break;
        }
    }
}

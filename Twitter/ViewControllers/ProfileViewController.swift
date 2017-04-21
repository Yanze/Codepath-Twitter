//
//  ProfileViewController.swift
//  Twitter
//
//  Created by yanze on 4/20/17.
//  Copyright © 2017 yanzeliu. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var dividerView1: UIView!
    @IBOutlet weak var dividerView2: UIView!
    @IBOutlet weak var deviderView3: UIView!
    
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var usersButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var containsTableView: UIView!


    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupUI() {
//        settingsButton.layer.borderColor = UIColor.lightGray.cgColor
//        usersButton.layer.borderColor = UIColor.lightGray.cgColor
//        
//        settingsButton.layer.borderWidth = 1.5
//        usersButton.layer.borderWidth = 1.5
        
        userImageView.layer.cornerRadius = 4
        userImageView.layer.masksToBounds = true
        
        tableView.layer.borderColor = UIColor(red: 234/255, green: 234/255, blue: 234/255, alpha: 1).cgColor
        tableView.layer.borderWidth = 1
        
        containsTableView.layer.borderColor = UIColor(red: 234/255, green: 234/255, blue: 234/255, alpha: 1).cgColor
        containsTableView.layer.borderWidth = 1
        
        dividerView1.backgroundColor = UIColor(red: 234/255, green: 234/255, blue: 234/255, alpha: 1)
        dividerView2.backgroundColor = UIColor(red: 234/255, green: 234/255, blue: 234/255, alpha: 1)
        deviderView3.backgroundColor = UIColor(red: 234/255, green: 234/255, blue: 234/255, alpha: 1)
    }


}

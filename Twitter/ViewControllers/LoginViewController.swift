//
//  LoginViewController.swift
//  Twitter
//
//  Created by yanze on 4/11/17.
//  Copyright © 2017 yanzeliu. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class LoginViewController: UIViewController {
    
    
    @IBOutlet var backgroundView: UIView!
    @IBOutlet weak var loginButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginButton.layer.borderWidth = 1.5
        loginButton.layer.borderColor = UIColor.white.cgColor
        loginButton.layer.cornerRadius = 3.5
        backgroundView.backgroundColor = UIColor(red: 29/255, green: 161/255, blue: 242/255, alpha: 1)
    }
    
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        let client = TwitterClient.sharedInstance
        client?.login(success: { 
            print("I logged in")
            self.performSegue(withIdentifier: "loginSegue", sender: nil)
        }) { (error: NSError) in
            print(error)
        }
        
        
        
  
    }
    
    
}

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

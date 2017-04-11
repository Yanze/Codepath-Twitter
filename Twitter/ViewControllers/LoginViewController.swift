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
        let twitterClient = BDBOAuth1SessionManager(baseURL: URL(string:"https://api.twitter.com"), consumerKey: "em562xi6NoYL2dVgn1Is6WvEp", consumerSecret: "sCDrzebRhKSuO7csNJp8IaX66Tey6KJbVstFgqsL2SOym6sPGL")
        
        twitterClient?.deauthorize()
        twitterClient?.fetchRequestToken(withPath: "oauth/request_token", method: "GET", callbackURL: URL(string:"twitterApp://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential!) in

            let url = URL(string:"https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token!)")!
            UIApplication.shared.openURL(url)
            
            
        }, failure: { (error) in
            print("twitter client error in login vc: \(error!.localizedDescription)")
        })
        
        
     
        
    }
    
    
}

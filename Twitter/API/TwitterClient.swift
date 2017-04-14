//
//  TwitterClient.swift
//  Twitter
//
//  Created by yanze on 4/12/17.
//  Copyright © 2017 yanzeliu. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class TwitterClient: BDBOAuth1SessionManager {

    static let sharedInstance = TwitterClient(baseURL: URL(string:"https://api.twitter.com"), consumerKey: "em562xi6NoYL2dVgn1Is6WvEp", consumerSecret: "sCDrzebRhKSuO7csNJp8IaX66Tey6KJbVstFgqsL2SOym6sPGL")

    
    var myLoginSuccess: (() -> ())?
    var myLoginFailure: ((NSError) -> ())?
    
    func homeTimeline(success: @escaping ([Tweet]) -> Void, failure: @escaping (NSError) -> Void) {
        get("1.1/statuses/home_timeline.json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any) in
            
            let tweets = Tweet.tweets(dictionaries: response as! [Dictionary])
            
            success(tweets)
        }, failure: { (task: URLSessionDataTask, error: NSError) in
            failure(error)
        } as? (URLSessionDataTask?, Error) -> Void)
    }
    
//    func postTweetMessage() {
//        var task: URLSessionDataTask!
//        
//        let request = self.requestSerializer.request(withMethod: "POST", urlString: "https://api.twitter.com/1.1/statuses/update.json", parameters: "status=Maybe%20Ok", error: nil)
//        
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//
//        
//        task = self.dataTask(with: request as URLRequest, completionHandler: { (response, responseObject, error) in
//            if let error = error {
//                print(error)
//            }
//            else {
//                print(responseObject as Any)
//            }
//        })
//        task.resume()
//    }
    
    func currentAccount(success: @escaping (User) -> Void, failure: @escaping (NSError) -> Void) {
        get("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any) in
            
            let user = User(dictionary: response as! Dictionary)
            success(user)
   
        }, failure: { (task: URLSessionDataTask?, error: NSError) in
            print("error in twitter client in appdelegate when getting my account info")
            failure(error)
        } as? (URLSessionDataTask?, Error) -> Void)
    }
    
    func login(success:@escaping () -> Void, failure: @escaping (NSError) -> Void) {
        myLoginSuccess = success
        myLoginFailure = failure
        
        TwitterClient.sharedInstance?.deauthorize()
        TwitterClient.sharedInstance?.fetchRequestToken(withPath: "oauth/request_token", method: "GET", callbackURL: URL(string:"twitterApp://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential!) in
            
            let url = URL(string:"https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token!)")!
            UIApplication.shared.openURL(url)
            
            
        }, failure: { (error) in
            print("twitter client error in login vc: \(error!.localizedDescription)")
            self.myLoginFailure?(error! as NSError)
        })
    }
    
    func handleOpenUrl(url: URL) {
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        fetchAccessToken(withPath:"oauth/access_token", method: "POST", requestToken: requestToken, success: { (accessToken: BDBOAuth1Credential!) -> Void in
            self.currentAccount(success: { (user: User) in
                User.currentUser = user
                self.myLoginSuccess?()
            }, failure: { (error: NSError) in
                self.myLoginFailure?(error)
            })
            
        }, failure: { (error) in
            print("twitter client error in appDelegate: \(error!)")
            self.myLoginFailure?(error! as NSError)
        })
    }

    func logout() {
        User.currentUser = nil
        deauthorize()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: User.userDidLogoutNotification), object: nil)
    }

}

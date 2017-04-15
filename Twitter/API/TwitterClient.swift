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
    
    func postTweetMessage(_ tweetMessage: String!, completionHandler: @escaping ([String: Any]) -> Void) {
        let parameters: [String: String] = ["status": tweetMessage]
        
        post("1.1/statuses/update.json", parameters: parameters, progress: nil, success: { (operation, response) in
            completionHandler(["isSuccessful": true, "responseObject": response as Any])
        }) { (operation, error) in
            print("error when post a new tweet: \(error.localizedDescription)")
            completionHandler(["error": error.localizedDescription])
        }

    }
    
    func retweetMessage(_ id: Int, success: @escaping (Tweet) -> Void, failure: @escaping (NSError) -> Void){
        post("1.1/statuses/retweet/\(id).json", parameters: nil, progress: nil, success: { (operation, response) in
            let tweet = Tweet(dictionary: response as! Dictionary)
            success(tweet)
        }) { (operation, error) in
            print("error when retweet: \(error.localizedDescription)")
            failure(error as NSError)
        }
        
    }
    
    func favoriteTweet(_ id: Int) {
        let parameters = ["id": id]
        post("1.1/favorites/create.json", parameters: parameters, progress: nil, success: { (operation, response) in
            print(response as Any)
        }) { (operation, error) in
            print("error when favorite a tweet: \(error.localizedDescription)")
        }
    }
    
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

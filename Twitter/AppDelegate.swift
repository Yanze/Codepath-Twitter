//
//  AppDelegate.swift
//  Twitter
//
//  Created by yanze on 4/11/17.
//  Copyright © 2017 yanzeliu. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    // this function called when app switched via a link, this func handle back the link(token)
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        
        let twitterClient = BDBOAuth1SessionManager(baseURL: URL(string:"https://api.twitter.com"), consumerKey: "em562xi6NoYL2dVgn1Is6WvEp", consumerSecret: "sCDrzebRhKSuO7csNJp8IaX66Tey6KJbVstFgqsL2SOym6sPGL")
        
        twitterClient?.fetchAccessToken(withPath:"oauth/access_token", method: "POST", requestToken: requestToken, success: { (accessToken: BDBOAuth1Credential!) in
//            print(accessToken.token)
            
            twitterClient?.get("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any) in
                
//                let user = User(dictionary: response as! Dictionary)
//                print(user.name!)
//                print(user.screenName!)
//                print(user.profileUrl!)
                
                
                twitterClient?.get("1.1/statuses/home_timeline.json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any) in
                    
                    let tweets = Tweet.tweets(dictionaries: response as! [Dictionary])
                    
                    for tweet in tweets {
                        print(tweet.text as Any)
                    }
                    
                }, failure: { (task, error) in
                    print(error)
                })
                
                
//                print("account:\(response)")
            }, failure: { (task, error) in
                print("error in twitter client in appdelegate when getting my account info")
            })
            
            
        }, failure: { (error) in
            print("twitter client error in appDelegate: \(error!)")
        })
        
        return true
    }


}


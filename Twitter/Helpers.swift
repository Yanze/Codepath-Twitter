//
//  Helpers.swift
//  Twitter
//
//  Created by yanze on 4/15/17.
//  Copyright © 2017 yanzeliu. All rights reserved.
//

import UIKit


class Helpers: NSObject {
    
    static let sharedInstance = Helpers()
    
    func showAlertBox(title: String?, message: String?, preferredStyle: UIAlertControllerStyle?, actionTitle: String?, target: UIViewController) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: preferredStyle!)
        
        let action = UIAlertAction(title: actionTitle, style: UIAlertActionStyle.default, handler: nil)
        alertVC.addAction(action)
        target.present(alertVC, animated: true, completion: nil)
    }
    
    func logout() {
        TwitterClient.sharedInstance?.logout()
    }
    
    func shiftViewControllers(_ index: Int, navController: UINavigationController) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        
        switch (index) {
        case 0:
            let profileVc = sb.instantiateViewController(withIdentifier: "profileVC")
            navController.pushViewController(profileVc, animated: true)
        case 1:
            let timelineVc = sb.instantiateViewController(withIdentifier: "timelineVC") as! TweetsViewController
            timelineVc.tweetDataSourceType = .timeLine
            navController.pushViewController(timelineVc, animated: true)
        case 2:
            let timelineVc = sb.instantiateViewController(withIdentifier: "timelineVC") as! TweetsViewController
            timelineVc.tweetDataSourceType = .mentions
            navController.pushViewController(timelineVc, animated: true)
        case 3:
            Helpers.sharedInstance.logout()
            break;
        default:
            break;
        }
    }
    
}

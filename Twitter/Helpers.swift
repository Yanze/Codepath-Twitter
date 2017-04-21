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
    
}

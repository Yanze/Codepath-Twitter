//
//  User.swift
//  Twitter
//
//  Created by yanze on 4/11/17.
//  Copyright © 2017 yanzeliu. All rights reserved.
//

import UIKit

class User: NSObject {
    
    // stored properties
    var name: String?
    var screenName: String?
    var profileUrl: URL?
    var descrip: String?
    
    var dictionary: [String: Any]?
    static let userDidLogoutNotification = "UserDidLogout"
    
    init(dictionary: Dictionary<String, Any>) {
        self.dictionary = dictionary
        
        name = dictionary["name"] as? String
        screenName = dictionary["screen_name"] as? String
        if let profileUrlString = dictionary["profile_image_url_https"] as? String {
            profileUrl = URL(string: profileUrlString)
        }
        descrip = dictionary["description"] as? String
    }
    
    init(name: String?, screenName: String?, profileUrl: URL?, descrip: String?) {
        self.name = name
        self.screenName = screenName
        self.profileUrl = profileUrl
        self.descrip = descrip
    }
    
    
    static var _currentUser: User?
    class var currentUser: User? {
        get {
            let defaults = UserDefaults.standard
            let userData = defaults.object(forKey: "currentUserData") as? Data
            if let userData = userData {
                let dictionary = try! JSONSerialization.jsonObject(with: userData, options: []) as! Dictionary<String, Any>
                _currentUser = User(dictionary: dictionary)
            }
            return _currentUser
        }
        set(user) {
            let defaults = UserDefaults.standard
            
            if let user = user {
                let data  = try! JSONSerialization.data(withJSONObject: user.dictionary!, options: [])
                defaults.set(data, forKey: "currentUserData")
            }
            else {
                defaults.removeObject(forKey: "currentUserData")
//                defaults.set(nil, forKey: "currentUserData")
            }
            defaults.synchronize()
        }
    }
    
    
}

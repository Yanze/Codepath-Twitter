//
//  RetweetedStatus.swift
//  Twitter
//
//  Created by yanze on 4/21/17.
//  Copyright © 2017 yanzeliu. All rights reserved.
//

import UIKit

class RetweetedStatus: NSObject {
    var tweetText: String?
    var createdAt: Date?
    var retweetCount: Int?
    var favoCount: Int?
    var originalTweetUser: User?
    
    init(dictionary: Dictionary<String, Any>) {
        tweetText = dictionary["text"] as? String
        createdAt = dictionary["created_at"] as? Date
        retweetCount = dictionary["retweet_count"] as? Int
        favoCount = dictionary["favorite_count"] as? Int
        originalTweetUser = User(dictionary: dictionary["user"] as! Dictionary<String, Any>)
    }
}

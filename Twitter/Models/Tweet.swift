//
//  Tweet.swift
//  Twitter
//
//  Created by yanze on 4/11/17.
//  Copyright © 2017 yanzeliu. All rights reserved.
//

import Foundation

class Tweet: NSObject {
    var text: String?
    var createdAt: Date?
    var retweetCount: Int = 0
    var favoCount: Int = 0
    var user: User?

    
    init(dictionary: Dictionary<String, Any>) {
        text = dictionary["text"] as? String
//        dump(dictionary)
        retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
        favoCount = (dictionary["favorite_count"] as? Int) ?? 0
        
        if let createdTime = dictionary["created_at"] as? String {
            let formatter = DateFormatter()
            formatter.dateFormat = "E MMM d HH:mm:ss Z yyyy"
            createdAt = formatter.date(from: createdTime)
        }
        
        user = User(dictionary: (dictionary["user"] as? Dictionary<String, Any>)!)

    }
    
    init(text: String?, createdAt: Date?, retweetCount: Int = 0, favoCount: Int = 0, user: User?) {
        self.text = text
        self.createdAt = createdAt
        self.retweetCount = retweetCount
        self.favoCount = favoCount
        self.user = user
    }
    
    
    static func tweets(dictionaries: [Dictionary<String, Any>]) -> [Tweet] {
        var tweets = [Tweet]()
        
        for dictionary in dictionaries {
            let tweet = Tweet(dictionary: dictionary)
            tweets.append(tweet)
        }
        return tweets
    }
    
}

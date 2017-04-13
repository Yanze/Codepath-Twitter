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
    var user: Dictionary<String, Any>?

    
    init(dictionary: Dictionary<String, Any>) {
        text = dictionary["text"] as? String
        retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
        favoCount = (dictionary["favorites_count"] as? Int) ?? 0
        
        if let createdTime = dictionary["created_at"] as? String {
            let formatter = DateFormatter()
            formatter.dateFormat = "EEE MMM d HH:mm:ss Z Y"
            createdAt = formatter.date(from: createdTime)
        }
        
        user = dictionary["user"] as? Dictionary
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

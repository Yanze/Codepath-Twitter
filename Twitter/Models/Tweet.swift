//
//  Tweet.swift
//  Twitter
//
//  Created by yanze on 4/11/17.
//  Copyright © 2017 yanzeliu. All rights reserved.
//

import Foundation

class Tweet: NSObject {
    var id: Int?
    var text: String?
    var createdAt: Date?
    var retweetCount: Int = 0
    var favoCount: Int = 0
    var isRetweeted: Bool?
    var isFavorited: Bool?
    var user: User?

    
    init(dictionary: Dictionary<String, Any>) {
        id = dictionary["id"] as? Int
        text = dictionary["text"] as? String
        retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
        favoCount = (dictionary["favorite_count"] as? Int) ?? 0
        isRetweeted = dictionary["retweeted"] as? Bool ?? false
        isFavorited = dictionary["favorited"] as? Bool ?? false
        
        if let createdTime = dictionary["created_at"] as? String {
            let formatter = DateFormatter()
            formatter.dateFormat = "E MMM d HH:mm:ss Z yyyy"
            createdAt = formatter.date(from: createdTime)
        }
        
        user = User(dictionary: (dictionary["user"] as? Dictionary<String, Any>)!)

    }
    
    init(text: String?, createdAt: Date?, retweetCount: Int = 0, favoCount: Int = 0, isRetweeted: Bool = false, isFavorited: Bool = false,  user: User?) {
        self.text = text
        self.createdAt = createdAt
        self.retweetCount = retweetCount
        self.favoCount = favoCount
        self.user = user
        self.isRetweeted = isRetweeted
        self.isFavorited = isFavorited
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

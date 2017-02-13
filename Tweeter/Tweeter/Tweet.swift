//
//  Tweet.swift
//  Tweeter
//
//  Created by Naveen Kashyap on 2/2/17.
//  Copyright © 2017 Naveen Kashyap. All rights reserved.
//

import UIKit

class Tweet: NSObject {

    
    var text: String?
    var timestamp: Date?
    var retweetCount: Int = 0
    var favoritesCount: Int = 0
    var username: String?
    var profileImageURLString: String?
    var user: NSDictionary?
    var tweetID: String?
    var userID: String?
    
    init(dictionary: NSDictionary) {
        
        tweetID = dictionary["id_str"] as? String
        text = dictionary["text"] as? String
        retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
        favoritesCount = (dictionary["favourites_count"] as? Int) ?? 0
        user = dictionary["user"] as? NSDictionary
        username = user?["screen_name"] as? String
        userID = user?["id_str"] as? String
        profileImageURLString = user!["profile_image_url_https"] as? String
        
        let timestampString = dictionary["created_at"] as? String
        
        if let timestampString = timestampString {
            let formatter = DateFormatter()
            formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            timestamp = formatter.date(from: timestampString)
        }
    }
    
    func incrementRetweetCount(){
        retweetCount = retweetCount+1
    }
    
    func incrementFavoriteCount(){
        favoritesCount = favoritesCount+1
    }
    
    class func tweetsWithArray(dictionaries: [NSDictionary]) -> [Tweet]{
        var tweets = [Tweet]()
        
        for dictionary in dictionaries {
            let tweet = Tweet(dictionary: dictionary)
            tweets.append(tweet)
        }
        
        return tweets
    }
    
    
}

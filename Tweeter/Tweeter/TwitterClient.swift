//
//  TwitterClient.swift
//  Tweeter
//
//  Created by Naveen Kashyap on 2/2/17.
//  Copyright © 2017 Naveen Kashyap. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class TwitterClient: BDBOAuth1SessionManager {
    
    var loginSuccess: (() -> ())?
    var loginFailure: ((Error) -> ())?
    
    
    static let sharedInstance = TwitterClient(baseURL: URL(string: "https://api.twitter.com")!, consumerKey: "v1edcVJoOP8ubJgU0DMzTxhmh", consumerSecret: "OdeqdCDItJFNTa7FTtmIngRrL9gvhRkxlDPf5vrRty7Iod4PgU")
    
    func handleOpenUrl(url: URL) {
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        TwitterClient.sharedInstance?.fetchAccessToken(withPath: "oauth/access_token", method: "POST", requestToken: requestToken, success: { (accessToken: BDBOAuth1Credential?) -> Void in
            
            self.currentAccount(success: { (user: User) in
                User.currentUser = user
                self.loginSuccess?()
            }, failure: { (error: Error) in
                print("error: \(error.localizedDescription)")
                self.loginFailure?(error)
            })
            
            self.loginSuccess?()
        }) { (error: Error?) in
            self.loginFailure?(error!)
        }

    }
    
    func logout(){
        deauthorize()
        User.currentUser = nil
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: User.userDidLogoutNotification), object: nil)
    }
    
    func login(success: @escaping () -> (), failure: @escaping (Error) -> ()) {
        
        loginSuccess = success
        loginFailure = failure
        
        TwitterClient.sharedInstance?.deauthorize()
        TwitterClient.sharedInstance?.fetchRequestToken(withPath: "oauth/request_token", method: "GET", callbackURL: URL(string: "tweeter://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential?) -> Void in
            
            let url = URL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\((requestToken?.token)!)")!
            UIApplication.shared.open(url)
            
        }, failure: { (error: Error?) in
            print("error: \(error?.localizedDescription)")
            self.loginFailure?(error!)
        })
    }
    
    func homeTimeline( success: @escaping (([Tweet]) -> ()),  failure: @escaping ((Error) -> ())){
        get("1.1/statuses/home_timeline.json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            
            let dictionaries = response as! [NSDictionary]
            
            let tweets = Tweet.tweetsWithArray(dictionaries: dictionaries)
            
            success(tweets)
            
        }) { (task: URLSessionDataTask?, error: Error) in
            failure(error)
        }
    }
    
    func currentAccount(success: @escaping (User) -> (), failure: @escaping (Error) -> ()) {
        get("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            let userDictionary = response as! NSDictionary
            
            let user = User(dictionary: userDictionary)
            success(user)
            
            
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            print("error in : \(error.localizedDescription)")
            failure(error)
        })

    }
    
    func retweet(id: String, success: @escaping () -> (), failure: @escaping (Error) -> ()) {
        let urlString = "1.1/statuses/retweet/" + id + ".json"
        post(urlString, parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            success()
        }) { (task:URLSessionDataTask?, error: Error) in
            failure(error)
        }
    }
    
    func favorite(id: String, success: @escaping () -> (), failure: @escaping (Error) -> ()) {
        let urlString = "1.1/favorites/create.json?id=" + id
        post(urlString, parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            success()
        }) { (task: URLSessionDataTask?, error: Error) in
            failure(error)
        }
    }
    
    func getUser(id: String, success: @escaping (User) -> (), failure: @escaping (Error) -> ()) {
        let urlString = "1.1/users/lookup.json?user_id=" + id
        get(urlString, parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            let userDictionary = response as! [NSDictionary]
            let user = User(dictionary: userDictionary[0])
            success(user)
        }) { (task:URLSessionDataTask?, error: Error) in
            failure(error)
        }
    
    }
    
    func getMobileBanner(id: String , success: @escaping (String) -> (), failure: @escaping (Error) -> ()) {
        let urlString = "1.1/users/profile_banner.json?user_id=" + id
        get(urlString, parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            let banners = response as! NSDictionary
            let sizes = banners["sizes"] as! NSDictionary
            let mobile = sizes["mobile"] as! NSDictionary
            let urlString = mobile["url"] as! String
            success(urlString)
        }) { (task:URLSessionDataTask?, error: Error) in
            failure(error)
        }

    }
    
    func sendTweet(status: String, inReplyToID: String?, success: @escaping () -> (), failure: @escaping (Error) -> ()) {
        var urlString = "1.1/statuses/update.json?status=" + status.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        print(urlString)
        if inReplyToID != nil {
            urlString += "&in_reply_to_status_id=" + inReplyToID!
        }
        print(urlString)
        post(urlString, parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            success()
        }) { (task: URLSessionDataTask?, error: Error) in
            print(error.localizedDescription)
        }
    }

}

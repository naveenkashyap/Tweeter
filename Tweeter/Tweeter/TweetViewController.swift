
//
//  TweetViewController.swift
//  Tweeter
//
//  Created by Naveen Kashyap on 2/11/17.
//  Copyright © 2017 Naveen Kashyap. All rights reserved.
//

import UIKit


class TweetViewController: UIViewController {
    
    var tweet: Tweet! {
        didSet{
            tweetID = tweet.tweetID
        }
    }
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var numRTLabel: UILabel!
    @IBOutlet weak var numFavLabel: UILabel!
    var tweetID: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupTweet()
        
    }
    
    func setupTweet(){
        
        let user = tweet.user
        let profileURLString = tweet.profileImageURLString
        let profileImageURL = URL(string: profileURLString!)!
        profileImageView.setImageWith(profileImageURL)
        
        nameLabel.text = user?["name"] as! String?
        usernameLabel.text = tweet.username
        tweetLabel.text = tweet.text
        
        if let timestamp = tweet.timestamp {
            let calendar = Calendar.current
            let hour = calendar.component(.hour, from: timestamp)
            let minutes = calendar.component(.minute, from: timestamp)
            let seconds = calendar.component(.second, from: timestamp)
            timestampLabel.text = "\(hour):\(minutes):\(seconds)"
        }
        
        numRTLabel.text = "\(tweet.retweetCount)"
        numFavLabel.text = "\(tweet.favoritesCount)"

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func onFavorite(_ sender: Any) {
        TwitterClient.sharedInstance?.favorite(id: tweetID!, success: { 
            print("Favorited")
            self.numFavLabel.text = "\((self.tweet.favoritesCount) + 1)"
        }, failure: { (error: Error) in
            print(error.localizedDescription)
        })
    }
    
    @IBAction func onRetweet(_ sender: Any) {
        TwitterClient.sharedInstance?.retweet(id: tweetID!, success: { 
            print("Retweeted")
            self.numRTLabel.text = "\((self.tweet.retweetCount) + 1)"
        }, failure: { (error: Error) in
            print(error.localizedDescription)
        })
    }

    @IBAction func onReply(_ sender: Any) {
        performSegue(withIdentifier: "replySegue", sender: self)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        let vc = segue.destination as! ComposeViewController
        vc.inReplyToID = tweet.tweetID
        vc.inReplyToUsername = "@\(tweet.username!)"
    }

}

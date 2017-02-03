//
//  TweetTableViewCell.swift
//  Tweeter
//
//  Created by Naveen Kashyap on 2/2/17.
//  Copyright © 2017 Naveen Kashyap. All rights reserved.
//

import UIKit
import AFNetworking

class TweetTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var numFavLabel: UILabel!
    @IBOutlet weak var numRTLabel: UILabel!
    
    var tweet: Tweet? {
        didSet {
            if let tweet = tweet {
                let urlString = tweet.profileImageURLString!
                let url = URL(string: urlString)!
                profileImage.setImageWith(url)
                usernameLabel.text = tweet.username!
                timestampLabel.text = "\(tweet.timestamp!)"
                tweetLabel.text = tweet.text!
                numRTLabel.text = "\(tweet.retweetCount)"
                numFavLabel.text = "\(tweet.favoritesCount)"
            }
        }
    }
    
    @IBAction func onRetweet(_ sender: Any) {
        numRTLabel.text = "\((tweet?.retweetCount)! + 1)"
    }
    
    
    @IBAction func onFavorite(_ sender: Any) {
        numFavLabel.text = "\((tweet?.favoritesCount)! + 1)"
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        profileImage.layer.cornerRadius = 3
        profileImage.clipsToBounds = true
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

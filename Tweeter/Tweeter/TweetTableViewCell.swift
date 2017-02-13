//
//  TweetTableViewCell.swift
//  Tweeter
//
//  Created by Naveen Kashyap on 2/2/17.
//  Copyright © 2017 Naveen Kashyap. All rights reserved.
//

import UIKit
import AFNetworking


protocol TweetTableViewCellDelegate: class {
    func tweetCell(tweetVC: TweetTableViewCell, indexPath: IndexPath)
}

class TweetTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var numFavLabel: UILabel!
    @IBOutlet weak var numRTLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    var tweetID: String?
    var indexPath: IndexPath?
    weak var delegate: TweetTableViewCellDelegate?
    
    var tweet: Tweet? {
        didSet {
            if let tweet = tweet {
                tweetID = tweet.tweetID
                let urlString = tweet.profileImageURLString!
                let url = URL(string: urlString)!
                profileImage.setImageWith(url)
                usernameLabel.text = tweet.username!
                if let timestamp = tweet.timestamp {
                    let calendar = Calendar.current
                    let hour = calendar.component(.hour, from: timestamp)
                    let minutes = calendar.component(.minute, from: timestamp)
                    let seconds = calendar.component(.second, from: timestamp)
                    timestampLabel.text = "\(hour):\(minutes):\(seconds)"
                }
                tweetLabel.text = tweet.text!
                numRTLabel.text = "\(tweet.retweetCount)"
                numFavLabel.text = "\(tweet.favoritesCount)"
                favoriteButton.setImage(#imageLiteral(resourceName: "Favorite"), for: .normal)
                retweetButton.setImage(#imageLiteral(resourceName: "Retweet"), for: .normal)
                
                let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(profileImageTapped(tapGestureRecognizer:)))
                profileImage.isUserInteractionEnabled = true
                profileImage.addGestureRecognizer(tapGestureRecognizer)
            }
        }
    }
    
    
    func profileImageTapped(tapGestureRecognizer: UITapGestureRecognizer){
        print("profile image tapped")
        delegate?.tweetCell(tweetVC: self, indexPath: self.indexPath!)
    }
    
    @IBAction func onRetweet(_ sender: Any) {
        TwitterClient.sharedInstance?.retweet(id: tweetID!, success: { 
            self.numRTLabel.text = "\((self.tweet?.retweetCount)! + 1)"
        }, failure: { (error: Error) in
            print(error.localizedDescription)
        })
    }
    
    
    @IBAction func onFavorite(_ sender: Any) {
        TwitterClient.sharedInstance?.favorite(id: tweetID!, success: { 
            self.numFavLabel.text = "\((self.tweet?.favoritesCount)! + 1)"
        }, failure: { (error: Error) in
            print(error.localizedDescription)
        })
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

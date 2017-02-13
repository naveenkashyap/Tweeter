//
//  UserProfileViewController.swift
//  Tweeter
//
//  Created by Naveen Kashyap on 2/11/17.
//  Copyright © 2017 Naveen Kashyap. All rights reserved.
//

import UIKit

class UserProfileViewController: UIViewController {

    @IBOutlet weak var bannerImageView: UIImageView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var numTweetsLabel: UILabel!
    @IBOutlet weak var numFollowersLabel: UILabel!
    @IBOutlet weak var numFollowingLabel: UILabel!
    
    var profile: User!
    var profileID: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        TwitterClient.sharedInstance?.currentAccount(success: { (profile: User) in
            self.profile = profile
            self.profileID = profile.profileID
            self.profileImageView.setImageWith(profile.profileURL!)
            TwitterClient.sharedInstance?.getMobileBanner(id: self.profileID!, success: { (bannerURLString: String) in
                let url = URL(string: bannerURLString)!
                self.bannerImageView.setImageWith(url)
            }, failure: { (error: Error) in
                print(error.localizedDescription)
            })
            self.nameLabel.text = profile.name
            self.usernameLabel.text = "@" + profile.screename!
            self.numTweetsLabel.text = "\(profile.tweetCount!)"
            self.numFollowersLabel.text = "\(profile.followerCount!)"
            self.numFollowingLabel.text = "\(profile.followingCount!)"
            
            
        }, failure: { (error: Error) in
            print(error.localizedDescription)
        })
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        let vc = segue.destination as! ComposeViewController
        vc.inReplyToID = nil
        vc.inReplyToUsername = nil
    }
    

}

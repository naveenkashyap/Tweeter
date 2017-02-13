//
//  ProfileViewController.swift
//  Tweeter
//
//  Created by Naveen Kashyap on 2/11/17.
//  Copyright © 2017 Naveen Kashyap. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    var profile: User!
    var profileID: String? {
        didSet{
            TwitterClient.sharedInstance?.getUser(id: profileID!, success: { (user: User) in
                self.profile = user
                self.setupUser()
            }, failure: { (error: Error) in
                print(error.localizedDescription)
            })
        }
    }

    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var numTweets: UILabel!
    @IBOutlet weak var numFollowers: UILabel!
    @IBOutlet weak var numFollowing: UILabel!
    
    func setupUser(){
        
        profileImageView.setImageWith(profile.profileURL!)
        TwitterClient.sharedInstance?.getMobileBanner(id: profileID!, success: { (bannerURLString: String) in
            let url = URL(string: bannerURLString)!
            self.backgroundImageView.setImageWith(url)
        }, failure: { (error: Error) in
            print(error.localizedDescription)
        })
        nameLabel.text = profile.name
        usernameLabel.text = "@" + profile.screename!
        numTweets.text = "\(profile.tweetCount!)"
        numFollowers.text = "\(profile.followerCount!)"
        numFollowing.text = "\(profile.followingCount!)"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

//
//  ComposeViewController.swift
//  Tweeter
//
//  Created by Naveen Kashyap on 2/12/17.
//  Copyright © 2017 Naveen Kashyap. All rights reserved.
//

import UIKit

class ComposeViewController: UIViewController {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var tweetTextView: UITextView!
    
    var profile: User!
    var inReplyToID: String?
    var inReplyToUsername: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        TwitterClient.sharedInstance?.currentAccount(success: { (user: User) in
            self.usernameLabel.text = user.screename
            self.nameLabel.text = user.name
            self.profileImageView.setImageWith(user.profileURL!)
            
            if self.inReplyToUsername != nil && self.inReplyToID != nil{
                self.tweetTextView.text = self.inReplyToUsername
            } else {
                self.tweetTextView.text = ""
            }
            
            self.tweetTextView.becomeFirstResponder()
            
        }, failure: { (error: Error) in
            print(error.localizedDescription)
        })
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func onSend(_ sender: Any) {
        TwitterClient.sharedInstance?.sendTweet(status: tweetTextView.text, inReplyToID: inReplyToID, success: {
            print("tweet sent")
            self.dismiss(animated: true, completion: nil)
        }, failure: { (error: Error) in
            print(error.localizedDescription)
        })
    }
    
    @IBAction func onCancel(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
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

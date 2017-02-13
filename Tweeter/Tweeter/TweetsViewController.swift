//
//  TweetsViewController.swift
//  Tweeter
//
//  Created by Naveen Kashyap on 2/2/17.
//  Copyright © 2017 Naveen Kashyap. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, TweetTableViewCellDelegate {
    


    @IBOutlet weak var tableView: UITableView!
    var selectedIndexPath: IndexPath!
    var tweets: [Tweet]!
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        print("setting selectedIndexPath")
        selectedIndexPath = indexPath
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let tweets = tweets {
            return tweets.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetTableViewCell", for: indexPath) as! TweetTableViewCell
        cell.tweet = tweets[indexPath.row]
        cell.delegate = self
        cell.indexPath = indexPath
        return cell
    }
    
    func tweetCell(tweetVC: TweetTableViewCell, indexPath: IndexPath) {
        print("delegate received")
        selectedIndexPath = indexPath
        self.performSegue(withIdentifier: "profileSegue", sender: self)
    }
    
    @IBAction func onLogoutButton(_ sender: Any) {
        TwitterClient.sharedInstance?.logout()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        
        TwitterClient.sharedInstance?.homeTimeline(success: { (tweets: [Tweet]) in
            self.tweets = tweets
            self.tableView.reloadData()
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
        
        let identity = segue.identifier
        
        if identity == "profileSegue" {
            print("Segue to profile")
            
            if let indexPath = selectedIndexPath{
                print("got index path: \(indexPath.row)")
                let vc = segue.destination as! ProfileViewController
                let tweet = self.tweets[indexPath.row]
                vc.profileID = tweet.userID
            }
            
        } else if identity == "tweetSegue" {
            print("Segue to Tweet")
            let vc = segue.destination as! TweetViewController
            var indexPath = tableView.indexPath(for: sender as! TweetTableViewCell)
            vc.tweet = self.tweets[(indexPath?.row)!]
        } else if identity == "userProfileSegue" {
            print("Segue to User Profile")
            let vc = segue.destination as! UserProfileViewController
        }
    }
    

}

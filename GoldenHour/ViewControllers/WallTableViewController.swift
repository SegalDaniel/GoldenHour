//
//  WallTableViewController.swift
//  GoldenHour
//
//  Created by Zach Bachar on 05/01/2019.
//  Copyright © 2019 Zach Bachar. All rights reserved.
//

import UIKit

class WallTableViewController: UITableViewController, wallTableViewCellDelegate {
    
    //MARK: - Variabels
    var data:[Post]?
    var postsListener:NSObjectProtocol?
    
    
    //MARK: - Override UIViewController Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setLogoTitle()
        postsListener = ModelNotification.postsListNotification.observe(cb: { (posts) in
            self.data = posts.sorted(by: { (post1, post2) -> Bool in
                post1.date > post2.date
            })
            self.tableView.reloadData()
        })
        Model.instance.getAllPosts()
    }
    
    deinit{
        if postsListener != nil{
            ModelNotification.postsListNotification.remove(observer: postsListener!)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.setContentOffset(CGPoint.zero, animated:true)
    }
    
    // MARK: - Table view data source and delegate
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let data = data{
            return data.count
        }
        return 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "wallCell", for: indexPath) as! WallTableViewCell
        cell.delegate = self
        cell.post = data?[indexPath.row]

        cell.awakeFromNib()
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "fullScreen", sender: data?[indexPath.row])
    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "fullScreen"{
            let vc = segue.destination as! FullScreenImageViewController
            vc.hidesBottomBarWhenPushed = true
            vc.post = sender as? Post
        }
        else if segue.identifier == "commentsSegue"{
            let vc = segue.destination as! RanksAndComViewController
            let info = sender as! (String, [Comment], [String])
            vc.postId = info.0
            vc.comments = info.1
            vc.ranks = info.2
        }
        else if segue.identifier == "showPhotographer"{
            let vc = segue.destination as! MyProfileViewController
            vc.user = sender as? User
            vc.showBtns = false
        }
    }
    
    //MARK: - wall table cell delegate
    
    func profileTapped(user: User) {
        self.performSegue(withIdentifier: "showPhotographer", sender: user)
    }
    
    func commentsTappd(postId:String, comments:[Comment], ranks:[String]) {
        self.performSegue(withIdentifier: "commentsSegue", sender: (postId, comments, ranks))
    }
    
    
    @IBAction func unwindToWall(segue:UIStoryboardSegue) {}
}

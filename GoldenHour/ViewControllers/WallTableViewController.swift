//
//  WallTableViewController.swift
//  GoldenHour
//
//  Created by Zach Bachar on 05/01/2019.
//  Copyright © 2019 Zach Bachar. All rights reserved.
//

import UIKit

class WallTableViewController: UITableViewController, wallTableViewCellDelegate {
    
    var data:[Post]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLogoTitle()
        loadData()
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if let data = data{
            return data.count
        }
        return 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "wallCell", for: indexPath) as! WallTableViewCell
        cell.delegate = self
        cell.post = data?[indexPath.row]
        if cell.post!.rank.contains(Model.connectedUser!.id){
            cell.ranked = true
        }
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
            let info = sender as! (String, [Comment], Int)
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
    
    func profileTapped(user: User) {
        self.performSegue(withIdentifier: "showPhotographer", sender: user)
    }
    
    func commentsTappd(postId:String, comments:[Comment], ranks:Int) {
        self.performSegue(withIdentifier: "commentsSegue", sender: (postId, comments, ranks))
    }
    
    func loadData(){
        Model.instance.getAllPosts(){ (posts) in
            self.data = posts
            self.tableView.reloadData()
            print("gethered all posts")
        }
    }
    
    @IBAction func unwindToWall(segue:UIStoryboardSegue) {}
    /*
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        if(velocity.y>0) {
            //Code will work without the animation block.I am using animation block incase if you want to set any delay to it.
            UIView.animate(withDuration: 2.5, delay: 0, options: UIView.AnimationOptions(), animations: {
                self.navigationController?.setNavigationBarHidden(true, animated: true)
                //self.navigationController?.setToolbarHidden(true, animated: true)
                print("Hide")
            }, completion: nil)
            
        } else if(velocity.y < -0.5) {
            UIView.animate(withDuration: 1, delay: 0, options: UIView.AnimationOptions(), animations: {
                self.navigationController?.setNavigationBarHidden(false, animated: true)
                //self.navigationController?.setToolbarHidden(false, animated: true)
                print("Unhide")
            }, completion: nil)
        }
    }
  */
}

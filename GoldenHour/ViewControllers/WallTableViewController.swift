//
//  WallTableViewController.swift
//  GoldenHour
//
//  Created by Zach Bachar on 05/01/2019.
//  Copyright © 2019 Zach Bachar. All rights reserved.
//

import UIKit

class WallTableViewController: UITableViewController {

    var data:[Post]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLogoTitle()
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 10
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "wallCell", for: indexPath) as! WallTableViewCell
        // Configure the cell...
        Utility.viewTapRecognizer(target: self, toBeTapped: cell.profileImageView, action: #selector(self.showPostOwnerUser))
        Utility.viewTapRecognizer(target: self, toBeTapped: cell.imageByLabel, action: #selector(self.showPostOwnerUser))
        Utility.viewTapRecognizer(target: self, toBeTapped: cell.ranksLabel, action: #selector(self.showRanksAndComments))
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.dequeueReusableCell(withIdentifier: "wallCell", for: indexPath) as! WallTableViewCell
        self.performSegue(withIdentifier: "fullScreen", sender: cell.postImageView.image)
    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "fullScreen"{
            let vc = segue.destination as! FullScreenImageViewController
            vc.hidesBottomBarWhenPushed = true
            if var image = sender as? UIImage{
                //vc.image = image
                image =  UIImage(named: "Image_placeholder")!
                vc.image = image
            }
        }
        else if segue.identifier == "commentsSegue"{
//            let vc = segue.destination as! RanksAndComViewController
//            vc.navigationController?.setNavigationBarHidden(false, animated: false)
//            vc.navigationController?.navigationBar.isHidden = false
        }
        else if segue.identifier == "showPhotographer"{
            let vc = segue.destination as! MyProfileViewController
            //vc.user = enter the post owner user
            vc.showBtns = false
        }
    }
    
    @objc func showPostOwnerUser(){
        self.performSegue(withIdentifier: "showPhotographer", sender: nil)
    }
    
    @objc func showRanksAndComments(){
        self.performSegue(withIdentifier: "commentsSegue", sender: nil)
    }
    
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
}

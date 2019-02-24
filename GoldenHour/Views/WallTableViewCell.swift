//
//  WallTableViewCell.swift
//  GoldenHour
//
//  Created by Zach Bachar on 08/01/2019.
//  Copyright © 2019 Zach Bachar. All rights reserved.
//

import UIKit

class WallTableViewCell: UITableViewCell {
    
    var ranked:Bool = false
    var post:Post?{
        didSet{
            if post!.rank.count > 0 {
                ranked = post!.rank.contains(Model.connectedUser!.id)
            }
        }
    }
    var postOwner:User?
    var delegate:wallTableViewCellDelegate?
    
    @IBOutlet weak var ranksLabel: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var imageByLabel: UILabel!
    @IBOutlet weak var rankBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if ranked{
            rankBtn.tintColor = UIColor.red
            rankBtn.tag = 1
        }
        
        Utility.viewTapRecognizer(target: self, toBeTapped: profileImageView, action: #selector(self.showPostOwnerUser))
        Utility.viewTapRecognizer(target: self, toBeTapped: imageByLabel, action: #selector(self.showPostOwnerUser))
        Utility.viewTapRecognizer(target: self, toBeTapped: ranksLabel, action: #selector(self.showRanksAndComments))
        
        Utility.roundImageView(imageView: profileImageView)
        if let post = post{
            postImageView.contentMode = .scaleAspectFit
            Model.instance.getImageKF(url: post.imageUrl!, imageView: postImageView)
            
            Model.instance.getUserInfo(userId: post.userId) { (user) in
                self.postOwner = user
                Model.instance.getImageKF(url: user.profileImage, imageView: self.profileImageView)
                self.imageByLabel.text = "Image by \(user.userName)"
            }
            ranksLabel.text = "Ranks \(post.rank.count) Comments \(post.comments.count)"
        }
    }

    @IBAction func commentsBtnPressed(_ sender: Any) {
        delegate?.commentsTappd(postId: post!.postId, comments: post!.comments, ranks: post!.rank.count)
    }
    
    @IBAction func addRankBtnPressed(_ sender: Any) {
        if ranked{
            Model.instance.removeRank(postId: post!.postId, userId: Model.connectedUser!.id) { (err, ref) in
                self.rankBtn.tag = 0
                self.rankBtn.tintColor = UIColor.black
                self.ranked = false
            }
        }
        else{
            Model.instance.addRank(postId: post!.postId, userId: Model.connectedUser!.id) { (err, ref) in
                self.rankBtn.tag = 1
                self.rankBtn.tintColor = UIColor.red
                self.ranked = true
            }
        }
    }
    
    @objc func showPostOwnerUser(){
        delegate?.profileTapped(user: postOwner!)
    }
    
    @objc func showRanksAndComments(){
       delegate?.commentsTappd(postId: post!.postId, comments: post!.comments, ranks: post!.rank.count)
    }
}



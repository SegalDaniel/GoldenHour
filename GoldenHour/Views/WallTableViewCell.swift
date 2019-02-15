//
//  WallTableViewCell.swift
//  GoldenHour
//
//  Created by Zach Bachar on 08/01/2019.
//  Copyright © 2019 Zach Bachar. All rights reserved.
//

import UIKit

class WallTableViewCell: UITableViewCell {
    
    var post:Post?
    var postOwner:User?
    var delegate:wallTableViewCellDelegate?
    
    @IBOutlet weak var ranksLabel: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var imageByLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
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
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func commentsBtnPressed(_ sender: Any) {
    }
    
    @objc func showPostOwnerUser(){
        delegate?.profileTapped(user: postOwner!)
    }
    
    @objc func showRanksAndComments(){
       delegate?.ranksTappd(post: post!)
    }
}



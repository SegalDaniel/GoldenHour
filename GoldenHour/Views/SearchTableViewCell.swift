//
//  SearchTableViewCell.swift
//  GoldenHour
//
//  Created by Zach Bachar on 11/03/2019.
//  Copyright © 2019 Zach Bachar. All rights reserved.
//

import UIKit

class SearchTableViewCell: UITableViewCell {

    //MARK: - Variables
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    var delegate:searchTableViewCellDelegate?
    var post:Post?{
        didSet{
            if post != nil && postImageView != nil && nameLabel != nil{
                Model.instance.getImageKF(url: post!.imageUrl!, imageView: postImageView)
                nameLabel.text = post!.metaData.description
                Utility.removeRoundness(imageView: postImageView)
            }
        }
    }
    var user:User?{
        didSet{
            if user != nil && postImageView != nil && nameLabel != nil{
                Model.instance.getImageKF(url: user!.profileImage, imageView: postImageView)
                nameLabel.text = user!.userName
                Utility.roundImageView(imageView: postImageView)
            }
        }
    }
    
    //MARK: - Override UITableViewCell Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        postImageView.contentMode = .scaleAspectFit
        Utility.viewTapRecognizer(target: self, toBeTapped: postImageView, action: #selector(selected))
        Utility.viewTapRecognizer(target: self, toBeTapped: nameLabel, action: #selector(selected))
        
        if let post = post{
            Model.instance.getImageKF(url: post.imageUrl!, imageView: postImageView)
            nameLabel.text = post.metaData.description
            Utility.removeRoundness(imageView: postImageView)
        }
        if let user = user{
            Model.instance.getImageKF(url: user.profileImage, imageView: postImageView, placeHolderNamed: "profile_icon")
            nameLabel.text = user.userName
            Utility.roundImageView(imageView: postImageView)
        }
    }
    
    //MARK: - Button actions
    @objc func selected(){
        delegate?.pressed(post: post, user: user)
    }

}

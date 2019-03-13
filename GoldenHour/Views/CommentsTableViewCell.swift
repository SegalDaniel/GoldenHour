//
//  CommentsTableViewCell.swift
//  GoldenHour
//
//  Created by Zach Bachar on 08/01/2019.
//  Copyright © 2019 Zach Bachar. All rights reserved.
//

import UIKit

class CommentsTableViewCell: UITableViewCell {
    
    //MARK: - Variables
    @IBOutlet weak var userProfileImageView: UIImageView!
    @IBOutlet weak var commentLabel: UILabel!
    
    var userId:String?{
        didSet{
            if let imgView = userProfileImageView{
                Model.instance.getUserInfo(userId: userId!) { (user) in
                    Model.instance.getImageKF(url: user.profileImage, imageView: imgView)
                }
            }
        }
    }
    
    //MARK: - Override UITableViewCell Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        Utility.roundImageView(imageView: userProfileImageView)
        addUserPic()
    }

    //MARK: - Update content
    func addUserPic(){
        if let userId = userId{
            Model.instance.getUserInfo(userId: userId) { (user) in
                Model.instance.getImageKF(url: user.profileImage, imageView: self.userProfileImageView)
            }
        }
    }
}

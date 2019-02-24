//
//  CommentsTableViewCell.swift
//  GoldenHour
//
//  Created by Zach Bachar on 08/01/2019.
//  Copyright © 2019 Zach Bachar. All rights reserved.
//

import UIKit

class CommentsTableViewCell: UITableViewCell {
    
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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        Utility.roundImageView(imageView: userProfileImageView)
        addUserPic()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func addUserPic(){
        if let userId = userId{
            Model.instance.getUserInfo(userId: userId) { (user) in
                Model.instance.getImageKF(url: user.profileImage, imageView: self.userProfileImageView)
            }
        }
    }
}

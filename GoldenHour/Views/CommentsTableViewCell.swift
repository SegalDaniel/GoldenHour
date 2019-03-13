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
    var commentId:String?
    
    //MARK: - Override UITableViewCell Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        initViews()
        addUserPic()
    }
    
    //MARK: - Views intit
    func initViews(){
        Utility.roundImageView(imageView: userProfileImageView)
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

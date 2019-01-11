//
//  WallTableViewCell.swift
//  GoldenHour
//
//  Created by Zach Bachar on 08/01/2019.
//  Copyright © 2019 Zach Bachar. All rights reserved.
//

import UIKit

class WallTableViewCell: UITableViewCell {

    var data:[Comment]?
    
    @IBOutlet weak var ranksLabel: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var imageByLabel: UILabel!
    
    
    func setComments(commets:[Comment]){
        self.data = commets
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        Utility.roundImageView(imageView: profileImageView)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func commentsBtnPressed(_ sender: Any) {
    }
    
    
}

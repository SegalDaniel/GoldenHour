//
//  PostCollectionViewCell.swift
//  GoldenHour
//
//  Created by Zach Bachar on 12/01/2019.
//  Copyright © 2019 Zach Bachar. All rights reserved.
//

import UIKit

class PostCollectionViewCell: UICollectionViewCell {
  
    @IBOutlet weak var postImageView: UIImageView!
    var image:UIImage?
    var post:Post?
    var delegate:postCollectionViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        postImageView.contentMode = .scaleAspectFit
        postImageView.image = image
        initTouches()
    }
    
    func initTouches(){
        postImageView.isUserInteractionEnabled = true
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.tapped))
        postImageView.addGestureRecognizer(tapGestureRecognizer)
        
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.longPressed))
        postImageView.addGestureRecognizer(longPressRecognizer)
    }
    
    @objc func tapped(sender: UITapGestureRecognizer){
        delegate?.tapped(post: post!)
        print("tapped")
    }
    
    @objc func longPressed(sender: UILongPressGestureRecognizer){
        delegate?.longPressed(post: post!)
        print("long prssed")
    }
}

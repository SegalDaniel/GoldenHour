//
//  PostCollectionViewCell.swift
//  GoldenHour
//
//  Created by Zach Bachar on 12/01/2019.
//  Copyright © 2019 Zach Bachar. All rights reserved.
//

import UIKit

class PostCollectionViewCell: UICollectionViewCell {
  
    //MARK: - Variables
    @IBOutlet weak var postImageView: UIImageView!
    var image:UIImage?
    var post:Post?
    var delegate:postCollectionViewCellDelegate?
    
    //MARK: - Override UICollectionViewCell Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        postImageView.contentMode = .scaleAspectFit
        postImageView.image = image
        initTouches()
    }
    
    //MARK: - Views init
    func initTouches(){
        postImageView.isUserInteractionEnabled = true
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.tapped))
        postImageView.addGestureRecognizer(tapGestureRecognizer)
        
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.longPressed))
        postImageView.addGestureRecognizer(longPressRecognizer)
    }
    
    //MARK: - Buttons actions
    @objc func tapped(sender: UITapGestureRecognizer){
        delegate?.tapped(post: post!)
        print("tapped")
    }
    
    @objc func longPressed(sender: UILongPressGestureRecognizer){
        delegate?.longPressed(post: post!)
        print("long prssed")
    }
}

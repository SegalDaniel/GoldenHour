//
//  Utility.swift
//  GoldenHour
//
//  Created by Zach Bachar on 07/01/2019.
//  Copyright © 2019 Zach Bachar. All rights reserved.
//

import Foundation
import UIKit

class Utility{
    
    static func roundImageView(imageView:UIImageView){
        imageView.layer.borderWidth = 1
        imageView.layer.masksToBounds = false
        imageView.layer.borderColor = UIColor.black.cgColor
        imageView.layer.cornerRadius = imageView.frame.height/2
        imageView.clipsToBounds = true
    }
    
    static func viewTapRecognizer(target:Any, toBeTapped:UIView, action:Selector){
        let tapGestureRecognizer = UITapGestureRecognizer(target: target, action: action)
        toBeTapped.isUserInteractionEnabled = true
        toBeTapped.addGestureRecognizer(tapGestureRecognizer)
    }
    
}

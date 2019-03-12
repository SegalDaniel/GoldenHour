//
//  MyPickerDelegate.swift
//  GoldenHour
//
//  Created by Zach Bachar on 10/01/2019.
//  Copyright © 2019 Zach Bachar. All rights reserved.
//

import Foundation
import UIKit

protocol MyPickerDelegate {
    func userPickedProperty(sender:UIButton?, property:String?)
}

protocol wallTableViewCellDelegate{
    func profileTapped(user:User)
    func commentsTappd(postId:String, comments:[Comment], ranks:[String])
}

protocol postCollectionViewCellDelegate {
    func longPressed(post:Post)
    func tapped(post:Post)
}

protocol searchTypeCollectionCellDelegate {
    func pressed(type:PhotosStaticData.nameSearchTitles, sender: UIButton)
}

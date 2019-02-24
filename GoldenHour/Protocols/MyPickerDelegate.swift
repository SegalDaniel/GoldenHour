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
    func ranksTappd(postId:String, comments:[Comment])
}

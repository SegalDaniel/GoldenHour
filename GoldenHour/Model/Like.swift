//
//  Like.swift
//  GoldenHour
//
//  Created by דניאל סגל on 03/01/2019.
//  Copyright © 2019 Zach Bachar. All rights reserved.
//

import UIKit
import Foundation

class Like {
    let likeId:String
    let userId:String
    let userName:String
    let profileImageUrl:String
    let date:String
    
    
    
    init(_likeId:String, _userId:String, _userName:String,_profileImageUrl:String){
        likeId = _likeId
        userId = _userId
        userName = _userName
        profileImageUrl = _profileImageUrl
        date = DateFormatter.sharedFormatter.string(from: Date())
    }
    
    init(json:[String:Any]) {
        likeId = json["likeId"] as! String
        userId = json["userId"] as! String
        userName = json["userName"] as! String
        profileImageUrl = json["profileImageUrl"] as! String
        date = json["date"] as! String
    }
    
        
    
    
    
    func toJson() -> [String:Any] {
        var json = [String:Any]()
        json["likeId"] = likeId
        json["userId"] = userId
        json["userName"] = userName
        json["profileImageUrl"] = profileImageUrl
        json["date"] = date
        return json
    }
}


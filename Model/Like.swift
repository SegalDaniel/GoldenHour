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
    let userName:String
    let profileImageUrl:String
    let date:String
    
    
    
    init(_userName:String,_profileImageUrl:String){
        userName = _userName
        profileImageUrl = _profileImageUrl
        date = DateFormatter.sharedFormatter.string(from: Date())
    }
    
    init(json:[String:Any]) {
        userName = json["userName"] as! String
        profileImageUrl = json["profileImageUrl"] as! String
        date = json["date"] as! String
    }
    
        
    
    
    
    func toJson() -> [String:Any] {
        var json = [String:Any]()
        json["userName"] = userName
        json["profileImageUrl"] = profileImageUrl
        json["date"] = date
        return json
    }
}


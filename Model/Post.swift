//
//  Post.swift
//  GoldenHour
//
//  Created by דניאל סגל on 02/01/2019.
//  Copyright © 2019 Zach Bachar. All rights reserved.
//

import UIKit
import Foundation
class Post {
    let id:String
    
    let title:String
    let imageUrl:String
    let rank:[User]?
    let date:String
    var comments:[Comment]?
    
    
    init(_id:String, _title:String,_imageUrl:String){
        id = _id
        title = _title
        imageUrl = _imageUrl
        rank = nil
        date = DateFormatter.sharedFormatter.string(from: Date())
        comments = nil
    }
    
    init(json:[String:Any]) {
        id = json["id"] as! String
        title = json["title"] as! String
        imageUrl = json["imageUrl"] as! String
        rank = json["rank"] as! [User]?
        date = json["date"] as! String
        comments = nil
    }
    
    
    func toJson() -> [String:Any] {
        var json = [String:Any]()
        json["id"] = id
        json["title"] = title
        json["imageUrl"] = imageUrl
        json["rank"] = rank
        json["date"] = date
        if(comments != nil)
        {//noooo
            json["comments"] = comments // temp
        }

        return json
    }
}


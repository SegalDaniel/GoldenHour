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
    let userId:String
    let postId:String
    let title:String
    let imageUrl:String
    let rank:[User]?
    let date:String
    var comments:[Comment]?
    var metaData:[Metadata]?
    
    
    init(_userId:String, _postId:String, _title:String,_imageUrl:String){
        userId = _userId
        postId = _postId
        title = _title
        imageUrl = _imageUrl
        rank = nil
        date = DateFormatter.sharedFormatter.string(from: Date())
        comments = nil
        metaData = nil
    }
    
    init(json:[String:Any]) {
        userId = json["userId"] as! String
        postId = json["postId"] as! String
        title = json["title"] as! String
        imageUrl = json["imageUrl"] as! String
        rank = json["rank"] as! [User]?
        date = json["date"] as! String
        comments = nil
        metaData = nil
    }
    
    
    func toJson() -> [String:Any] {
        var json = [String:Any]()
        json["userId"] = userId
        json["postId"] = postId
        json["title"] = title
        json["imageUrl"] = imageUrl
        json["rank"] = rank
        json["date"] = date
        if(comments != nil)
        {
            json["comments"] = comments //temp
        }
        if(metaData != nil){
             json["metaData"] = metaData //temp
        }

        return json
    }
}


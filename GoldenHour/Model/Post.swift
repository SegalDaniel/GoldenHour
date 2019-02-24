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
    //let rankId:String
    let title:String
    var imageUrl:String?
    let rank:[String]?
    let date:String
    var comments:[Comment]
    var metaData:Metadata
    
    init(_userId:String, _postId:String, /*_rankId:String,*/ _title:String,_imageUrl:String?, metadata:Metadata){
        userId = _userId
        postId = _postId
        //rankId = _rankId
        title = _title
        imageUrl = _imageUrl
        rank = nil
        date = DateFormatter.sharedFormatter.string(from: Date())
        comments = []
        metaData = metadata
    }
    
    init(json:[String:Any]) {
        userId = json["userId"] as! String
        postId = json["postId"] as! String
        //rankId = json["rankId"] as! String
        title = json["title"] as! String
        imageUrl = json["imageUrl"] as! String?
        rank = json["rank"] as! [String]?
        date = json["date"] as! String
        if let metadata = json["metaData"] as? [String:Any]{
            self.metaData = Metadata(json:metadata)
        }
        else {metaData = Metadata(json: ["": ""])}
        comments = []
        if let commentsData = json["comments"] as? [String:Any]{
            commentsData.forEach { (key,value) in
                comments.append(Comment(json: value as! [String:Any]))
            }
        }
    }
    
    
    func toJson() -> [String:Any] {
        var json = [String:Any]()
        json["userId"] = userId
        json["postId"] = postId
        //json["rankId"] = rankId
        json["title"] = title
        json["imageUrl"] = imageUrl
        json["rank"] = rank
        json["date"] = date
        json["metaData"] = metaData.toJson()
        return json
    }
}


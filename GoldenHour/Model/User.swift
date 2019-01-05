//
//  User.swift
//  GoldenHour
//
//  Created by דניאל סגל on 02/01/2019.
//  Copyright © 2019 Zach Bachar. All rights reserved.
//
import UIKit
import Foundation
class User{
    let id:String
    let name:String
    var profileImage:UIImage
    let description:String
    let url:String
    var post:[Post]
    //post,gear
    
    private init(_id:String, _name:String, _profileImage:UIImage, _description:String, _url:String, _post:[Post]){
        self.id=_id
        self.name=_name
        self.profileImage=_profileImage
        self.description=_description
        self.url=_url
        self.post=_post
    }
    
    init(json:[String:Any]) {
        id = json["id"] as! String
        name = json["name"] as! String
        description = json["description"] as! String
        profileImage = json["profileImage"] as! UIImage
        if json["url"] != nil{
            url = json["url"] as! String
        }else{
            url = ""
        }
        post = json["post"] as! [Post]
    }
    
    func toJson() -> [String:Any] {
        var json = [String:Any]()
        json["id"] = id
        json["name"] = name
        json["profileImage"] = profileImage
        json["description"] = description
        json["url"] = url
        json["post"] = post
        return json
    }
}
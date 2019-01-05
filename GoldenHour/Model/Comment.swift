//
//  Comment.swift
//  GoldenHour
//
//  Created by דניאל סגל on 02/01/2019.
//  Copyright © 2019 Zach Bachar. All rights reserved.
//

import UIKit
import Foundation

class Comment {
    let comment:String
    let userName:String
    let date :String
    
    
    init(_comment:String,_userName:String){
        comment = _comment
        userName = _userName
        date = DateFormatter.sharedFormatter.string(from: Date())
    }
    
    init(json:[String:Any]) {
        comment = json["comment"] as! String
        userName = json["userName"] as! String
        date = DateFormatter.sharedFormatter.string(from: Date())
    }

    
    
    func toJson() -> [String:Any] {
        var json = [String:Any]()
        json["comment"] = comment
        json["userName"] = userName
        json["date"] = date
        return json
    }
}

extension DateFormatter {
    
    static var sharedFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter
    }()
}

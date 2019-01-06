//
//  ModelFirebase.swift
//  GoldenHour
//
//  Created by דניאל סגל on 06/01/2019.
//  Copyright © 2019 Zach Bachar. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase
class ModelFirebase{
    var ref : DatabaseReference!
    var posts = [Post]()
    init(){
        FirebaseApp.configure()
        ref = Database.database().reference()
    }
    
}

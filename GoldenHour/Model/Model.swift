//
//  Model.swift
//  GoldenHour
//
//  Created by Zach Bachar on 07/01/2019.
//  Copyright © 2019 Zach Bachar. All rights reserved.
//

import Foundation
import UIKit
import Foundation
class ModelNotification{
    
    static let usersListNotification = MyNotification<[User]>("app.GoldenHour.userList")
    
    class MyNotification<T>{
        let name:String
        var count = 0;
        
        init(_ _name:String) {
            name = _name
        }
        func observe(cb:@escaping (T)->Void)-> NSObjectProtocol{
            count += 1
            return NotificationCenter.default.addObserver(forName: NSNotification.Name(name),
                                                          object: nil, queue: nil) { (data) in
                                                            if let data = data.userInfo?["data"] as? T {
                                                                cb(data)
                                                            }
            }
        }
        
        func notify(data:T){
            NotificationCenter.default.post(name: NSNotification.Name(name),
                                            object: self,
                                            userInfo: ["data":data])
        }
        
        func remove(observer: NSObjectProtocol){
            count -= 1
            NotificationCenter.default.removeObserver(observer, name: nil, object: nil)
        }
        
        
    }
    
}

class Model {
    static let instance:Model = Model()
    
    
    var modelSql = ModelSql();
    var modelFirebase = ModelFirebase();
    
    private init(){
        
    }
    
    
    func getAllUsers() {
        modelFirebase.getAllUsers(callback: {(data:[User]) in
            ModelNotification.usersListNotification.notify(data: data)
        })
    }
    
    
    
    func getAllUsers(callback:@escaping ([User])->Void){
        modelFirebase.getAllUsers(callback: callback);
        //return User.getAll(database: modelSql!.database);
    }
    
   
    
    func addNewUser(user : User){
        modelFirebase.addNewUser(user: user)
        //User.addNew(database: modelSql!.database, student: student)
    }
    
    
//    func saveImage(image : UIImage, name:(String),child:(String),text:(String),callback:@escaping (String?)->Void){
//        modelFirebase.saveImage(image: image, name: name,child: child,text: text, callback: callback)
//    }
//    
//    func getImage(url:String, callback:@escaping (UIImage?)->Void){
//        modelFirebase.getImage(url: url, callback: callback)
//    }
    
}


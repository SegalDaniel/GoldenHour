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
import FirebaseDatabase
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
    static var connectedUser:User?
    
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
    
    func checkIfSignIn() -> Bool {
        return modelFirebase.checkIfSignIn()
    }
    
    func addNewUser(user : User, profileImage:UIImage?, callback:@escaping (Error?, DatabaseReference?)->Void){
        modelFirebase.registerUser(mail: user.email, pass: user.password) { (result ,error)  in
            if error != nil{
                callback(error!, nil)
                return
            }
            else{
                user.id = self.modelFirebase.getUserId()
                if let img = profileImage{
                    self.modelFirebase.saveProfileImage(image: img, name: user.id, callback: { (imageURL) in
                        user.profileImage = imageURL!
                        self.modelFirebase.addNewUser(user: user, callback: { (error, reference) in
                            print("error: \(error?.localizedDescription ?? "no error") reference: \(reference)")
                            callback(error, reference)
                            return
                        })
                    })
                }
                else{
                    self.modelFirebase.addNewUser(user: user, callback: { (error, reference) in
                        print("error: \(error?.localizedDescription ?? "no error") reference: \(reference)")
                        callback(error, reference)
                        return
                    })
                }
            }
            
        }
    }
    
    func addNewPost(post:Post, callback: @escaping (Error?, DatabaseReference) -> Void){
        modelFirebase.addNewPost(post: post) { (error, ref) in
            self.modelFirebase.addPostUrlToUser(userID: Model.connectedUser!.id, postID: post.postId, callback: callback)
        }
    }
    
    func getUserInfo(userId:String, callback:@escaping (User)->Void){
        modelFirebase.getUserInfo(userId: userId, callback: callback)
    }
    
    func getUserID() -> String{
        return modelFirebase.getUserId()
    }
    
    func savePostImage(image : UIImage, name:(String),callback:@escaping (String?)->Void){
        modelFirebase.saveImage(image: image, name: name, callback: callback)
    }
    //
    //    func getImage(url:String, callback:@escaping (UIImage?)->Void){
    //        modelFirebase.getImage(url: url, callback: callback)
    //    }
    
}


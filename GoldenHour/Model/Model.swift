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
import Kingfisher

// MARK: - ModelNotification class
// ============================== ModelNotification class ==============================

class ModelNotification{
    static let usersListNotification = MyNotification<[User]>("app.GoldenHour.usersList")
    static let postsListNotification = MyNotification<[Post]>("app.GoldenHour.postsList")
    static let connectedUser = MyNotification<User>("app.GoldenHour.connectedUser")
    
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

// MARK: - Model class
// ============================== Model class ==============================

class Model {
    // MARK: - Model class properties
    // ============================== Model class properties ==============================

    static let instance:Model = Model()
    static var connectedUser:User?
    
    var modelSql = ModelSql();
    var modelFirebase = ModelFirebase();
    
    private init(){
        
    }
    
    // MARK: - User Methods
    // ============================== User Methods ==============================

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
    
    func getUserInfo(userId:String, callback:@escaping (User)->Void){
        modelFirebase.getUserInfo(userId: userId, callback: callback)
    }
    
    func getUserID() -> String{
        return modelFirebase.getUserId()
    }
    
    func updateConnectedUser(){
        modelFirebase.getUserInfo(userId: getUserID()) { (user) in
            ModelNotification.connectedUser.notify(data: user)
            Model.connectedUser = user
        }
    }
    
    // MARK: - Post Methods
    // ============================== User Methods ==============================
    
    func addNewPost(post:Post, callback: @escaping (Error?, DatabaseReference) -> Void){
        modelFirebase.addNewPost(post: post) { (error, ref) in
            self.modelFirebase.addPostUrlToUser(userID: Model.connectedUser!.id, postID: post.postId, callback: callback)
            self.getAllPosts()
            self.updateConnectedUser()
        }
    }
    
    func getPost(postId:String, callback:@escaping (Post) -> Void){
        modelFirebase.getPost(postId: postId) { (post) in
            callback(post)
        }
    }
    
    func getAllPosts(){
        modelFirebase.getAllPosts { (posts) in
            ModelNotification.postsListNotification.notify(data: posts)
        }
    }
    
    func removePost(post:Post, callback:@escaping (Error?, DatabaseReference)->Void){
        modelFirebase.removePostForUser(post: post) { (err, ref) in
            self.getAllPosts()
            self.updateConnectedUser()
            callback(err,ref)
        }
    }
    
    func updateUserProfileImage(image:UIImage, callback:@escaping (Error?, DatabaseReference)->Void){
        modelFirebase.saveProfileImage(image: image, name: Model.connectedUser!.id) { (url) in
            if let url = url{
                self.modelFirebase.updateUserProfileImage(url: url, callback: { (err, ref) in
                    self.updateConnectedUser()
                    callback(err, ref)
                })
            }
        }
    }
    
    func updateUsername(new_name:String, callback:@escaping (Error?, DatabaseReference)->Void){
        modelFirebase.updateUsername(new_name: new_name) { (err, ref) in
            self.updateConnectedUser()
            callback(err, ref)
        }
    }
    
    func updateDescription(description:String, callback:@escaping (Error?, DatabaseReference)->Void){
        modelFirebase.updateDescription(description: description) { (err, ref) in
            self.updateConnectedUser()
            callback(err, ref)
        }
    }
    
    // MARK: - Comment, Rank Methods
    // ============================== Comment Methods ==============================
    
    func addCommentToPost(postId:String, comment:Comment, callback:@escaping (Error?, DatabaseReference)->Void){
       modelFirebase.addCommentToPost(postId: postId, comment: comment, callback: callback)
    }
    
    func getAllCommentsOfPost(postId:String, callback: @escaping ([Comment])->Void){
        modelFirebase.getAllCommentsOfPost(postId: postId, callback: callback)
    }
    
    func addRank(postId:String, userId:String, callback:@escaping (Error?, DatabaseReference)->Void){
        modelFirebase.addRank(postId: postId, userId: userId, callback: callback)
    }
    
    func removeRank(postId:String, userId:String, callback:@escaping (Error?, DatabaseReference)->Void){
        modelFirebase.removeRank(postId: postId, userId: userId, callback: callback)
    }
    
    // MARK: - Images Methods
    // ============================== Images Methods ==============================
    
    func getImageKF(url:String, imageView:UIImageView, placeHolderNamed:String = "Image_placeholder"){
        let _url = URL(string: url)
        let image = UIImage(named: placeHolderNamed)
        imageView.kf.setImage(with: _url, placeholder: image)
    }
    
    func getImage(url:String, callback:@escaping (UIImage?) -> Void){
        modelFirebase.getImage(url: url, callback: callback)
    }
    
    func savePostImage(image : UIImage, name:(String),callback:@escaping (String?)->Void){
        modelFirebase.saveImage(image: image, name: name, callback: callback)
    }
    
}


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
            //STILL NEED TO IMPLEMENT SQL SAVING
            //User.addNew(database: modelSql!.database, student: student)
            //callback(err, ref)
        }
    }
    
    ////////////////////////////////////////////////////////////////USER TABLE////////////////////////////////////////////////////////////////
    
    func createUsersTable()  {
        CacheHandler.cache.create(name: "USERS", data: "(USER_ID TEXT PRIMARY KEY, USER_NAME TEXT, EMAIL TEXT, PROFILE_IMG_URL TEXT)",
                                  onSuccess: {
                                    print("Success - createTable")
        }, onError: {
            print("Error - createTable")
        })
    }
    
    func dropUsersTable() {
        CacheHandler.cache.delete(name: "USERS", onSuccess: {
            print("Success - dropTable")
        }, onError: {
            print("Error - dropTable")
        })
    }
    
    func saveUsersCache(users: [User]) {
        for user in users {
            var userAsString = [String]()
            userAsString.append(user.id)
            userAsString.append(user.userName)
            userAsString.append(user.email)
            userAsString.append(user.description)
            userAsString.append(user.profileImage)
            CacheHandler.cache.save(name: "USERS", dataToSave: userAsString, onSuccess: {
                print("User saved locally")
            }, onError: {
                print("Faild to save post locally")
            })
        }
    }
    
    
      ////////////////////////////////////////////////////////////////POST TABLE////////////////////////////////////////////////////////////////
    
    func createPostTable(completion: ((Bool)->Void)? = nil)   {
        let tableName   = "POSTS"
        let tableColumn = "(POST_ID TEXT PRIMARY KEY, USER_ID TEXT, PHOTO_URL TEXT, TITLE TEXT, DATE INTEGER)"
        CacheHandler.cache.create(name: tableName, data: tableColumn, onSuccess: {
            completion?(true)
        }, onError: {
            completion?(false)
        })
    }
    
    func dropPostTable(completion: ((Bool)->Void)? = nil)  {
        let tableName = "POSTS"
        CacheHandler.cache.delete(name: tableName, onSuccess: {
            completion?(true)
        }, onError: {
            completion?(false)
        })
    }
    
    
    //    func saveImage(image : UIImage, name:(String),child:(String),text:(String),callback:@escaping (String?)->Void){
    //        modelFirebase.saveImage(image: image, name: name,child: child,text: text, callback: callback)
    //    }
    //
    //    func getImage(url:String, callback:@escaping (UIImage?)->Void){
    //        modelFirebase.getImage(url: url, callback: callback)
    //    }
    
}


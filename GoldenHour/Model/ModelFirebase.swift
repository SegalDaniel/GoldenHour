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
import FirebaseAuth
import SVProgressHUD
class ModelFirebase{

    var ref : DatabaseReference!
    var posts = [Post]()
    init(){
        
        ref = Database.database().reference()
    }
    
    func registerUser(mail:String  ,pass:String, callback:@escaping (AuthDataResult?, Error?)->Void)
    {
        
        Auth.auth().createUser(withEmail: mail, password: pass) { (user, error) in
            if error != nil{
                print(error!)
                callback(user, error)
            }else{
                callback(user, error)
            }
        }
    }
    
  
    func signIn(mail:String  ,pass:String, callback:@escaping (AuthDataResult?, Error?)->Void){
        Auth.auth().signIn(withEmail: mail, password: pass) { (user, error) in
            if user != nil{
                callback(user, error)
            }else{
                callback(user, error)
            }
        }
    }
    
    
  
    func getAllUsers(callback:@escaping ([User])->Void){
        ref.child("users").observe(.value, with:
            {
                (snapshot) in
                var data = [User]()
                let value = snapshot.value as! [String : Any]
                for(_ , json) in value {
                    data.append(User(json: json as! [String : Any]))
                }
                callback(data)
        })
    }
    
   
    
    func getUserInfo(userId:String, callback:@escaping ([User])->Void){
        ref.child("users").observe(.value, with:
            {
                (snapshot) in
                var data = [User]()
                let value = snapshot.value as! [String : Any]
                for(_, json) in value {
                    data.append(User(json: json as! [String : Any]))
                }
                callback(data)
        })
    }
    
   
    
    func checkIfSignIn() -> Bool {
        return (Auth.auth().currentUser != nil)
    }
    
   
    
    func addNewUser(user : User){
        ref.child("users").child(user.id).setValue(user.toJson())
        print("")
    }
  
    
    
    func addNewUser(email : String , pass : String , userName : String , url : String){
        let id = getUserId()
        ref.child("users").child(id).setValue(["email":email , "pass":pass , "userName":userName , "url_profile_image" : url])
    }
    
  
    func getUserId()->String{
        return Auth.auth().currentUser!.uid
    }
    
  
    
    func getUserName()->String?{
        return Auth.auth().currentUser?.email
    }
    
 
    func getUser(byId : String)->Void{
        getUserInfo(userId: byId, callback: { (data) in
            print(data)
        })
    }
    

    
    
}

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
import FirebaseStorage
import Kingfisher
class ModelFirebase{
    
    var ref : DatabaseReference!
    lazy var storageRef = Storage.storage().reference(forURL: "gs://goldenhour-871f0.appspot.com")
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
    
    
    
    func getAllUserInfo(userId:String, callback:@escaping ([User])->Void){
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
    
    func getUserInfo(userId:String, callback:@escaping (User)->Void){
        ref.child("users").child(userId).observe(.value, with:
            {
                (snapshot) in
                //var data = [User]()
                let value = snapshot.value as! [String : Any]
                //for(_, json) in value {
                let user = User(json: value)
                //}
                callback(user)
        })
    }
    
    func addNewUser(user : User, callback:@escaping (Error?, DatabaseReference)->Void){
        ref.child("users").child(user.id).setValue(user.toJson()){ (error, reference) in
            print(reference.debugDescription)
            callback(error, reference)
        }
    }

    func addNewUser(email : String , password : String , userName : String , url : String){
        let id = getUserId()
        ref.child("users").child(id).setValue(["email":email , "password":password , "userName":userName , "url" : url])
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
    
    func getPost(postId:String, callback: @escaping (Post)->Void){
        ref.child("posts").child(postId).observe(.value, with:
            {
                (snapshot) in
                //var data = [User]()
                let value = snapshot.value as! [String : Any]
                //for(_, json) in value {
                let post = Post(json: value)
                //}
                callback(post)
        })
    }
    
    func getAllPosts(callback: @escaping ([Post])->Void){
        ref.child("posts").observe(.value, with:
            {
                (snapshot) in
                var data = [Post]()
                if let value = snapshot.value as? [String : Any]{
                    for(_, json) in value {
                        data.append(Post(json: json as! [String : Any]))
                    }
                }
                callback(data)
        })
    }
    
    func addNewPost(post:Post, callback:@escaping (Error?, DatabaseReference)->Void){
        ref.child("posts").child(post.postId).setValue(post.toJson()){ (error, reference) in
            print(reference.debugDescription)
            callback(error, reference)
        }
    }
    
    func addPostUrlToUser(userID:String, postID:String, callback:@escaping (Error?, DatabaseReference)->Void){
        ref.child("users").child(userID).child("posts").child("\(Model.connectedUser!.post.count+1)").setValue(postID){ (error, reference) in
            print(reference.debugDescription)
            callback(error, reference)
        }
    }
    
    func saveImage(image:UIImage, name:String ,callback:@escaping (String?)->Void){
        let data = image.jpegData(compressionQuality: 0.8)
        let imageRef = storageRef.child("post_images").child(name)
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        imageRef.putData(data!, metadata: metadata) { (metadata, error) in
            imageRef.downloadURL { (url, error) in
                guard let downloadURL = url else {
                    // Uh-oh, an error occurred!
                    return
                }
                print("url: \(downloadURL.absoluteString)")
                callback(downloadURL.absoluteString)
            }
        }
    }
    
    func saveProfileImage(image:UIImage, name:String ,callback:@escaping (String?)->Void){
        let data = image.jpegData(compressionQuality: 0.8)
        let imageRef = storageRef.child("profile_images").child(name)
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        imageRef.putData(data!, metadata: metadata) { (metadata, error) in
            imageRef.downloadURL { (url, error) in
                guard let downloadURL = url else {
                    // Uh-oh, an error occurred!
                    return
                }
                print("url: \(downloadURL.absoluteString)")
                callback(downloadURL.absoluteString)
            }
        }
    }
    
    func getImage(url : String , callback :@escaping (UIImage?)->Void){
        let ref = Storage.storage().reference(forURL: url)
        ref.getData(maxSize: 10 * 1024 * 1024) { (data, error) in
            if error != nil{
                callback(nil)
            }else{
                let image = UIImage(data : data!)
                callback(image)
            }
        }
    }
    
    
    func sendPostToDb(imageUrl : String, rank : [User], date : String, comments : [Comment], metaData : [Metadata]) {
        let postRef = ref.child("posts")
        let newPostId  = postRef.childByAutoId().key
        let newPostRef = postRef.child(newPostId!)
        
        newPostRef.setValue(["imageUrl": imageUrl, "rank": rank, "date" : date, "comments" : comments, "metaData" : metaData]) { (error, ref) in
            if error != nil
            {
                SVProgressHUD.showError(withStatus: error?.localizedDescription)
                return
            }else{
                SVProgressHUD.showSuccess(withStatus: "shared succes")
            }
            
        }
        
    }
    
    
    
    func sendDataToDataBase(imageUrl : String){
        let postRef = ref.child("posts")
        let newPostId  = postRef.childByAutoId().key
        let newPostRef = postRef.child(newPostId!)
        newPostRef.setValue(["imageUrl": imageUrl]) { (error, ref) in
            if error != nil
            {
                SVProgressHUD.showError(withStatus: error?.localizedDescription)
                return
            }else{
                SVProgressHUD.showSuccess(withStatus: "shared succes")
            }
        }
    }
    
    func signInByEmailAndPass(email : String, pass : String, callback : @escaping (Bool?)->Void){
        Auth.auth().signIn(withEmail: email, password: pass) { (user, error) in
            if(error != nil){
                callback(false)
            }
            callback(true)
        }
    }
    
    
    func checkIfSignIn()->Bool{
        return (Auth.auth().currentUser != nil)
    }
    
    
    func sign_Out() -> (Bool, Error?){
        do{
            try Auth.auth().signOut()
            return (true, nil)
        }catch let error{
            print(error.localizedDescription)
            return (false, error)
        }
    }
    
    
}





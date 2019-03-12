//
//  PostCache.swift
//  GoldenHour
//
//  Created by Daniel Segal on 14/01/2019.
//  Copyright © 2019 Zach Bachar. All rights reserved.
//

import Foundation
extension Model{
    func createPostTable(completion: ((Bool)->Void)? = nil)   {
        let tableName   = "POSTS"
        let tableColumn = "(POST_ID TEXT PRIMARY KEY, USER_ID TEXT, PHOTO_URL TEXT, TITLE TEXT, DATE TEXT)"
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
    
    
    func saveCache(posts: [Post], completion: ((Bool)->Void)? = nil) {
        for post in posts {
            var postAsString = [String]()
            postAsString.append(post.postId)
            postAsString.append(post.userId)
            postAsString.append(post.imageUrl!)
            postAsString.append(post.date)
            //
            CacheHandler.cache.save(name: "POSTS", dataToSave: postAsString, onSuccess: {
                completion?(true)
            }, onError: {
                completion?(false)
            })
        }
    }
    
    func getCache(completion: @escaping ([(Post, User)]?)->Void) {
        
        /* Gets Posts and users local data */
        var feedData = [(Post, User)]()
        CacheHandler.cache.get(name: "POSTS", onSuccess: { (postsAsString : Array<[String]>) in
      //      let posts = //need to pull posts and deal with jasons
            CacheHandler.cache.get(name: "USERS", onSuccess: { (usersAsString: Array<[String]>) in
           //     let users = //need to pull posts and deal with jasons
                
                /* Insert post and corresponding user into FeedData */
//                for post in posts {
//                    let user = users.first { $0?.userID == post?.userID }
//                    guard let post = post else { return }
//                    guard let correspondUser = user else { return }
//                    feedData.append((post, correspondUser!))
//                }
                completion(feedData)
            },onError: { completion(nil) })
        },onError: { completion(nil) })
    }
}

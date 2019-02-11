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
}

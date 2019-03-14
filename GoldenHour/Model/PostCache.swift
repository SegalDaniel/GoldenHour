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
       // self.dropPostTable()
        let tableName   = "POSTS"
        let tableColumn = "(POST_ID TEXT PRIMARY KEY, USER_ID TEXT, PHOTO_URL TEXT, DATE TEXT, TITLE TEXT, RANKS TEXT, COMMENTS TEXT, METADATA TEXT)"
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
        var postAsString = [String]()
        for post in posts {
            postAsString.append(post.postId)
            postAsString.append(post.userId)
            postAsString.append(post.imageUrl!)
            postAsString.append(post.date)
            postAsString.append(post.title)
            var ranks_to_save:String = ""
            post.rank.forEach { (rank) in
                ranks_to_save.append(rank)
                ranks_to_save.append(";")
            }
            postAsString.append(ranks_to_save)
            var com_to_save:String = ""
            post.comments.forEach { (comment) in
                com_to_save.append(stringify(json: comment.toJson()))
            }
            postAsString.append(com_to_save)
            postAsString.append(stringify(json: post.metaData.toJson()))
            CacheHandler.cache.save(name: "POSTS", dataToSave: postAsString, onSuccess: {
                completion?(true)
            }, onError: {
                completion?(false)
            })
            postAsString.removeAll()
        }
        
       
    }
        
    
 
    
    func getCache(completion: @escaping ([Post]?)->Void) {
        var completePosts:[Post]?
        CacheHandler.cache.get(name: "Posts", onSuccess: { (posts) in
            completePosts = []
            posts.forEach({ (postAsString) in
                //Ranks
                var ranks:[String] = []
                let ranksSplits = postAsString[5].split(separator: ";")
                ranksSplits.forEach({ (substring) in
                    ranks.append(String(substring))
                })
                //Comments
                var comments:[Comment] = []
                var meta:Metadata?
                let comString = postAsString[6]
                do{
                    //Metadata
                    let metaString = postAsString[7].data(using: .utf8)!
                    if let metaJson = try JSONSerialization.jsonObject(with: metaString, options: .allowFragments) as? Dictionary<String,Any>{
                        meta = Metadata(json: metaJson)
                    }
                    
                    if let jsonArray = try JSONSerialization.jsonObject(with: comString.data(using: .utf8)!, options : .allowFragments) as? [Dictionary<String,Any>]{
                        jsonArray.forEach({ (jsonComment) in
                            comments.append(Comment(json: jsonComment))
                        })
                    }
                }
                catch let error as NSError {
                    print(error)
                }
                let post = Post(_userId: postAsString[1], _postId: postAsString[0], _title: postAsString[5], _imageUrl: postAsString[3], metadata: meta!, _date: postAsString[4])
                post.setRanksAndComments(ranks: ranks, comments: comments)
                completePosts!.append(post)
            })
            completion(completePosts)
        }) {
        }
        
        }
        
    
     func stringify(json: Any, prettyPrinted: Bool = false) -> String {
        var options: JSONSerialization.WritingOptions = []
        if prettyPrinted {
            options = JSONSerialization.WritingOptions.prettyPrinted
        }
        
        do {
            let data = try JSONSerialization.data(withJSONObject: json, options: options)
            if let string = String(data: data, encoding: String.Encoding.utf8) {
                return string
            }
        } catch {
            print(error)
        }
        
        return ""
    }
    

    
    }
    



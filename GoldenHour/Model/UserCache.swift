//
//  UserCache.swift
//  GoldenHour
//
//  Created by Daniel Segal on 14/01/2019.
//  Copyright © 2019 Zach Bachar. All rights reserved.
//

import Foundation
extension Model{
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
}

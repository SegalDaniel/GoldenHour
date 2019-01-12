//
//  ModelSql.swift
//  GoldenHour
//
//  Created by דניאל סגל on 06/01/2019.
//  Copyright © 2019 Zach Bachar. All rights reserved.
//

import Foundation
import SQLite
import Firebase
import FirebaseCore
import FirebaseDatabase
class ModelSql : CacheService{
    
    var dbSql: OpaquePointer? = nil
    init() {
        let dbFileName = "databaseSql.db"
        if let dir = FileManager.default.urls(for: .documentDirectory, in:
            .userDomainMask).first{
            let path = dir.appendingPathComponent(dbFileName)
            if sqlite3_open(path.absoluteString, &dbSql) != SQLITE_OK {
                print("Failed to open db file: \(path.absoluteString)")
                return
            }
            
        }
    }
    

    func create(name: String, data: String?, onSuccess: ()->Void, onError: ()->Void) {
        guard let columns = data else { return }
        var errormsg: UnsafeMutablePointer<Int8>? = nil
        let statment = String(format: "CREATE TABLE IF NOT EXISTS %@%@", name, columns)
        let response = sqlite3_exec(dbSql, statment, nil, nil, &errormsg);
        if (response != 0) {
            onError(); return
        }
        onSuccess()
    }
    
    func delete(name: String, onSuccess: ()->Void, onError: ()->Void) {
        let statment = String(format: "DROP TABLE %@;", name)
        var errormsg: UnsafeMutablePointer<Int8>? = nil
        let response = sqlite3_exec(dbSql, statment, nil, nil, &errormsg);
        if (response != 0) {
            onError(); return
        }
        onSuccess()
    }
    
    
    
}


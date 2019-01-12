//
//  ModelSql.swift
//  GoldenHour
//
//  Created by דניאל סגל on 06/01/2019.
//  Copyright © 2019 Zach Bachar. All rights reserved.
//

import Foundation
import SQLite
class ModelSql{
    
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
            
            CreateTable()
        }
    }
    
    func CreateTable(){
        
        
    }
    func dropTable(){
        
    }
    
    
}

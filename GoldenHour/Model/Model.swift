//
//  Model.swift
//  GoldenHour
//
//  Created by Zach Bachar on 07/01/2019.
//  Copyright © 2019 Zach Bachar. All rights reserved.
//

import Foundation

class Model {
    static let instance:Model = Model()
    
    
    var modelSql = ModelSql();
    var modelFirebase = ModelFirebase();
    
    private init(){
        //modelSql = ModelSql()
    }
        
        
}


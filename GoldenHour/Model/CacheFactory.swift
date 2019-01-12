//
//  CacheFactory.swift
//  GoldenHour
//
//  Created by Daniel Segal on 13/01/2019.
//  Copyright © 2019 Zach Bachar. All rights reserved.
//

import Foundation
class CacheFactory {
    enum cacheType {
        case sqlite
    }
    
    static func create(_ type: cacheType) -> CacheService {
        switch type {
        case .sqlite: return ModelSql()
        }
    }
}

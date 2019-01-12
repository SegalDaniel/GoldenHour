//
//  CacheHandler.swift
//  GoldenHour
//
//  Created by Daniel Segal on 12/01/2019.
//  Copyright © 2019 Zach Bachar. All rights reserved.
//

import Foundation
class CacheHandler{
     static let cache   : CacheService    = CacheFactory.create(.sqlite)
}


protocol CacheService {
    func create(name: String, data: String?, onSuccess: ()->Void, onError: ()->Void)
}

//
//  Metadata.swift
//  GoldenHour
//
//  Created by דניאל סגל on 03/01/2019.
//  Copyright © 2019 Zach Bachar. All rights reserved.
//

import Foundation
class Metadata {
    let manufacturer:String
    let model:String
    let lens:String
    let shutterSpeed:Int
    let aperture:Int
    let externalAccesssories:String
    let location:String
    
    
    
    
    init(_manufacturer:String, _model:String, _lens:String, _shutterSpeed:Int, _aperture:Int, _externalAccesssories:String, _location:String) {
        self.manufacturer=_manufacturer
        self.model=_model
        self.lens=_lens
        self.shutterSpeed=_shutterSpeed
        self.aperture=_aperture
        self.externalAccesssories=_externalAccesssories
        self.location=_location
    }
    
    
    
    
    
    init(json:[String:Any]) {
        manufacturer = json["manufacturer"] as! String
        model = json["model"] as! String
        lens = json["lens"] as! String
        shutterSpeed = json["shutterSpeed"] as! Int
        aperture = json["aperture"] as! Int
        externalAccesssories = json["externalAccesssories"] as! String
        location = json["location"] as! String
    }
    
    
    
    
    func toJson() -> [String:Any] {
        var json = [String:Any]()
        json["manufacturer"] = manufacturer
        json["model"] = model
        json["lens"] = lens
        json["shutterSpeed"] = shutterSpeed
        json["aperture"] = aperture
        json["externalAccesssories"] = externalAccesssories
        json["location"] = location
        
        return json
    }
}


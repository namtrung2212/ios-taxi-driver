//
//  User.swift
//  BOOKTAXI
//
//  Created by Trung Dao on 4/7/16.
//  Copyright © 2016 SCONNECTING. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper

open class Driver: BaseModel {
    
    open dynamic var Name : String?
    open dynamic var Birthday : Date?
    open dynamic var CitizenID : String?
    open dynamic var CitizenIDDate : Date?
    open dynamic var Country : String?
    open dynamic var Province : String?
    open dynamic var Gender : String?
    open dynamic var PhoneNo : String?
    
    open dynamic var EmailAddr : String?
    open dynamic var DriverSetting : String?
    open dynamic var DriverStatus : String? 
    
    required convenience public init?(_ map: Map) {
        self.init()
    }
    
    open override func mapping(_ map: Map) {
        
        super.mapping(map);
        
        Name    <- map["Name"]
        Birthday <- (map["Birthday"], MongoDateTransform())
        CitizenID    <- map["CitizenID"]
        CitizenIDDate    <- (map["CitizenIDDate"], MongoDateTransform())
        Country <- map["Country"]
        Province    <- map["Province"]
        Gender <- map["Gender"]
        PhoneNo <- map["PhoneNo"]
        EmailAddr    <- map["EmailAddr"]
        DriverSetting <- map["DriverSetting"]
        DriverStatus <- map["DriverStatus"]
        
    }
    
}

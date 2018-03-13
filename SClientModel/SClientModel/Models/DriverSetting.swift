//
//  Driver.swift
//  BOOKTAXI
//
//  Created by Trung Dao on 4/7/16.
//  Copyright © 2016 SCONNECTING. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper

open class DriverSetting: BaseModel {
    
    open dynamic var Driver : String?
    open dynamic var Language : String?
    open dynamic var Currency : String?
    
    open dynamic var DeviceID : String?
    open dynamic var Device : String?
    
    open dynamic var IsVerified : Bool = false
    open dynamic var VerifiedDate : Date?
    
    
    required convenience public init?(_ map: Map) {
        self.init()
    }
    
    open override func mapping(_ map: Map) {
        
        super.mapping(map);
        
        Driver    <- map["Driver"]
        Language <- map["Language"]
        Currency    <- map["Currency"]
        DeviceID <- map["DeviceID"]
        Device <- map["Device"]
        IsVerified <- map["IsVerified"]
        VerifiedDate <- (map["VerifiedDate"], MongoDateTransform())
    }
    
}

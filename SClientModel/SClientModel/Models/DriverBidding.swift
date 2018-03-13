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

open class DriverBidding: BaseModel {
    
    
    open dynamic var TravelOrder : String?
    open dynamic var Driver : String?
    open dynamic var WorkingPlan : String?
    open dynamic var Company : String?
    open dynamic var Team : String?
    open dynamic var User : String?
    
    open dynamic var Message : String?
    open dynamic var ExpireTime : Date?
    open dynamic var Status : String?

    
    required convenience public init?(_ map: Map) {
        self.init()
    }
    
    open override func mapping(_ map: Map) {
        
        super.mapping(map);
        
        TravelOrder <- map["TravelOrder"]
        Driver    <- map["Driver"]
        WorkingPlan    <- map["WorkingPlan"]
        Company    <- map["Company"]
        Team <- map["Team"]
        User <- map["User"]
        ExpireTime    <- (map["ExpireTime"], MongoDateTransform())
        Message    <- map["Message"]
        Status <- map["Status"]
        
    }
    
}

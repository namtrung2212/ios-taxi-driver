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

import CoreLocation

open class TravelOrderChatting: BaseModel {
    
    open dynamic var Order : String?
    open dynamic var User : String?
    open dynamic var UserName : String?
    
    open dynamic var Driver : String?
    open dynamic var DriverName : String?
    open dynamic var CitizenID : String?
    
    open dynamic var Car : String?
    open dynamic var CarNo : String?

    open dynamic var IsUser : Bool = false
    open dynamic var IsViewed : Bool = false
    open dynamic var Content : String?
    open dynamic var ImageIDs : String?
    open dynamic var Location : LocationObject?
    
    required convenience public init?(_ map: Map) {
        self.init()
    }
    
    open override func mapping(_ map: Map) {
        
        super.mapping(map);
        
        Order    <- map["Order"]
        
        User    <- map["User"]
        UserName    <- map["UserName"]
        
        Driver    <- map["Driver"]
        DriverName    <- map["DriverName"]
        CitizenID    <- map["CitizenID"]
        
        Car    <- map["Car"]
        CarNo    <- map["CarBrand"]
        
        
        IsUser    <- map["IsUser"]
        IsViewed    <- map["IsViewed"]

        Content    <- map["Content"]
        ImageIDs <- map["ImageIDs"]
        
        Location    <- (map["Location"],LocationTransform())
    }
    
    
    
}

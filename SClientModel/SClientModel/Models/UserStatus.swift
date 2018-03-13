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

open class UserStatus: BaseModel {
    
    open dynamic var User : String? = nil
    open dynamic var UserSetting : String? = nil
    
    open dynamic var Location :  LocationObject?
    open dynamic var Address : String?
    open dynamic var Speed : Double = 0
    
    open dynamic var IsActivated : Bool = false
    open dynamic var ActivatedDate : Date? = nil
    
    open dynamic var AutoLockChangeDate : Date? = nil
    open dynamic var IsLocked : Bool = false
    open dynamic var LockChangedDate : Date? = nil
    open dynamic var LockedReason : String?
        
    open dynamic var LastLogin : Date? = nil
    open dynamic var LastOnline : Date? = nil
    open dynamic var IsOnline : Bool = false
    
    open dynamic var MonthlyLocation :  LocationObject?
    open dynamic var MonthlyDistance : Double = 0
    
    open dynamic var ServedQty : Int = 0
    open dynamic  var VoidedBfPickupByDriver : Int = 0
    open dynamic  var VoidedBfPickupByUser : Int = 0
    open dynamic  var VoidedAfPickupByDriver : Int = 0
    open dynamic  var VoidedAfPickupByUser : Int = 0
    
    required convenience public init?(_ map: Map) {
        self.init()
    }
    
    open override func mapping(_ map: Map) {
        
        super.mapping(map);
        
        User    <- map["User"]
        UserSetting <- map["UserSetting"]
        Location    <- (map["Location"],LocationTransform())
        Address <- map["Address"]
        Speed <- map["Speed"]
        
        IsActivated    <- map["IsActivated"]
        ActivatedDate    <-  (map["ActivatedDate"],MongoDateTransform())
        
        AutoLockChangeDate    <-  (map["AutoLockChangeDate"],MongoDateTransform())
        IsLocked    <- map["IsLocked"]
        LockChangedDate    <-  (map["LockChangedDate"],MongoDateTransform())
        LockedReason    <- map["LockedReason"]
        
        LastLogin <- (map["LastLogin"], MongoDateTransform())
        LastOnline    <- (map["LastOnline"], MongoDateTransform())
        IsOnline <- map["IsOnline"]
        MonthlyLocation    <- (map["MonthlyLocation"],LocationTransform())
        MonthlyDistance <- map["MonthlyDistance"]
        
        ServedQty    <- map["ServedQty"]
        VoidedBfPickupByDriver    <- map["VoidedBfPickupByDriver"]
        VoidedBfPickupByUser    <- map["VoidedBfPickupByUser"]
        VoidedAfPickupByDriver    <- map["VoidedAfPickupByDriver"]
        VoidedAfPickupByUser    <- map["VoidedAfPickupByUser"]

        
    }
    
}

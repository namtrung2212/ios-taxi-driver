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

open class DriverStatus: BaseModel {
    
    open dynamic var Driver : String?
    open dynamic var DriverName : String?
    open dynamic var CitizenID : String?
    open dynamic var PhoneNo : String?

    open dynamic var WorkingPlan : String?
    
    open dynamic var Company : String?
    open dynamic var CompanyName : String?
    open dynamic var Team : String?
    open dynamic var TeamName : String?
    open dynamic var Country : String?
    open dynamic var Car : String?
    open dynamic var CarNo : String?
    open dynamic var CarBrand : String?
    open dynamic var CarSeater: String?
    open dynamic var CarProvince : String?
    open dynamic var QualityService : String?
    
    open dynamic var DriverSetting : String? = nil
    open dynamic var Location : LocationObject?
    open dynamic var Address : String?
    open dynamic var Degree : Double = 0
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
    open dynamic var IsReady : Bool = false
    open dynamic var IsCarTaken : Bool = false
    
    open dynamic var MonthlyLocation :   LocationObject?
    open dynamic var MonthlyDistance : Double = 0
    
    open dynamic var Rating : Int = 0
    open dynamic var RateCount : Int = 0
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
        
        Driver    <- map["Driver"]
        DriverName    <- map["DriverName"]
        CitizenID    <- map["CitizenID"]
        PhoneNo    <- map["PhoneNo"]
        
        WorkingPlan <- map["WorkingPlan"]
        Company <- map["Company"]
        CompanyName <- map["CompanyName"]
        Team <- map["Team"]
        TeamName <- map["TeamName"]
        Country <- map["Country"]
        Car <- map["Car"]
        CarNo <- map["CarNo"]
        CarBrand    <- map["CarBrand"]
        CarSeater    <- map["CarSeater"]
        CarProvince <- map["CarProvince"]
        QualityService    <- map["QualityService"]
        
        DriverSetting <- map["DriverSetting"]
        Location    <- (map["Location"],LocationTransform())
        Address <- map["Address"]
    
        Degree <- map["Degree"]
        Speed <- map["Speed"]
        
        IsActivated    <- map["IsActivated"]
        ActivatedDate    <-  (map["ActivatedDate"],MongoDateTransform())
        
        AutoLockChangeDate    <-  (map["AutoLockChangeDate"],MongoDateTransform())
        IsLocked    <- map["IsLocked"]
        LockChangedDate    <-  (map["LockChangedDate"],MongoDateTransform())
        LockedReason    <- map["LockedReason"]
        
        LastLogin <- (map["LastLogin"], MongoDateTransform())
        LastOnline    <- (map["LastOnline"], MongoDateTransform())
        IsCarTaken <- map["IsCarTaken"]
        IsOnline <- map["IsOnline"]
        IsReady <- map["IsReady"]
        MonthlyLocation    <- (map["MonthlyLocation"],LocationTransform())
        MonthlyDistance <- map["MonthlyDistance"]
        
        Rating    <- map["Rating"]
        RateCount    <- map["RateCount"]
        ServedQty    <- map["ServedQty"]
        VoidedBfPickupByDriver    <- map["VoidedBfPickupByDriver"]
        VoidedBfPickupByUser    <- map["VoidedBfPickupByUser"]
        VoidedAfPickupByDriver    <- map["VoidedAfPickupByDriver"]
        VoidedAfPickupByUser    <- map["VoidedAfPickupByUser"]

        
    }
    
}

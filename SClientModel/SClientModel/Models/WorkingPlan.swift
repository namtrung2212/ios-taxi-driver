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

open class WorkingPlan: BaseModel {
    
    open dynamic var Driver : String?
    open dynamic var DriverName : String?
    open dynamic var CitizenID : String?

    open dynamic var Company : String?
    open dynamic var CompanyName : String?
    open dynamic var Team : String?
    open dynamic var TeamName : String?

    open dynamic var Car : String?
    open dynamic var CarNo : String?
    open dynamic var CarBrand : String?
    open dynamic var CarSeater: String?
    open dynamic var CarProvince : String?
    open dynamic var Country : String?
    open dynamic var QualityService : String?
    
    open dynamic var IsLeader : Bool = false
    open dynamic var Priority : Int = 0
    open dynamic var IsEnable : Bool = true
    open dynamic var IsActive : Bool = false
    open dynamic var FromDateTime : Date = Date()
    open dynamic var ToDateTime : Date? = nil
    
    required convenience public init?(_ map: Map) {
        self.init()
    }
    
    open override func mapping(_ map: Map) {
        
        super.mapping(map);
        
        Driver    <- map["Driver"]
        DriverName    <- map["DriverName"]
        CitizenID    <- map["CitizenID"]

        Company <- map["Company"]
        CompanyName <- map["CompanyName"]
        Team <- map["Team"]
        TeamName <- map["TeamName"]

        Car    <- map["Car"]
        CarNo    <- map["CarNo"]
        CarSeater    <- map["CarSeater"]
        CarProvince    <- map["CarProvince"]
        CarBrand    <- map["CarBrand"]

        Country    <- map["Country"]
        QualityService    <- map["QualityService"]
        IsLeader <- map["IsLeader"]
        Priority <- map["Priority"]
        IsEnable <- map["IsEnable"]
        IsActive <- map["IsActive"]
        FromDateTime <- (map["FromDateTime"], MongoDateTransform())
        ToDateTime    <- (map["ToDateTime"], MongoDateTransform())
        
    }
    
}

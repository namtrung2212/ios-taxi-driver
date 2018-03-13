//
//  Car.swift
//  BOOKTAXI
//
//  Created by Trung Dao on 4/7/16.
//  Copyright © 2016 SCONNECTING. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper

open class CarStatus: BaseModel {
    
    open dynamic var Car : String?
    open dynamic var CarNo : String?
    open dynamic var CarBrand : String?
    open dynamic var CarSeater: String?
    open dynamic var CarProvince : String?
    open dynamic var QualityService : String?
    open dynamic var Company : String?
    open dynamic var CompanyName : String?
    open dynamic var Team : String?
    open dynamic var TeamName : String?
    open dynamic var Country : String?
    open dynamic var Driver : String?
    open dynamic var DriverName : String?
    open dynamic var CitizenID : String?

    open dynamic var DriverCount : Int = 0
    open dynamic var Location :  LocationObject?
    open dynamic var Address : String?
    open dynamic var Degree : Double = 0
    open dynamic var Speed : Double = 0
    open dynamic var IsInUse : Bool = false
    open dynamic var IsDriving : Bool = false
    
    open dynamic var MonthlyLocation :  LocationObject?
    
    dynamic var MonthlyDistance : Double = 0
    dynamic var TaxiOrderCount : Int = 0
    
    required convenience public init?(_ map: Map) {
        self.init()
    }
    
    open override func mapping(_ map: Map) {
        
        super.mapping(map);
        
        Car    <- map["Car"]
        CarNo    <- map["CarNo"]
        CarBrand    <- map["CarBrand"]
        CarSeater    <- map["CarSeater"]
        CarProvince    <- map["CarProvince"]
        QualityService    <- map["QualityService"]

        Company <- map["Company"]
        CompanyName <- map["CompanyName"]
        Team <- map["Team"]
        TeamName <- map["TeamName"]
        Country <- map["Country"]
        Driver <- map["Driver"]
        DriverName <- map["DriverName"]
        CitizenID <- map["CitizenID"]
        DriverCount <- map["DriverCount"]
        Location    <- (map["Location"],LocationTransform())
        Address <- map["Address"]
        Degree <- map["Degree"]
        Speed <- map["Speed"]
        IsInUse <- map["IsInUse"]
        IsDriving <- map["IsDriving"]
        MonthlyLocation    <- (map["MonthlyLocation"],LocationTransform())
        MonthlyDistance <- map["MonthlyDistance"]
        TaxiOrderCount <- map["TaxiOrderCount"]
        
    }
    
}

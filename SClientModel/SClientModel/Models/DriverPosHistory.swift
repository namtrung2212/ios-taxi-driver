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

open class DriverPosHistory: BaseModel {
    
    open dynamic var Driver : String?
    open dynamic var WorkingPlan : String?
    open dynamic var Company : String?
    open dynamic var Team : String?
    open dynamic var Country : String?
    open dynamic var Car : String?
    
    open dynamic var Location :  LocationObject?
    open dynamic var Address : String?
    open dynamic var Degree : Double = 0
    open dynamic var Speed : Double = 0
    
    open dynamic var DeviceID : String?
    open dynamic var Device : String?
    
    required convenience public init?(_ map: Map) {
        self.init()
    }
    
    open override func mapping(_ map: Map) {
        
        super.mapping(map);
        
        Driver    <- map["Driver"]
        WorkingPlan <- map["WorkingPlan"]
        Company <- map["Company"]
        Team <- map["Team"]
        Country <- map["Country"]
        Car    <- map["Car"]
        Location    <- (map["Location"],LocationTransform())
        Address <- map["Address"]
        Degree <- map["Degree"]
        Speed <- map["Speed"]
        DeviceID <- map["DeviceID"]
        Device <- map["Device"]
        
    }
    
}

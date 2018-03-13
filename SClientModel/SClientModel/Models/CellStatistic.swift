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

open class CellStatistic: BaseModel {
    
    
    open dynamic var Location :  LocationObject?
    open dynamic var Distance : Int = 0
    open dynamic var DriverQty : Int = 0
    open dynamic var OnlineUserQty : Int = 0
    open dynamic var OnDemandUserQty : Int = 0
    open dynamic var PotentialUserQty : Int = 0
    open dynamic var CompetitiveRatio : Int = 0
    open dynamic var AverageOrderQty : Int = 0
    open dynamic var AverageSpeed : Int = 0
    open dynamic var MaxLimitSpeed : Int = 0
    
    required convenience public init?(_ map: Map) {
        self.init()
    }
    
    open override func mapping(_ map: Map) {
        
        super.mapping(map);
        
        Location    <- (map["Location"],LocationTransform())
        Distance <- map["Distance"]
        DriverQty <- map["DriverQty"]
        OnlineUserQty    <- map["OnlineUserQty"]
        OnDemandUserQty <- map["OnDemandUserQty"]
        PotentialUserQty <- map["PotentialUserQty"]
        CompetitiveRatio <- map["CompetitiveRatio"]
        AverageOrderQty <- map["AverageOrderQty"]
        AverageSpeed <- map["AverageSpeed"]
        MaxLimitSpeed <- map["MaxLimitSpeed"]
    }
    
}

//
//  Team.swift
//  BOOKTAXI
//
//  Created by Trung Dao on 4/7/16.
//  Copyright © 2016 SCONNECTING. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper



open class Team: BaseModel {
    
    open dynamic var Name : String?
    open dynamic var Leader : String?
    open dynamic var Hotline : String?
    
    open dynamic var Company : String?
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
        
        Name    <- map["Name"]
        Leader    <- map["Leader"]
        Hotline    <- map["Hotline"]
        Company <- map["Company"]
        
        Rating    <- map["Rating"]
        RateCount    <- map["RateCount"]
        ServedQty    <- map["ServedQty"]
        VoidedBfPickupByDriver    <- map["VoidedBfPickupByDriver"]
        VoidedBfPickupByUser    <- map["VoidedBfPickupByUser"]
        VoidedAfPickupByDriver    <- map["VoidedAfPickupByDriver"]
        VoidedAfPickupByUser    <- map["VoidedAfPickupByUser"]
    }
    
}

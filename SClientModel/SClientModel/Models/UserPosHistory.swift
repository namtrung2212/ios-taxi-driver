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

open class UserPosHistory: BaseModel {
    
    open dynamic var User : String?
    open dynamic var Location :  LocationObject?
    open dynamic var Address : String?
    open dynamic var Speed : Double = 0
    
    open dynamic var DeviceID : String?
    open dynamic var Device : String?

    required convenience public init?(_ map: Map) {
        self.init()
    }
    
    open override func mapping(_ map: Map) {
        
        super.mapping(map);
        
        User    <- map["User"]
        Location    <- (map["Location"],LocationTransform())
        Address <- map["Address"]
        Speed <- map["Speed"]
        DeviceID <- map["DeviceID"]
        Device <- map["Device"]

    }
    
}

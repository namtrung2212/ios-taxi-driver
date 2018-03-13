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

open class UserActivity: BaseModel {
    
    open dynamic var User : String?
    open dynamic var Location :  LocationObject?
    open dynamic var ActionType : String?

    required convenience public init?(_ map: Map) {
        self.init()
    }
    
    open override func mapping(_ map: Map) {
        
        super.mapping(map);
        
        User    <- map["User"]
        Location    <- (map["Location"],LocationTransform())
        ActionType <- map["ActionType"]
        
    }
    
}

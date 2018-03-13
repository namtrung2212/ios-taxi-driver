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



open class ExchangeRate: BaseModel {
    
    open dynamic var SourceCurry : String?
    open dynamic var DestCurry : String? 
    open dynamic var ExRate : Double = 1
    
    required convenience public init?(_ map: Map) {
        self.init()
    }
    
    open override func mapping(_ map: Map) {
        
        super.mapping(map);
        
        SourceCurry    <- map["SourceCurry"]
        DestCurry    <- map["DestCurry"]
        ExRate    <- map["ExRate"]
        
    }
    
}

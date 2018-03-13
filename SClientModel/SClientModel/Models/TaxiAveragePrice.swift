//
//  TaxiAveragePrice.swift
//  SClientModel
//
//  Created by Trung Dao on 4/15/16.
//  Copyright © 2016 SCONNECTING. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper

open class TaxiAveragePrice: BaseModel {
    
    open dynamic var Country : String?
    open dynamic var Currency : String? 
    open dynamic var AverageUnitPrice : Double = 0
    
    required convenience public init?(_ map: Map) {
        self.init()
    }
    
    open override func mapping(_ map: Map) {
        
        super.mapping(map);
        
        Country <- map["Country"]
        AverageUnitPrice <- map["AverageUnitPrice"]
        Currency <- map["Currency"]
        
    }
}

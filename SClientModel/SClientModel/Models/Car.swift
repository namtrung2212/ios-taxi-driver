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



open class Car: BaseModel {
    
    open dynamic var Country : String?
    open dynamic var Province : String?
    open dynamic var No : String?
    open dynamic var Seater : Int = 7
    open dynamic var QualityService : String = "Normal"
    open dynamic var Brand : String?
    open dynamic var Version : String?
    
    open dynamic var OwnerName : String?
    open dynamic var OwnerAddress : String?
    open dynamic var OwnerPhoneNo : String?
    open dynamic var CarStatus : String? 
    
    required convenience public init?(_ map: Map) {
        self.init()
    }
    
    open override func mapping(_ map: Map) {
        
        super.mapping(map);
        
        Country <- map["Country"]
        Province    <- map["Province"]
        No <- map["No"]
        Seater <- map["Seater"]
        QualityService    <- map["QualityService"]
        Brand <- map["Brand"]
        Version    <- map["Version"]
        OwnerName    <- map["OwnerName"]
        OwnerAddress    <- map["OwnerAddress"]
        OwnerPhoneNo    <- map["OwnerPhoneNo"]

        CarStatus <- map["CarStatus"]
    }
    
}

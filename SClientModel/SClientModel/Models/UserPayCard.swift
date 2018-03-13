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

open class UserPayCard: BaseModel {
    
    open dynamic var User : String?
    open dynamic var Currency : String?
    
    open dynamic var Bank : String?
    open dynamic var BankAcc : String?
    open dynamic var BankAccOwner : String?
    open dynamic var CardType : String?
    open dynamic var CardNo : String?
    open dynamic var CardExpireDate : Date?
    open dynamic var SecurityCode : String?
    
    open dynamic var IsVerified : Bool = false
    open dynamic var IsExpired : Bool = false
    open dynamic var IsLocked : Bool = false

    
    required convenience public init?(_ map: Map) {
        self.init()
    }
    
    open override func mapping(_ map: Map) {
        
        super.mapping(map);
        
        User <- map["User"]
        Currency    <- map["Currency"]
        
        Bank    <- map["Bank"]
        BankAcc    <- map["BankAcc"]
        BankAccOwner <- map["BankAccOwner"]
        CardType    <- map["CardType"]
        CardNo    <- map["CardNo"]
        CardExpireDate    <- (map["CardExpireDate"], MongoDateTransform())
        SecurityCode    <- map["SecurityCode"]
        
        IsVerified    <- map["IsVerified"]
        IsExpired    <- map["IsExpired"]
        IsLocked    <- map["IsLocked"]
        
    }
    
}

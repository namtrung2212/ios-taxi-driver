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

open class BusinessCard: BaseModel {
    
    open dynamic var CardNo : String?
    open dynamic var CardOwner : String?
    open dynamic var AccountOwner : String?
    open dynamic var BusinessName : String?

    open dynamic var Account : String?
    open dynamic var AccountNo : String?
    open dynamic var Currency : String?
    
    open dynamic var AutoActivateDate : Date?
    open dynamic var IsActivated : Bool = false
    open dynamic var ActivatedDate : Date?
    
    open dynamic var WillExpireDate : Date?
    open dynamic var IsExpired : Bool = false
    open dynamic var ExpiredDate : Date?
    
    open dynamic var AutoLockChangeDate : Date?
    open dynamic var IsLocked : Bool = false
    open dynamic var LockChangedDate : Date?
    open dynamic var LockedReason : String?
    
    open dynamic var PaymentTotal : Double = 0
    
    required convenience public init?(_ map: Map) {
        self.init()
    }
    
    open override func mapping(_ map: Map) {
        
        super.mapping(map);
        
        CardNo <- map["CardNo"]
        CardOwner    <- map["CardOwner"]
        AccountOwner    <- map["AccountOwner"]
        BusinessName    <- map["BusinessName"]

        Account    <- map["Account"]
        AccountNo    <- map["AccountNo"]
        Currency    <- map["Currency"]
        
        AutoActivateDate    <- (map["AutoActivateDate"], MongoDateTransform())
        IsActivated    <- map["IsActivated"]
        ActivatedDate    <- (map["ActivatedDate"], MongoDateTransform())
        
        WillExpireDate    <- (map["WillExpireDate"], MongoDateTransform())
        IsExpired    <- map["IsExpired"]
        ExpiredDate    <- (map["ExpiredDate"], MongoDateTransform())
        
        AutoLockChangeDate    <- (map["AutoLockChangeDate"], MongoDateTransform())
        IsLocked    <- map["IsLocked"]
        LockChangedDate    <- (map["LockChangedDate"], MongoDateTransform())
        LockedReason    <- map["LockedReason"]
        
        PaymentTotal    <- map["PaymentTotal"]
        
    }
    
}

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

open class BusinessAccount: BaseModel {
    
    open dynamic var AccountNo : String?
    open dynamic var AccountOwner : String?
    open dynamic var BusinessName : String?

    open dynamic var IsPersonal : Bool = true
    open dynamic var Currency : String?
    
    open dynamic var Manager : String?
    
    open dynamic var AutoActivateDate : Date?
    open dynamic var IsActivated : Bool = false
    open dynamic var ActivatedDate : Date?
    
    open dynamic var AutoLockChangeDate : Date?
    open dynamic var IsLocked : Bool = false
    open dynamic var LockChangedDate : Date?
    open dynamic var LockedReason : String?
    
    open dynamic var CashInTotal : Double = 0
    open dynamic var CashOutTotal : Double = 0
    open dynamic var CashTransferInTotal : Double = 0
    open dynamic var CashTransferOutTotal : Double = 0
    open dynamic var Balance : Double = 0
    
    required convenience public init?(_ map: Map) {
        self.init()
    }
    
    open override func mapping(_ map: Map) {
        
        super.mapping(map);
        
        AccountNo <- map["AccountNo"]
        AccountOwner    <- map["AccountOwner"]
        BusinessName    <- map["BusinessName"]

        IsPersonal    <- map["IsPersonal"]
        Currency    <- map["Currency"]
        
        Manager    <- map["Manager"]
        
        AutoActivateDate    <- (map["AutoActivateDate"], MongoDateTransform())
        IsActivated    <- map["IsActivated"]
        ActivatedDate    <- (map["ActivatedDate"], MongoDateTransform())
        
        AutoLockChangeDate    <- (map["AutoLockChangeDate"], MongoDateTransform())
        IsLocked    <- map["IsLocked"]
        LockChangedDate    <- (map["LockChangedDate"], MongoDateTransform())
        LockedReason    <- map["LockedReason"]
        
        CashInTotal    <- map["CashInTotal"]
        CashOutTotal    <- map["CashOutTotal"]
        CashTransferInTotal    <- map["CashTransferInTotal"]
        CashTransferOutTotal    <- map["CashTransferOutTotal"]
        Balance    <- map["Balance"]
                
    }
    
}

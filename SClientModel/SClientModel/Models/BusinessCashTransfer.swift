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

open class BusinessCashTransfer: BaseModel {

    open dynamic var SourceAccount : String?
    open dynamic var SourceAccountNo : String?
    open dynamic var SourceAccountOwner : String?
    open dynamic var Currency : String?
    
    open dynamic var DestinyAccountNo : String?
    open dynamic var DestinyAccount : String?
    open dynamic var DestinyAccountOwner : String?
    
    open dynamic var RefFIDocNo : String?
    open dynamic var RefFIDocDesc : String?
    open dynamic var RefFIDocDate : Date?
    
    open dynamic var PartnerTransNo : String?
    open dynamic var PartnerTransDesc : String?
    open dynamic var PartnerTransDate : Date?
    
    open dynamic var TransferCash : Double = 0
    open dynamic var TransferedDate : Date?
    open dynamic var IsTransfered : Bool = false
    
    required convenience public init?(_ map: Map) {
        self.init()
    }
    
    open override func mapping(_ map: Map) {
        
        super.mapping(map);
        
        SourceAccount <- map["SourceAccount"]
        SourceAccountNo    <- map["SourceAccountNo"]
        SourceAccountOwner    <- map["SourceAccountOwner"]
        Currency    <- map["Currency"]
        
        DestinyAccountNo <- map["DestinyAccountNo"]
        DestinyAccount    <- map["DestinyAccount"]
        DestinyAccountOwner    <- map["DestinyAccountOwner"]
        
        RefFIDocNo    <- map["RefFIDocNo"]
        RefFIDocDesc    <- map["RefFIDocDesc"]
        RefFIDocDate    <- (map["RefFIDocDate"], MongoDateTransform())
        
        PartnerTransNo    <- map["PartnerTransNo"]
        PartnerTransDesc    <- map["PartnerTransDesc"]
        PartnerTransDate    <- (map["PartnerTransDate"], MongoDateTransform())
        
        TransferCash    <- map["TransferCash"]
        TransferedDate    <- (map["TransferedDate"], MongoDateTransform())
        IsTransfered    <- map["IsTransfered"]
        
    }
    
}

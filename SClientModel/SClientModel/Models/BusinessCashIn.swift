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

open class BusinessCashIn: BaseModel {
    
    open dynamic var Account : String?
    open dynamic var AccountNo : String?
    open dynamic var AccountOwner : String?
    open dynamic var Currency : String?
    
    open dynamic var RefFIDocNo : String?
    open dynamic var RefFIDocDesc : String?
    open dynamic var RefFIDocDate : Date?
    
    open dynamic var OurBank : String?
    open dynamic var OurBankAcc : String?
    
    open dynamic var PartnerBank : String?
    open dynamic var PartnerAcc : String?
    open dynamic var PartnerAccOwner : String?
    open dynamic var PartnerTransNo : String?
    open dynamic var PartnerTransDesc : String?
    open dynamic var PartnerTransDate : Date?
    
    open dynamic var EmbededTransferUser : String?
    open dynamic var EmbededPayCard : String?
    open dynamic var EmbededCardNo : String?
    open dynamic var EmbededCardExpireDate : Date?
    open dynamic var EmbededVerifyCode : String?
    
    open dynamic var IsVerified : Bool = false
    open dynamic var IsSucceed : Bool = false
    
    open dynamic var ReceiveCash : Double = 0
    open dynamic var ReceivedDate : Date?
    open dynamic var IsReceived : Bool = false
    
    required convenience public init?(_ map: Map) {
        self.init()
    }
    
    open override func mapping(_ map: Map) {
        
        super.mapping(map);
        
        Account <- map["Account"]
        AccountNo    <- map["AccountNo"]
        AccountOwner    <- map["AccountOwner"]
        Currency    <- map["Currency"]
        
        RefFIDocNo    <- map["RefFIDocNo"]
        RefFIDocDesc    <- map["RefFIDocDesc"]
        RefFIDocDate    <- (map["RefFIDocDate"], MongoDateTransform())
        
        OurBank    <- map["OurBank"]
        OurBankAcc    <- map["OurBankAcc"]
        
        PartnerBank    <- map["PartnerBank"]
        PartnerAcc    <- map["PartnerAcc"]
        PartnerAccOwner    <- map["PartnerAccOwner"]
        PartnerTransNo    <- map["PartnerTransNo"]
        PartnerTransDesc    <- map["PartnerTransDesc"]
        PartnerTransDate    <- (map["PartnerTransDate"], MongoDateTransform())
        
        EmbededTransferUser    <- map["EmbededTransferUser"]
        EmbededPayCard    <- map["EmbededPayCard"]
        EmbededCardNo    <- map["EmbededCardNo"]
        EmbededCardExpireDate    <- (map["EmbededCardExpireDate"], MongoDateTransform())
        EmbededVerifyCode    <- map["EmbededVerifyCode"]
        
        IsVerified    <- map["IsVerified"]
        IsSucceed    <- map["IsSucceed"]
        
        ReceiveCash    <- map["ReceiveCash"]
        ReceivedDate    <- (map["ReceivedDate"], MongoDateTransform())
        IsReceived    <- map["IsReceived"]
        
    }
    
}

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

open class BusinessCashOut: BaseModel {
    
    open dynamic var Account : String?
    open dynamic var AccountNo : String?
    open dynamic var AccountOwner : String?
    open dynamic var Currency : String?
    
    open dynamic var RefFIDocNo : String?
    open dynamic var RefFIDocDesc : String?
    open dynamic var RefFIDocDate : Date?
    
    open dynamic var OurBank : String?
    open dynamic var OurBankAcc : String?
    open dynamic var OurAccOwner : String?
    open dynamic var OurCardNo : String?
    open dynamic var OurCardExpireDate : Date?
    open dynamic var OurTransNo : String?
    open dynamic var OurTransDesc : String?
    open dynamic var OurTransDate : Date?
    
    open dynamic var PartnerBank : String?
    open dynamic var PartnerAcc : String?
    
    open dynamic var EmbededTransferUser : String?
    open dynamic var EmbededPayCard : String?
    open dynamic var EmbededVerifyCode : String?
    
    open dynamic var IsVerified : Bool = false
    open dynamic var IsSucceed : Bool = false
    
    open dynamic var PaymentCash : Double = 0
    open dynamic var PaidDate : Date?
    open dynamic var IsPaid : Bool = false
    
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
        OurAccOwner    <- map["OurAccOwner"]
        OurCardNo    <- map["OurCardNo"]
        OurCardExpireDate    <- (map["OurCardExpireDate"], MongoDateTransform())
        OurTransNo    <- map["OurTransNo"]
        OurTransDesc    <- map["OurTransDesc"]
        OurTransDate    <- (map["OurTransDate"], MongoDateTransform())
        
        PartnerBank    <- map["PartnerBank"]
        PartnerAcc    <- map["PartnerAcc"]
        
        EmbededTransferUser    <- map["EmbededTransferUser"]
        EmbededPayCard    <- map["EmbededPayCard"]
        EmbededVerifyCode    <- map["EmbededVerifyCode"]
        
        IsVerified    <- map["IsVerified"]
        IsSucceed    <- map["IsSucceed"]
        
        PaymentCash    <- map["PaymentCash"]
        PaidDate    <- (map["PaidDate"], MongoDateTransform())
        IsPaid    <- map["IsPaid"]
        
    }
    
}

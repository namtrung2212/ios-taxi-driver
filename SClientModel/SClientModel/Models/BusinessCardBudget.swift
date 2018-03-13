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

open class BusinessCardBudget: BaseModel {
    
    open dynamic var Card : String?
    open dynamic var CardNo : String?
    open dynamic var Account : String?
    open dynamic var AccountNo : String?
    open dynamic var AccountOwner : String?
    open dynamic var BusinessName : String?
    open dynamic var Currency : String?
    
    open dynamic var AssignedUser : String?
    open dynamic var IsOverBudget :  Bool = false
    open dynamic var PayableAmount : Double = 0
    
    open dynamic var WeeklyBudget : Double = 0
    open dynamic var MonthlyBudget : Double = 0
    open dynamic var QuarterlyBudget : Double = 0
    open dynamic var YearlyBudget : Double = 0
    
    open dynamic var CurrentWeekFrom : Date?
    open dynamic var CurrentWeekTo : Date?
    open dynamic var CurrentMonth : Double = 0
    open dynamic var CurrentQuarter : Double = 0
    open dynamic var CurrentYear : Double = 0
    
    open dynamic var PaidCurrentWeek : Double = 0
    open dynamic var PaidCurrentMonth : Double = 0
    open dynamic var PaidCurrentQuarter : Double = 0
    open dynamic var PaidCurrentYear : Double = 0
    
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
    
    required convenience public init?(_ map: Map) {
        self.init()
    }
    
    open override func mapping(_ map: Map) {
        
        super.mapping(map);
        
        Card <- map["Card"]
        CardNo <- map["CardNo"]
        Account <- map["Account"]
        AccountNo <- map["AccountNo"]
        AccountOwner <- map["AccountOwner"]
        BusinessName <- map["BusinessName"]
        Currency    <- map["Currency"]

        AssignedUser    <- map["AssignedUser"]
        IsOverBudget    <- map["IsOverBudget"]
        PayableAmount    <- map["PayableAmount"]
        
        WeeklyBudget    <- map["WeeklyBudget"]
        MonthlyBudget    <- map["MonthlyBudget"]
        QuarterlyBudget    <- map["QuarterlyBudget"]
        YearlyBudget    <- map["YearlyBudget"]
        
        CurrentWeekFrom    <- (map["CurrentWeekFrom"], MongoDateTransform())
        CurrentWeekTo    <- (map["CurrentWeekTo"], MongoDateTransform())
        CurrentMonth    <- map["CurrentMonth"]
        CurrentQuarter    <- map["CurrentQuarter"]
        CurrentYear    <- map["CurrentYear"]
        
        PaidCurrentWeek    <- map["PaidCurrentWeek"]
        PaidCurrentMonth    <- map["PaidCurrentMonth"]
        PaidCurrentQuarter    <- map["PaidCurrentQuarter"]
        PaidCurrentYear    <- map["PaidCurrentYear"]
        
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
        
    }
    
}

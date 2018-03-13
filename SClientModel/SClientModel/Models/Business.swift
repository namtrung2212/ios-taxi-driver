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

open class Business: BaseModel {
    
    open dynamic var CorpName : String?
    open dynamic var CorpAddress : String?
    open dynamic var CorpCountry : String?
    open dynamic var CorpProvince : String?
    open dynamic var CorpHotline : String?
    open dynamic var CorpHRHotline : String?
    open dynamic var CorpHRContact : String?
    open dynamic var CorpFIHotline : String?
    open dynamic var CorpFIContact : String?
    open dynamic var CorpEmailAddr : String?
    open dynamic var CorpHREmailAddr : String?
    open dynamic var CorpFIEmailAddr : String?
    open dynamic var CorpTaxNo : String?
    
    
    open dynamic var PersonName : String?
    open dynamic var PersonBirthday : String?
    open dynamic var PersonCitizenID : String?
    open dynamic var PersonCitizenIDDate : Date?
    open dynamic var PersonCountry : String?
    open dynamic var PersonProvince : String?
    open dynamic var PersonGender : String?
    open dynamic var PersonPhoneNo : String?
    open dynamic var PersonEmailAddr : String?
    open dynamic var PersonTaxNo : String?
    
    open dynamic var Represent : String?

    
    required convenience public init?(_ map: Map) {
        self.init()
    }
    
    open override func mapping(_ map: Map) {
        
        super.mapping(map);
        
        CorpName <- map["CorpName"]
        CorpAddress    <- map["CorpAddress"]
        CorpCountry    <- map["CorpCountry"]
        CorpProvince    <- map["CorpProvince"]
        CorpHotline    <- map["CorpHotline"]
        CorpHRHotline    <- map["CorpHRHotline"]
        CorpHRContact    <- map["CorpHRContact"]
        CorpFIHotline    <- map["CorpFIHotline"]
        CorpFIContact    <- map["CorpFIContact"]
        CorpEmailAddr    <- map["CorpEmailAddr"]
        CorpHREmailAddr    <- map["CorpHREmailAddr"]
        CorpFIEmailAddr    <- map["CorpFIEmailAddr"]
        CorpTaxNo    <- map["CorpTaxNo"]
        
        PersonName    <- map["PersonName"]
        PersonBirthday    <- map["PersonBirthday"]
        PersonCitizenID    <- map["PersonCitizenID"]
        PersonCitizenIDDate    <- (map["PersonCitizenIDDate"], MongoDateTransform())
        PersonCountry    <- map["PersonCountry"]
        PersonProvince    <- map["PersonProvince"]
        PersonGender    <- map["PersonGender"]
        PersonPhoneNo    <- map["PersonPhoneNo"]
        PersonEmailAddr    <- map["PersonEmailAddr"]
        PersonTaxNo    <- map["PersonTaxNo"]
        
        Represent    <- map["Represent"]
        
    }
    
}

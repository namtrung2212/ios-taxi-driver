//
//  MongoDateTransform.swift
//  BOOKTAXI
//
//  Created by Trung Dao on 4/8/16.
//  Copyright © 2016 SCONNECTING. All rights reserved.
//


import Foundation
import ObjectMapper

open class MongoDateTransform: DateFormatterTransform {
    
    public init() {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        super.init(dateFormatter: formatter)
    }
    
    open static func stringFromDate(_ date :Date) -> String{
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        return formatter.string(from: date)
        
        
    }
    open static func stringRealmFromDate(_ date :Date) -> String{
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        return formatter.string(from: date)
        
    }

    
}

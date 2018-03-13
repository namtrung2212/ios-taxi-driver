//
//  RegionalHelper.swift
//  SClientData
//
//  Created by Trung Dao on 5/20/16.
//  Copyright © 2016 SCONNECTING. All rights reserved.
//

import Foundation



open class RegionalHelper{
    
    
    open static func getCountryNameFromCode(_ code: String) -> String{
        
        return (Locale.system as NSLocale).displayName(forKey: NSLocale.Key.countryCode, value: code)!
        
    }
    
    open static func getCountryCodeFromName(_ name: String) -> String?{
        
        let current = Locale(identifier: "VN")
        
        for code in Locale.isoRegionCodes {
            
            let countryName = (current as NSLocale).displayName(forKey: NSLocale.Key.countryCode, value: code)!
            if( countryName == name){
                return code
            }
        }
        
        return nil
    }
    
    open static func getLocaleIdentifier(_ currency: String?, country: String?) -> String?{
        if((country != nil && country! == "VN") || ( currency != nil && currency! == "VND")){
            return "vi_VN"
        }
        return nil
    }
    
    open static func getCurrencySymbol(_ currency: String?, country: String?) -> String?{
        
        if(currency == "VND" || country == "VN" ){
            return "đ"
        }
        
        return nil
    }
    
    
    
    
    
}

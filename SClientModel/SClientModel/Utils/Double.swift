//
//  Double.swift
//  SClientModel
//
//  Created by Trung Dao on 6/7/16.
//  Copyright © 2016 SCONNECTING. All rights reserved.
//

import Foundation


public extension Double{
    
    
    
    public  func toCurrency(_ currency: String?, country: String?) -> String?{
        
        if(currency == "VND" || country == "VN" ){
            let formatter = NumberFormatter()
            
            formatter.numberStyle = .currency
            
            formatter.locale = Locale(identifier: RegionalHelper.getLocaleIdentifier(currency,country: country)!)
            formatter.decimalSeparator = ","
            formatter.usesGroupingSeparator = true
            formatter.groupingSeparator = "."
            formatter.currencySymbol = RegionalHelper.getCurrencySymbol(currency, country: country)
            
            let newValue: Double = Double( roundf(Float(self) / 1000) * 1000)
            return formatter.string(from: NSNumber(newValue))
        }
        
        return nil
    }

    
    public  func toString(_ country: String, digitNo: Int) -> String?{
        
        if(country == "VN"){
            
            let formatter = NumberFormatter()
            
            formatter.numberStyle = .decimal
            formatter.locale = Locale(identifier: RegionalHelper.getLocaleIdentifier(nil,country: country)!)
            formatter.maximumFractionDigits = digitNo
            formatter.decimalSeparator = ","
            formatter.usesGroupingSeparator = true
            formatter.groupingSeparator = "."
            
            return formatter.string(from: NSNumber(self))
        }
        
        return nil
    }
    

}

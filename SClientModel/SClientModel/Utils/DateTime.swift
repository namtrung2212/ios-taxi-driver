//
//  DateTimeUtil.swift
//  User.iPhone
//
//  Created by Trung Dao on 5/27/16.
//  Copyright © 2016 SCONNECTING. All rights reserved.
//

import Foundation


public extension Date{
    
    public func year() -> NSInteger{
        
        let calendar = Calendar.current
        let components = (calendar as NSCalendar).components([.year], from: self)
        return components.year!
        
    }
    
    public func month() -> NSInteger{
        
        let calendar = Calendar.current
        let components = (calendar as NSCalendar).components([ .month], from: self)
        return components.month!
        
    }
    
    public func day() -> NSInteger{
        
        let calendar = Calendar.current
        let components = (calendar as NSCalendar).components([.day], from: self)
        return components.day!
        
    }
    
    public func hour() -> NSInteger{
        
        let calendar = Calendar.current
        let components = (calendar as NSCalendar).components([.hour], from: self)
        return components.hour!
        
    }
    
    public func minute() -> NSInteger{
        
        let calendar = Calendar.current
        let components = (calendar as NSCalendar).components([.minute], from: self)
        return components.minute!
        
    }
    
    public func second() -> NSInteger{
        
        let calendar = Calendar.current
        let components = (calendar as NSCalendar).components([.second], from: self)
        return components.second!
        
    }
    
    public func isToday() -> Bool{
        
        return(year() == Date().year() && month() == Date().month() && day() == Date().day() )
        
    }
    public func isCurrentYear() -> Bool{
        
        return(year() == Date().year())
        
    }
    
    
    public func isCurrentMonth() -> Bool{
        
        return(year() == Date().year() && month() == Date().month())
        
    }
    
    
    public func isYesterday() -> Bool{
        return self.addingTimeInterval(60*60*24).isToday()
    }
    
    
    
    public func isExpired(_ extraMinutes: NSInteger) -> Bool{
        
        let elapsedTime = self.timeIntervalSince(Date())
        
        return elapsedTime < 0 && abs(elapsedTime) >= Double(extraMinutes*60 )
        
    }
    
    public func isSince(_ extraMinutes: NSInteger) -> Bool{
        
        let elapsedTime = self.timeIntervalSince(Date())
        
        return  elapsedTime < Double(extraMinutes*60 )
        
    }

    
    public func isNow(_ extraMinutes: NSInteger) -> Bool{
        
        let elapsedTime = self.timeIntervalSince(Date())
        
        return (elapsedTime > 0 ||   abs(elapsedTime) <= Double(3*60))
            && abs(elapsedTime) <= Double(extraMinutes*60 )
        
    }

    
    public func toString(_ format: String) -> String{
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.locale  = Locale(identifier: "vi_VN")
        return dateFormatter.string(from: self)
    }
    
    
    func toVietnamese()-> String{
        
        var strPickupTime = ""
        if(self.isNow(5)){
            
            strPickupTime = "ngay bây giờ"
            
        }else{
            
            let seconds = self.timeIntervalSince(Date())
            
            if ((seconds > 0) || abs(seconds)<=60){
                
                let hours =  Int(seconds / 3600)
                let minutes =  Int(round((seconds.truncatingRemainder(dividingBy: 3600)) / 60))
                
                if( hours >= 1){
                    strPickupTime =  NSString(format:"sau %d giờ, %d phút", hours, minutes ) as String
                }else{
                    strPickupTime =  NSString(format:"sau %d phút", minutes ) as String
                }
                
            }else {
                
                let strDate = self.toString("HH:mm")
                
                if(self.isToday()){self
                    strPickupTime = strDate + " hôm nay"
                    
                }else{
                    let strDate2 = self.toString("dd/MM")
                    strPickupTime = strDate + " ngày " + strDate2
                }
                
            }
        }
        
      return strPickupTime
    }

}


//
//  Driver.swift
//  BOOKTAXI
//
//  Created by Trung Dao on 4/7/16.
//  Copyright © 2016 SCONNECTING. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper

import CoreLocation

open class TravelOrder: BaseModel {
    
    open dynamic var User : String?
    open dynamic var UserName : String?
    
    open dynamic var OrderLoc : LocationObject?
    open dynamic var Device : String?
    open dynamic var DeviceID : String?
    
    open dynamic var Status : String = OrderStatus.Open
    open dynamic var Currency : String = "VND"
    
    open dynamic var OrderPickupLoc : LocationObject?
    open dynamic var OrderPickupPlace : String?
    open dynamic var OrderPickupCountry : String?
    open dynamic var OrderPickupTime : Date?
    open dynamic var OrderDropLoc : LocationObject?
    open dynamic var OrderDropPlace : String?
    open dynamic var OrderDuration :  Double = 0
    open dynamic var OrderDistance :  Double = 0
    open dynamic var OrderPrice :  Double = 0
    open dynamic var OrderSeater : Int = 0
    open dynamic var OrderOneway : Bool = true
    open dynamic var OrderQuality : String = "Popular"
    open dynamic var OrderDropRestrict : Bool = false
    
    open dynamic var ActPickupLoc : LocationObject?
    open dynamic var ActPickupPlace : String?
    open dynamic var ActPickupCountry : String?
    open dynamic var ActPickupTime : Date?
    open dynamic var ActDropLoc : LocationObject?
    open dynamic var ActDropPlace : String?
    open dynamic var ActDropTime : Date?
    open dynamic var ActDistance :  Double = 0
    open dynamic var ActPrice :  Double = 0
    
    open dynamic var PayMethod : String?
    open dynamic var PayCurrency : String?
    open dynamic var PayAmount :  Double = 0
    open dynamic var BusinessCard : String?
    open dynamic var UserPayCard : String?
    open dynamic var PayTransNo : String?
    open dynamic var PayTransDate : Date?
    open dynamic var PayVerifyCode : String?
    open dynamic var IsVerified : Bool = false
    open dynamic var IsPayTransSucceed : Bool = false

    open dynamic var IsPaid : Bool = false
    open dynamic var IsPaidReconcile : Bool = false
    
    open dynamic var WorkingPlan : String?
    open dynamic var Driver : String?
    open dynamic var DriverName : String?
    open dynamic var CitizenID : String?
    
    open dynamic var Company : String?
    open dynamic var CompanyName : String?
    open dynamic var Team : String?
    open dynamic var TeamName : String?
    
    open dynamic var Car : String?
    open dynamic var CarNo : String?
    open dynamic var CarBrand : String?
    open dynamic var CarProvince : String?

    open dynamic var  Rating : Int = 0
    open dynamic var Comment : String?
    
    required convenience public init?(_ map: Map) {
        self.init()
    }
    
    open override func mapping(_ map: Map) {
        
        super.mapping(map);
        
        User    <- map["User"]
        UserName    <- map["UserName"]
        OrderLoc    <- (map["OrderLoc"],LocationTransform())
        Device    <- map["Device"]
        DeviceID    <- map["DeviceID"]
        
        Status <- map["Status"]
        Currency <- map["Currency"]


        OrderPickupLoc    <- (map["OrderPickupLoc"],LocationTransform())
        OrderPickupPlace <- map["OrderPickupPlace"]
        OrderPickupCountry <- map["OrderPickupCountry"]
        OrderPickupTime <- (map["OrderPickupTime"], MongoDateTransform())
        OrderDropLoc    <- (map["OrderDropLoc"],LocationTransform())
        OrderDropPlace <- map["OrderDropPlace"]
        OrderDuration <- map["OrderDuration"]
        OrderDistance <- map["OrderDistance"]
        OrderPrice <- map["OrderPrice"]
        OrderSeater <- map["OrderSeater"]
        OrderOneway <- map["OrderOneway"]
        OrderQuality <- map["OrderQuality"]
        OrderDropRestrict <- map["OrderDropRestrict"]
        
        ActPickupLoc    <- (map["ActPickupLoc"],LocationTransform())
        ActPickupPlace <- map["ActPickupPlace"]
        ActPickupCountry <- map["ActPickupCountry"]
        ActPickupTime <- (map["ActPickupTime"], MongoDateTransform())
        ActDropLoc    <- (map["ActDropLoc"],LocationTransform())
        ActDropPlace <- map["ActDropPlace"]
        ActDropTime <- (map["ActDropTime"], MongoDateTransform())
        ActDistance <- map["ActDistance"]
        ActPrice <- map["ActPrice"]
               
        PayMethod <- map["PayMethod"]
        PayCurrency <- map["PayCurrency"]
        PayAmount <- map["PayAmount"]
        BusinessCard <- map["BusinessCard"]
        UserPayCard <- map["UserPayCard"]
        PayTransNo <- map["PayTransNo"]
        PayTransDate <- (map["PayTransDate"], MongoDateTransform())
        PayVerifyCode <- map["PayVerifyCode"]
        IsVerified <- map["IsVerified"]
        IsPayTransSucceed <- map["IsPayTransSucceed"]

        IsPaid <- map["IsPaid"]
        IsPaidReconcile <- map["IsPaidReconcile"]
        
        WorkingPlan <- map["WorkingPlan"]
        
        Driver    <- map["Driver"]
        DriverName    <- map["DriverName"]
        CitizenID    <- map["CitizenID"]
        
        Company <- map["Company"]
        CompanyName <- map["CompanyName"]
        Team <- map["Team"]
        TeamName <- map["TeamName"]
        
        Car    <- map["Car"]
        CarNo    <- map["CarBrand"]
        CarProvince    <- map["CarProvince"]
        CarBrand    <- map["CarBrand"]
        
        Rating <- map["Rating"]
        Comment <- map["Comment"]
    }
    
    
   open func resetToOpen(){
    
        self.Status = OrderStatus.Open
        self.WorkingPlan = nil
        self.Driver = nil
        self.DriverName = nil
        self.CitizenID = nil
        self.Company = nil
        self.CompanyName = nil
        self.Team = nil
        self.TeamName = nil
        self.Car = nil
        self.CarNo = nil
        self.CarProvince = nil
        self.CarBrand = nil
    }

    open func IsPickupNow() -> Bool{
        return (self.OrderPickupTime == nil) || (self.OrderPickupTime!.isNow(10))
    }
    
    
    open func IsPickupFuture() -> Bool{
        return (self.OrderPickupTime != nil) && (self.OrderPickupTime!.timeIntervalSince(Date()) > 60*1)
    }
    

    
    
    open func IsNewOrder() -> Bool{
        return self.id == nil
    }
    
    
    open func IsChoosingLocation() -> Bool{
        return self.IsNewOrder() &&  ( self.OrderDropLoc == nil ||  self.OrderPickupLoc == nil)
    }
    
    open func IsChoosingPickupLocation() -> Bool{
        return self.IsNewOrder() &&  self.OrderPickupLoc == nil
    }
    
    
    open func IsChoosingDropLocation() -> Bool{
        return self.IsNewOrder() &&  (self.OrderDropLoc == nil && self.OrderPickupLoc != nil)
    }
    

    
    
    open func IsNotYetChooseDriver() -> Bool{
        return (self.Status == OrderStatus.Open || self.Status == OrderStatus.BiddingAccepted || self.Status == OrderStatus.Requested || self.Status == OrderStatus.DriverRejected  )
    }
    
    open func IsExpired() -> Bool{
        return self.IsNotYetChooseDriver() && self.OrderPickupTime != nil && self.OrderPickupTime!.isExpired(2)
    }

    
    open func IsDriverRequested() -> Bool{
        return (self.Status == OrderStatus.Requested || self.Status == OrderStatus.BiddingAccepted )
    }

    open func IsDriverRejected() -> Bool{
        return (self.Status == OrderStatus.DriverRejected  )
    }
    
    
    open func IsWaitingForDriver() -> Bool{
        return (self.Driver != nil) && (self.Status == OrderStatus.DriverAccepted )
    }

    
    open func IsMonitoring() -> Bool{
        return (self.Driver != nil) && (self.Status == OrderStatus.DriverAccepted ||  self.Status == OrderStatus.TripStarted )
    }
    
    open func IsStopped() -> Bool{
        return (self.Driver != nil) &&
                    (self.Status == OrderStatus.VoidedBfPickupByUser
                ||  self.Status == OrderStatus.VoidedBfPickupByDriver
                ||  self.Status == OrderStatus.VoidedAfPickupByUser
                ||  self.Status == OrderStatus.VoidedAfPickupByDriver
                ||  self.Status == OrderStatus.Finished)
    }
    
    open func IsVoided() -> Bool{
        return (self.Driver != nil) &&
            (self.Status == OrderStatus.VoidedBfPickupByUser
                ||  self.Status == OrderStatus.VoidedBfPickupByDriver
                ||  self.Status == OrderStatus.VoidedAfPickupByUser
                ||  self.Status == OrderStatus.VoidedAfPickupByDriver )
    }
    
    
    
    open func IsVoidedByUser() -> Bool{
        return (self.Driver != nil) &&  (self.Status == OrderStatus.VoidedBfPickupByUser || self.Status == OrderStatus.VoidedAfPickupByUser)
    }
    
    
    open func IsVoidedByDriver() -> Bool{
        return (self.Driver != nil) &&  (self.Status == OrderStatus.VoidedBfPickupByDriver || self.Status == OrderStatus.VoidedAfPickupByDriver)
    }


    open func IsOnTheWay() -> Bool{
        return (self.Driver != nil) &&  (self.Status == OrderStatus.TripStarted)
    }
    
    open func IsFinishedNotYetPaid() -> Bool{
        return (self.Driver != nil) &&  (self.Status == OrderStatus.Finished || self.Status == OrderStatus.VoidedAfPickupByUser || self.Status == OrderStatus.VoidedAfPickupByDriver ) && self.IsPaid == false
    }
    
    open func IsFinishedAndPaid() -> Bool{
        return (self.Driver != nil) &&  (self.Status == OrderStatus.Finished || self.Status == OrderStatus.VoidedAfPickupByUser || self.Status == OrderStatus.VoidedAfPickupByDriver ) && self.IsPaid == true
        
    }



    
    open func  initRoadPath(_ distance: Double, duration: Double){
        
        self.OrderDistance = distance
        self.OrderDuration = duration
        
    }
    
    
    open func  initOrderPickupLoc(_ target: CLLocationCoordinate2D){
        
        self.OrderPickupLoc = LocationObject(latitude: target.latitude, longitude: target.longitude)
        
    }
    
    open func  initOrderPickupLoc(_ latitude: Double, longitude: Double){
        
        self.OrderPickupLoc = LocationObject(latitude: latitude, longitude: longitude)
        
    }
    
    open func  initActPickupLoc(_ target: CLLocationCoordinate2D){
        
        self.ActPickupLoc = LocationObject(latitude: target.latitude, longitude: target.longitude)
        
    }
    

    open func  initOrderDropLoc(_ target:CLLocationCoordinate2D){
        
        self.OrderDropLoc = LocationObject(latitude: target.latitude, longitude: target.longitude)
        
    }
    
    open func  initActDropLoc(_ target: CLLocationCoordinate2D){
        
        self.ActDropLoc = LocationObject(latitude: target.latitude, longitude: target.longitude)
        
    }

    open func  initOrderDropLoc(_ latitude: Double, longitude: Double){
        
        self.OrderDropLoc = LocationObject(latitude: latitude, longitude: longitude)
        
    }
    
    open func  initOrderPickupPlace(_ address:String?, country: String?){
        self.OrderPickupPlace = address
        self.OrderPickupCountry = country
    }
    
    open func  initOrderDropPlace(_ target:String?){
        self.OrderDropPlace = target
    }
    
    open func  clearOrderPickupLoc(){
        
        self.OrderPickupLoc = nil
        self.OrderDistance = 0
        self.OrderDuration = 0
    }
    
    open func  clearOrderDropLoc(){
        self.OrderDropLoc = nil
        self.OrderDistance = 0
        self.OrderDuration = 0
    }
    
    
    
   open func getPickupTimeString() -> String{
        
        var date : Date?
        if(self.ActPickupTime != nil){
            
            date = self.ActPickupTime
            
        }else if(self.OrderPickupTime != nil){
            
            date = self.OrderPickupTime
            
        }else{
            
            date = self.createdAt as Date?
            
        }
        
        if(date == nil){
                return ""
        }else{
                return  date!.toVietnamese()
        }
    
        
    }

    
}

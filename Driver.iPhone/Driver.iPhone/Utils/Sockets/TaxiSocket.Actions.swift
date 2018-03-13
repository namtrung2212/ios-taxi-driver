//
//  TaxiSocket.Actions.swift
//  Driver.iPhone
//
//  Created by Trung Dao on 6/19/16.
//  Copyright © 2016 SCONNECTING. All rights reserved.
//

import UIKit
import Foundation
import ObjectMapper
import AlamofireObjectMapper
import SClientData
import SClientModel
import CoreLocation
import RealmSwift
import GoogleMaps
import  SocketIOClientSwift

extension TaxiSocket{
    
    
    
    public func loggin(){
        socket.emit("DriverLogin", ["DriverID": SCONNECTING.DriverManager!.CurrentDriver!.id!])
    }
    
    
    
    
    public func resetCar(){
        
        if(SCONNECTING.DriverManager!.CurrentDriverStatus!.Car != nil){
        
            socket.emit("DriverResetCar", ["DriverID": SCONNECTING.DriverManager!.CurrentDriver!.id! , "CarID" : SCONNECTING.DriverManager!.CurrentDriverStatus!.Car!])
        
        }else{

            if(SCONNECTING.DriverManager!.CurrentWorkingPlan != nil && SCONNECTING.DriverManager!.CurrentWorkingPlan!.Car != nil){
                
                socket.emit("DriverResetCar", ["DriverID": SCONNECTING.DriverManager!.CurrentDriver!.id! , "CarID" : SCONNECTING.DriverManager!.CurrentWorkingPlan!.Car!])
            }
        }
    }

    
    public func bidding(_ bidding: DriverBidding, message: String?){
        
        socket.emit("DriverBidding", ["DriverID": SCONNECTING.DriverManager!.CurrentDriver!.id! , "UserID" : bidding.User! , "OrderID" : bidding.TravelOrder!,"Message" : message != nil ? message! : ""])
        
    }

    public func acceptRequest(_ order: TravelOrder){
        
        socket.emit("DriverAccepted", ["DriverID": SCONNECTING.DriverManager!.CurrentDriver!.id! , "UserID" : order.User! , "OrderID" : order.id!])
        
    }
    
    public func rejectRequest(_ order: TravelOrder){
        
        socket.emit("DriverRejected", ["DriverID": SCONNECTING.DriverManager!.CurrentDriver!.id! , "UserID" : order.User! , "OrderID" : order.id!])
        
    }
    
    
    
    public func updateLocation(_ order: TravelOrder,location: CLLocation, distance: Double){
        
        socket.emit("CarUpdateLocation", ["CarID": SCONNECTING.DriverManager!.CurrentDriverStatus!.Car! , "DriverID": SCONNECTING.DriverManager!.CurrentDriver!.id! , "UserID" : order.User! , "OrderID" : order.id! , "latitude" : location.coordinate.latitude , "longitude" : location.coordinate.longitude , "degree" : location.course, "distance" : distance ])
        
    }

    
    
    public func voidBeforePickup(_ order: TravelOrder){
        
        socket.emit("DriverVoidedBfPickup", ["DriverID": SCONNECTING.DriverManager!.CurrentDriver!.id! , "UserID" : order.User! , "OrderID" : order.id!])
        
    }
    
    
    public func startTrip(_ order: TravelOrder){
        
        socket.emit("DriverStartedTrip", ["DriverID": SCONNECTING.DriverManager!.CurrentDriver!.id! , "UserID" : order.User! , "OrderID" : order.id!])
        
    }
    
    
    public func voidAfterPickup(_ order: TravelOrder){
        
        socket.emit("DriverVoidedAfPickup", ["DriverID": SCONNECTING.DriverManager!.CurrentDriver!.id! , "UserID" : order.User! , "OrderID" : order.id!])
        
    }
    
    public func finishTrip(_ order: TravelOrder){
        
        socket.emit("DriverFinished", ["DriverID": SCONNECTING.DriverManager!.CurrentDriver!.id! , "UserID" : order.User! , "OrderID" : order.id!])
        
    }
    
    public func cashPaid(_ order: TravelOrder){
        
        socket.emit("DriverCashPaid", ["DriverID": SCONNECTING.DriverManager!.CurrentDriver!.id! , "UserID" : order.User! , "OrderID" : order.id!])
        
    }

        

}

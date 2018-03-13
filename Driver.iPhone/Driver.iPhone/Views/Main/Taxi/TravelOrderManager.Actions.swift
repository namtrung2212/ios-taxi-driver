//
//  BOOKTAXIswift
//  BOOKTAXI
//
//  Created by Trung Dao on 4/13/16.
//  Copyright © 2016 SCONNECTING. All rights reserved.
//

import UIKit
import Foundation
import ObjectMapper
import AlamofireObjectMapper
import SClientData
import SClientModel
import SClientModelControllers

import CoreLocation
import RealmSwift
import GoogleMaps
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


extension TravelOrderManager{
    
    
    
    public func getOpenningOrder(_ completion:(( _ item: TravelOrder?) -> ())?){
        
        if(SCONNECTING.DriverManager!.CurrentDriver != nil){
            
            TravelOrderController.GetLastOpenningOrderByDriver((SCONNECTING.DriverManager!.CurrentDriver?.id)!) { (order) in
                completion?(item: order)
            }
            
        }else{
            completion?(item: nil)
        }
        
    }
    
    public func bidding(_ order: TravelOrder,message: String?,expireMinutes: Double?,completion:(( _ item: DriverBidding?) -> ())?){
        
        let expireTime: Date? = (expireMinutes != nil) ?  Date().addingTimeInterval(expireMinutes! * 60) : nil
        
        self.bidding(order, message: message, expireTime: expireTime) { (item) in
            completion?(item: item)
        }

    }
    
    
    
    public func getBidding(_ order: TravelOrder,completion:(( _ item: DriverBidding?) -> ())?){
        
        let driverId = SCONNECTING.DriverManager?.CurrentDriver!.id!
        
        ModelController<DriverBidding>.queryServer("BiddingByOrderAndDriver", filter: "Driver=\(driverId!)&TravelOrder=\(order.id!)") { (items) in
   
            if(items?.count > 0){
                completion?(item: items![0])
            }else{
                completion?(item:nil)
            }
        }
        
    }
    

    public func bidding(_ order: TravelOrder,message: String?,expireTime: Date?,completion:(( _ item: DriverBidding?) -> ())?){
        
        let driverId = SCONNECTING.DriverManager?.CurrentDriver!.id!
        ModelController<DriverStatus>.getOneByField("Driver", value: driverId!, isGetNow: true, clientHandler: nil) { (item) in
           
            if(item != nil){
                
                    let bidding : DriverBidding = DriverBidding()
                    bidding.Driver = item!.Driver
                    bidding.WorkingPlan = item!.WorkingPlan
                    bidding.Company = item!.Company
                    bidding.Team = item!.Team
                    bidding.TravelOrder = order.id
                    bidding.User = order.User
                    bidding.ExpireTime = (expireTime != nil) ?  expireTime! : nil
                    bidding.Message = (message != nil) ? message : nil
                    bidding.Status = "Open"
                
                    ModelController<DriverBidding>.create(bidding, completion: { (success, newitem) in
                        if(newitem != nil){
                            SCONNECTING.NotificationManager!.taxiSocket.bidding(newitem!, message: message)
                        }
                        completion?(item: newitem)
                    })

            }else{
                
                completion?(item: nil)
            }
        }
        
    }
    
    public func voidBidding(_ order: TravelOrder,completion: ((_ deleted: Int)->Void)?){
        
        let driverId = SCONNECTING.DriverManager?.CurrentDriver!.id!
        
        ModelController<DriverBidding>.deleteByFields(["Driver" : driverId! , "TravelOrder" : order.id]) { (deleted) in
             completion?(deleted: deleted)
        }
        
    }

    
    public func acceptRequest(_ order: TravelOrder,completion:(( _ item: TravelOrder?) -> ())?){
        
        if(order.Driver == SCONNECTING.DriverManager?.CurrentDriver!.id!){
            
            order.Driver = SCONNECTING.DriverManager?.CurrentDriver!.id!
            order.Status = OrderStatus.DriverAccepted
            
            if(order.OrderDistance > 0 && order.OrderDropLoc != nil){
                        TravelOrderController.CalculateOrderPrice((SCONNECTING.DriverManager?.CurrentDriver!.id)!, distance: order.OrderDistance , currency: order.Currency, serverHandler: { (price) in
                           
                            if(price != nil){
                                order.OrderPrice = price!
                            }
                            
                            ModelController<TravelOrder>.update(order, completion: { (success, newitem) in
                                if(newitem != nil){
                                    SCONNECTING.NotificationManager!.taxiSocket.acceptRequest(newitem!)
                                }
                                completion?(item: newitem)
                            })
                            
                        })
            
            
            }else{
                
                        ModelController<TravelOrder>.update(order, completion: { (success, newitem) in
                            if(newitem != nil){
                                SCONNECTING.NotificationManager!.taxiSocket.acceptRequest(newitem!)
                            }
                            completion?(item: newitem)
                        })

            }
            

        }else{
              completion?(item: order)
        }
        
    }
    
    public func rejectRequest(_ order: TravelOrder,completion:(( _ item: TravelOrder?) -> ())?){
        
        if(order.Driver == SCONNECTING.DriverManager?.CurrentDriver!.id){
            
            order.Driver = SCONNECTING.DriverManager?.CurrentDriver!.id
            order.Status = OrderStatus.DriverRejected
            
            ModelController<TravelOrder>.update(order, completion: { (success, newitem) in
                if(newitem != nil){
                    SCONNECTING.NotificationManager!.taxiSocket.rejectRequest(newitem!)
                }
                completion?(item: newitem)
            })
            
        }else{
            completion?(item: order)
        }
        
    }
    
    public func nofifyLocationToUser(_ order: TravelOrder?,location: CLLocation){
        
        if(order != nil && order!.Driver == SCONNECTING.DriverManager?.CurrentDriver!.id! && order!.User != nil && order!.IsMonitoring()){
            
            SCONNECTING.NotificationManager!.taxiSocket.updateLocation(order!, location: location,distance: self.travelDistanceFromBaseLocation())
            
        }
        
    }
    

    
    
    public func voidTrip(_ orderToVoid: TravelOrder,completion:(( _ item: TravelOrder?) -> ())?){
        
        if(orderToVoid.id == nil){
            completion?(item: orderToVoid)
            return
        }
        
        ModelController<TravelOrder>.queryServerById(orderToVoid.id!) { (order) in
            
                if order!.IsWaitingForDriver(){
                    
                    order!.Status = OrderStatus.VoidedBfPickupByDriver
                    
                        ModelController<TravelOrder>.update(order!, completion: { (success, newitem) in
                                if(newitem != nil){
                                        SCONNECTING.NotificationManager!.taxiSocket.voidBeforePickup(newitem!)
                            }
                            self.locationsPoints.removeAll()
                                completion?(item: newitem)
                        })

                }else if order!.IsOnTheWay() || order!.Status == OrderStatus.VoidedAfPickupByUser{
                    
                    if(order!.Status != OrderStatus.VoidedAfPickupByUser){
                        order!.Status = OrderStatus.VoidedAfPickupByDriver
                    }
                    
                    self.voidAfterPickup(order!, completion: { (newitem) in
                        
                        self.locationsPoints.removeAll()
                        completion?(item: newitem)
                    })

                }
        }
        
    }
    
    func voidAfterPickup(_ order: TravelOrder,completion:(( _ item: TravelOrder?) -> ())?){
        
        order.initActDropLoc(SCLocationManager.currentLocation!.Location!.coordinate)
        order.ActDropTime = Date()
        
        GoogleMapUtil.getDistance(order.ActPickupLoc!.coordinate(), destLocation: SCLocationManager.currentLocation!.Location!.coordinate) { (routes) in
            
            order.ActDistance = 0
            if (routes != nil && routes!.count > 0){
                order.ActDistance = routes![0]["legs"][0]["distance"]["value"].doubleValue
                if(order.ActDistance <= 0){
                    order.ActDistance = 0
                }
                
            }else{
                order.ActDistance = SCONNECTING.TaxiManager!.travelDistanceFromBaseLocation()
            }
            
            TravelOrderController.CalculateOrderPrice(order.Driver! , distance:  order.ActDistance , currency: order.Currency, serverHandler: { (price) in
                
                order.ActPrice = (price != nil && price! > 0) ? price! : 0
                order.ActPrice = Double( roundf(Float(order.ActPrice) / 1000) * 1000)
                if(order.ActPrice <= 0){
                    order.ActPrice = self.travelDistanceFromBaseLocation()
                    self.locationsPoints.removeAll()
                }
                
                GoogleMapUtil.getAddress(SCLocationManager.currentLocation!.Location!.coordinate) { (address, country) in
                    
                    order.ActDropPlace = address
                    
                    ModelController<TravelOrder>.update(order, completion: { (success, newitem) in
                        if(success ){
                            SCONNECTING.NotificationManager!.taxiSocket.voidAfterPickup(order)
                        }
                        completion?(item: newitem)
                    })
                    
                }
            })
            
        }
    }
    
    public func startTrip(_ orderToStart: TravelOrder,completion:(( _ item: TravelOrder?) -> ())?){
        
        if(orderToStart.id == nil || !orderToStart.IsWaitingForDriver()){
            completion?(item: orderToStart)
            return;
        }
        
        locationsPoints.removeAll()
        locationsPoints.append(SCLocationManager.currentLocation!.Location!.coordinate)
        ModelController<TravelOrder>.queryServerById(orderToStart.id!) { (order) in
            
            GoogleMapUtil.getAddress(SCLocationManager.currentLocation!.Location!.coordinate) { (address, country) in
               
                order!.initActPickupLoc(SCLocationManager.currentLocation!.Location!.coordinate)
                order!.ActPickupPlace = address
                order!.ActPickupCountry = country
                order!.ActPickupTime = Date()
                order!.Status =  OrderStatus.TripStarted
                
                ModelController<TravelOrder>.update(order!, completion: { (success, newitem) in
                    if(success && newitem != nil){
                        SCONNECTING.NotificationManager!.taxiSocket.startTrip(order!)
                    }
                    completion?(item: newitem)
                })

            }
        }
        
    }
    
    
    public func finishTrip(_ orderToFinish: TravelOrder, completion:(( _ item: TravelOrder?) -> ())?){
        
        if(orderToFinish.id == nil || orderToFinish.IsOnTheWay() == false){
            completion?(item: orderToFinish)
            return;
        }
        
        ModelController<TravelOrder>.queryServerById(orderToFinish.id!) { (order) in
            
                    order!.initActDropLoc(SCLocationManager.currentLocation!.Location!.coordinate)
                    order!.ActDropTime = Date()
                    order!.Status =  OrderStatus.Finished
                    
                    GoogleMapUtil.getDistance(order!.ActPickupLoc!.coordinate(), destLocation: SCLocationManager.currentLocation!.Location!.coordinate) { (routes) in
                    
                        order!.ActDistance = 0
                        if (routes != nil && routes!.count > 0){
                            order!.ActDistance = routes![0]["legs"][0]["distance"]["value"].doubleValue
                            if(order!.ActDistance <= 0){
                                order!.ActDistance = self.travelDistanceFromBaseLocation()
                                self.locationsPoints.removeAll()
                            }

                        }else{
                            order!.ActDistance = SCONNECTING.TaxiManager!.travelDistanceFromBaseLocation()
                        }
                        
                        TravelOrderController.CalculateOrderPrice(order!.Driver! , distance:  order!.ActDistance , currency: order!.Currency, serverHandler: { (price) in
                            
                                order!.ActPrice = (price != nil && price! > 0) ? price! : 0
                                order!.ActPrice = Double( roundf(Float(order!.ActPrice) / 1000) * 1000)
                                if(order!.ActPrice <= 0){
                                    order!.ActPrice = 0
                                }
                            
                                GoogleMapUtil.getAddress(SCLocationManager.currentLocation!.Location!.coordinate) { (address, country) in
                                    
                                    order!.ActDropPlace = address
                                    
                                    ModelController<TravelOrder>.update(order!, completion: { (success, newitem) in
                                        if(success ){
                                            SCONNECTING.NotificationManager!.taxiSocket.finishTrip(order!)
                                        }
                                        completion?(item: newitem)
                                    })

                                }
                        })
                        
                    }
            
        }        
    }
    
    
    
    public func cashPaid(_ orderToPay: TravelOrder, completion:(( _ item: TravelOrder?) -> ())?){
        
        if(orderToPay.id == nil || orderToPay.IsFinishedNotYetPaid() == false){
            completion?(item: orderToPay)
            return;
        }
        
        ModelController<TravelOrder>.queryServerById(orderToPay.id!) { (order) in
            
                order!.PayMethod = "Cash"
                order!.PayAmount = order!.ActPrice
                order!.PayCurrency = order!.Currency
                order!.PayTransDate = Date()
                order!.IsVerified = true
                order!.IsPayTransSucceed = true
                order!.IsPaid = true
            
                ModelController<TravelOrder>.update(order!, completion: { (success, newitem) in
                    if(success && newitem != nil && newitem!.PayAmount >= 0){
                        SCONNECTING.NotificationManager!.taxiSocket.cashPaid(order!)
                    }
                    completion?(item: newitem)
                })
            
        }
    }

    
    func travelDistanceFromBaseLocation() -> Double{
        
        var preLocation: CLLocationCoordinate2D? = nil
        var distance: Double = 0
        
        self.locationsPoints.forEach { (location) in
            if(preLocation != nil){
                
                let locationSource = CLLocation(latitude: preLocation!.latitude , longitude: preLocation!.longitude)
                let locationDestiny = CLLocation(latitude: location.latitude , longitude: location.longitude)
                distance += (locationSource.distance(from: locationDestiny))
                
            }
            preLocation = location
        }
        
        return distance
    }
    
    
    
    public func chat(_ order: TravelOrder,message: TravelOrderChatting,completion:(() -> ())?){
        
        SCONNECTING.NotificationManager!.chatSocket.chat(order, message: message)
        completion?()
        
    }
    
    

}

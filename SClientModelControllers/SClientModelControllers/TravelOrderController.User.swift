//
//  TravelOrderController.swift
//  SClientModelControllers
//
//  Created by Trung Dao on 4/13/16.
//  Copyright © 2016 SCONNECTING. All rights reserved.
//

import UIKit
import Foundation
import Alamofire
import ObjectMapper
import AlamofireObjectMapper
import SClientData
import SClientModel
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


open class TravelOrderController: ModelController<TravelOrder> {
    
    
    open static func GetOrderBiddings(_ orderId: String, serverHandler: ((_ biddings: [DriverBidding]) -> ())? ) ->Void{
        
                    ModelController<DriverBidding>.queryServer("BiddingByOrder/\(orderId)", filter: nil) { (items) in
                        
                        serverHandler?(biddings: items!)
                        
                    }
    }
    
    
    
    open static func GetLastOpenningOrderByUser(_ userId: String, serverHandler: ((_ order: TravelOrder?) -> ())? ) ->Void{
        
        
                    ModelController<TravelOrder>.queryServerForOne("GetLastOpenningOrderByUser/\(userId)", filter: nil) { (item) in
                        
                        serverHandler?(order: item)
                        
                    }

    }
    
    open static func GetAllOrderByUser(_ userId: String,page: Int?, pagesize: Int?, serverHandler: ((_ orders: [TravelOrder]) -> ())? ) ->Void{
        
        
        var filter :String = "User=\(userId)"
        
        if(page != nil){
            filter = filter + "&page=" + String(page!)
        }
        
        if(pagesize != nil){
            filter = filter + "&pagesize=" + String(pagesize!)
        }
        
        
        ModelController<TravelOrder>.queryServer("selectall", filter: filter) { (items) in
            
            serverHandler?(orders: items!)
        }
        
    }

    
    
    
    
    open static func GetNotYetPaidOrderByUser(_ userId: String, serverHandler: ((_ orders: [TravelOrder]) -> ())? ) ->Void{
        
        
        ModelController<TravelOrder>.queryServer("GetNotYetPaidOrderByUser/\(userId)", filter: nil) { (items) in
            
            serverHandler?(orders: items!)
            
        }
        
    }

    
    open static func GetNotYetPickupOrderByUser(_ userId: String, serverHandler: ((_ orders: [TravelOrder]) -> ())? ) ->Void{
        
        ModelController<TravelOrder>.queryServer("GetNotYetPickupOrderByUser/\(userId)", filter: nil) { (items) in
            
            serverHandler?(orders: items!)
            
        }
        
    }
    
    open static func GetOnTheWayOrderByUser(_ userId: String, serverHandler: ((_ orders: [TravelOrder]) -> ())? ) ->Void{
        
        ModelController<TravelOrder>.queryServer("GetOnTheWayOrderByUser/\(userId)", filter: nil) { (items) in
            
            serverHandler?(orders: items!)
            
        }
        
    }
    
    open static func GetLastChattingMessage(_ orderId: String,completion: ((_ chatting : TravelOrderChatting?) -> ())?) {
        
        let query = "selectall?Order=\(orderId)&sortField=createdAt&sort=-1&pagesize=1&page=1"
        
        DataManager<TravelOrderChatting>.queryServer(query, serverHandler: { (items) in
        
            if(items?.count > 0){
                completion?(chatting : items![0])
            }else{
                completion?(chatting :nil)
            }

            
        })
        
    }
    
    
     open static func CountNotYetViewedMessageByUser(_ orderId: String,completion: ((_ number : Int) -> ())?) {
        
        
        let query = "Order=\(orderId)&IsUser=0&IsViewed=0"
        
        DataManager<TravelOrderChatting>.queryServerForDoubleResponse("count", filter: query) { (count) in
            
            completion?(number : count == nil ? 0 : Int(count!))
        }
    }
    
    open static func CountNotYetViewedMessageByDriver(_ orderId: String,completion: ((_ number : Int) -> ())?) {
        
        let query = "Order=\(orderId)&IsUser=1&IsViewed=0"
        
        DataManager<TravelOrderChatting>.queryServerForDoubleResponse("count", filter: query) { (count) in
            
            completion?(number : count == nil ? 0 : Int(count!))
        }
    }
    

    
    open static  func SetAllMessageToViewedByUser(_ orderId: String,completion: ((_ number : Int) -> ())?) {
        
        DataManager<TravelOrderChatting>.queryServerForDoubleResponse("SetAllMessageToViewedByUser/\(orderId)", filter: nil) { (count) in
            
            completion?(number : count == nil ? 0 : Int(count!))
        }
    }
    
    open static  func SetAllMessageToViewedByDriver(_ orderId: String,completion: ((_ number : Int) -> ())?) {
        
        DataManager<TravelOrderChatting>.queryServerForDoubleResponse("SetAllMessageToViewedByDriver/\(orderId)", filter: nil) { (count) in
            
            completion?(number : count == nil ? 0 : Int(count!))
        }
    }
    


}

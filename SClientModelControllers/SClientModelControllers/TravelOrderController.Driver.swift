
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
import CoreLocation

    extension TravelOrderController {
        
        
        public static func GetOrderComments(_ driverId: String,page: Int?, pagesize: Int?, serverHandler: ((_ orders: [TravelOrder]) -> ())? ) ->Void{
            
            var filter :String?
            
            if(page != nil){
                filter =  "page=" + String(page!)
            }
            
            if(pagesize != nil){
                
                if(filter == nil){
                    filter = "pagesize=" + String(pagesize!)
                }else{
                    filter = filter! + "&pagesize=" + String(pagesize!)
                }
            }
            
            ModelController<TravelOrder>.queryServer("comment/\(driverId)", filter: filter) { (items) in
                
                serverHandler?(orders: items!)
                
            }
        }
        
        
        public static func GetLastOpenningOrderByDriver(_ driverId: String, serverHandler: ((_ order: TravelOrder?) -> ())? ) ->Void{
            
            
            ModelController<TravelOrder>.queryServerForOne("GetLastOpenningOrderByDriver/\(driverId)", filter: nil) { (item) in
                
                serverHandler?(order: item)
                
            }
            
        }
        
        
        
        public static func CalculateOrderPrice(_ driverId: String,distance: Double,currency: String, serverHandler: ((_ result: Double?) -> ())? ) ->Void{
            
            DataManager<TaxiPrice>.queryServerForDoubleResponse("calctravelprice", filter: "Driver=\(driverId)&Currency=\(currency)&Distance=\(distance)") { (result) in
                serverHandler?(result: result)
            }
            
        }
        
        
        
        
        public static func GetNotYetPaidOrderByDriver(_ driverId: String, serverHandler: ((_ orders: [TravelOrder]) -> ())? ) ->Void{
            
            
            ModelController<TravelOrder>.queryServer("GetNotYetPaidOrderByDriver/\(driverId)", filter: nil) { (items) in
                
                serverHandler?(orders: items!)
                
            }
            
        }
        
        
        public static func GetNotYetPickupOrderByDriver(_ driverId: String, serverHandler: ((_ orders: [TravelOrder]) -> ())? ) ->Void{
            
            
            ModelController<TravelOrder>.queryServer("GetNotYetPickupOrderByDriver/\(driverId)", filter: nil) { (items) in
                
                serverHandler?(orders: items!)
                
            }
            
        }

        
        public static func GetStoppedOrderByDriver(_ driverId: String,page: Int?, pagesize: Int?, serverHandler: ((_ orders: [TravelOrder]) -> ())? ) ->Void{
            
            
            var filter :String = ""
            
            if(page != nil){
                filter = "page=" + String(page!)
            }
            
            if(pagesize != nil){
                filter = filter + "&pagesize=" + String(pagesize!)
            }
            
            
            ModelController<TravelOrder>.queryServer("GetStoppedOrderByDriver/\(driverId)", filter: filter) { (items) in
                serverHandler?(orders: items!)
            }
            
        }
        
        
        public static func GetNearestOpenOrders(_ coordinate: CLLocationCoordinate2D,page: Int?, pagesize: Int?, serverHandler: ((_ orders: [TravelOrder]) -> ())? ) ->Void{
            
            var filter = "longtitude=" + String(coordinate.longitude) + "&latitude=" + String(coordinate.latitude)
            
            if(page != nil){
                filter = filter + "&page=" + String(page!)
            }
            
            if(pagesize != nil){
                filter = filter + "&pagesize=" + String(pagesize!)
            }
            
            ModelController<TravelOrder>.queryServer("nearest", filter: filter) { (items) in
                
                if(serverHandler != nil){
                    serverHandler!(orders: items!)
                }
                
            }
            
        }

}
    

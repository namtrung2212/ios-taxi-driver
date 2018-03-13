//
//  DriverController.swift
//  SClientModelControllers
//
//  Created by Trung Dao on 4/13/16.
//  Copyright © 2016 SCONNECTING. All rights reserved.
//

import UIKit
import Foundation
import ObjectMapper
import Alamofire
import AlamofireObjectMapper
import SClientData
import SClientModel
import CoreLocation

open class DriverController: ModelController<Driver>  {
    
    
    open static func activate(_ driverId: String, completion: (() -> ())? ) ->Void{
        
        DataManager<Driver>.queryServer("activate/\(driverId)", filter: nil) { (items) in
            completion?()
        }
        
    }

    
    open static func GetNearestDrivers(_ coordinate: CLLocationCoordinate2D,page: Int?, pagesize: Int?, serverHandler: ((_ drivers: [DriverStatus]) -> ())? ) ->Void{
        
            var filter = "longtitude=" + String(coordinate.longitude) + "&latitude=" + String(coordinate.latitude)
        
            if(page != nil){
                filter = filter + "&page=" + String(page!)
            }
            
            if(pagesize != nil){
                filter = filter + "&pagesize=" + String(pagesize!)
            }

            DataManager<DriverStatus>.queryServer("nearest", filter: filter) { (items) in
                
                if(serverHandler != nil){
                    serverHandler!(drivers: items!)
                }

            }
        
    }
    
    
    open static func ChangeDriverReadyStatus(_ driverId: String, serverHandler: ((_ status: DriverStatus?) -> ())? ) ->Void{
        
        
        var url =  "/Driver/changeReadyStatus/" +  driverId
        
        let headers = [ "Token" : ServerStorage.Token! , "Hash" : CryptoHelper.generateHashKey( url ) ]
        
        url = SClientData.ServerURL + url
        
        Alamofire.request(Method.PUT,url,headers : headers)
            .responseObject { (response: Response<DriverStatus, NSError>) in
                
                switch response.result {
                    
                case .success:
                    let newitem = response.result.value
                    
                    if  newitem != nil {
                        serverHandler?(status: newitem)
                        
                    }else{
                        serverHandler?(status: nil)
                    }
                    
                case .failure(_):
                    serverHandler?(status: nil)
                    break
                }
        }

        
    }


}

//
//  DriverActivation.swift
//  SClientModelControllers
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

extension DriverController {
    
    public static func RequestForActivationCode( _ CitizenID : String, countryCode : String, completion: @escaping (_ requestId : String?, _ errorcode: String?)->() ){
        
        ServerStorage<DriverSetting>.get("authenticate/SendVerifyCode?country=\(countryCode)&CitizenID=\(CitizenID)") { (result: String?) in
            
            do {
                
                let data = String(result!).data(using: String.Encoding.utf8, allowLossyConversion: false)
                let json = try JSONSerialization.jsonObject(with: data!, options: []) as! [String: AnyObject]
                
                let request_id = json["request_id"] as? String
                let error = json["error"] as? Bool
                let message = json["message"] as? String
                
                if  request_id != nil  {
                    completion(requestId: request_id,errorcode: nil)
                }else{
                    completion(requestId: nil,errorcode: message!)
                }
                
            } catch let error as NSError {
                completion(requestId: nil,errorcode: error.localizedDescription)
                print("Failed to load: \(error.localizedDescription)")
            }
        }
    }
    
    
    
    public static func CheckForActivationCode( _ request_id : String, code : String, CitizenID : String, completion: @escaping (_ DriverId : String?, _ errorcode: String?)->() ){
        
        ServerStorage<DriverSetting>.get("authenticate/CheckVerifyCode?request_id=\(request_id)&code=\(code)&CitizenID=\(CitizenID)") { (result: String?) in
            
            do {
                
                let data = String(result!).data(using: String.Encoding.utf8, allowLossyConversion: false)
                let json = try JSONSerialization.jsonObject(with: data!, options: []) as! [String: AnyObject]
                
                
                if let error = json["error"] as? Bool {
                    if ( error == true ){
                        completion(DriverId: nil, errorcode: json["message"] as? String)
                    }else{
                        let driverId = json["message"] as? String
                        
                        completion(DriverId: driverId, errorcode: nil)
                    }
                }else{
                    completion(DriverId: nil, errorcode: nil)
                }
                
            } catch let error as NSError {
                print("Failed to load: \(error.localizedDescription)")
            }
        }
    }
    
    
}

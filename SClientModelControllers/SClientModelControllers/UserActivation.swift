//
//  UserActivation.swift
//  SClientModelControllers
//
//  Created by Trung Dao on 4/13/16.
//  Copyright © 2016 SCONNECTING. All rights reserved.
//

import UIKit
import Foundation
import SClientData
import SClientModel

extension UserController {
    
    public static func RequestForActivationCode( _ phoneNo : String, countryCode : String, completion: @escaping (_ requestId : String?)->() ){
        
        ServerStorage<UserSetting>.get("authenticate/SendVerifyCode?country=\(countryCode)&PhoneNo=\(phoneNo)") { (result: String?) in
            
            do {
                
                let data = String(result!).data(using: String.Encoding.utf8, allowLossyConversion: false)
                let json = try JSONSerialization.jsonObject(with: data!, options: []) as! [String: AnyObject]
                if let request_id = json["request_id"] as? String {
                    completion(requestId: request_id)
                }else{
                    completion(requestId: nil)
                }
                
            } catch let error as NSError {
                 completion(requestId: nil)
                print("Failed to load: \(error.localizedDescription)")
            }
        }
    }
    
    
    
    public static func CheckForActivationCode( _ request_id : String, code : String, phoneNo : String, completion: @escaping (_ UserId : String?, _ errorcode: String?)->() ){
        
        ServerStorage<UserSetting>.get("authenticate/CheckVerifyCode?request_id=\(request_id)&code=\(code)&PhoneNo=\(phoneNo)") { (result: String?) in
            
            do {
                
                let data = String(result!).data(using: String.Encoding.utf8, allowLossyConversion: false)
                let json = try JSONSerialization.jsonObject(with: data!, options: []) as! [String: AnyObject]
                
                
                if let error = json["error"] as? Bool {
                    if ( error == true ){
                        completion(UserId: nil, errorcode: json["message"] as? String)
                    }else{
                        let userId = json["message"] as? String
                        
                        completion(UserId: userId, errorcode: nil)
                    }
                }else{
                    completion(UserId: nil, errorcode: nil)
                }
                
            } catch let error as NSError {
                print("Failed to load: \(error.localizedDescription)")
            }
        }
    }
    

}

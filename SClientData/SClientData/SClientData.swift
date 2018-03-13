//
//  SClientDataManager.swift
//  SClientData
//
//  Created by Trung Dao on 4/11/16.
//  Copyright © 2016 SCONNECTING. All rights reserved.
//

import UIKit

open class SClientData: NSObject {
    open static var ServerURL = "http://localhost:8000";
    
    open static  var Token: String?{
        
        get {
            return UserDefaults.standard.string(forKey: "Token")
        }
    }

}

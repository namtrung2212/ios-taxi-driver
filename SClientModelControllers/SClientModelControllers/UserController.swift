//
//  UserController.swift
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

open class UserController: ModelController<User>  {

    
    open static func activate(_ userId: String, completion: (() -> ())? ) ->Void{
        
        DataManager<User>.queryServer("activate/\(userId)", filter: nil) { (items) in
            completion?()
        }
        
    }
    
}

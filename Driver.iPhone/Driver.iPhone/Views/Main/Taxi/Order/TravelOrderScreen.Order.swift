//
//  TravelOrderScreen.Order.swift
//  Driver.iPhone
//
//  Created by Trung Dao on 8/3/16.
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

extension TravelOrderScreen{
    
    var CurrentOrder: TravelOrder? {
        
        get {
            return SCONNECTING.TaxiManager!.currentOrder
        }
    }
    
    
    var CurrentDriverStatus: DriverStatus! {
        
        get {
            return SCONNECTING.DriverManager!.CurrentDriverStatus
        }
    }



}
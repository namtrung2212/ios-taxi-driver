//
//  Enums.swift
//  SClientModel
//
//  Created by Trung Dao on 6/20/16.
//  Copyright © 2016 SCONNECTING. All rights reserved.
//

import Foundation

open class OrderStatus {
      open static var Open : String = "Open"
      open static var Requested: String  = "Requested"
      open static var BiddingAccepted : String = "BiddingAccepted"
      open static var DriverAccepted : String = "DriverAccepted"
      open static var DriverRejected : String = "DriverRejected"
      open static var TripStarted : String = "TripStarted"
      open static var VoidedBfPickupByUser : String = "VoidedBfPickupByUser"
      open static var VoidedBfPickupByDriver : String = "VoidedBfPickupByDriver"
      open static var VoidedAfPickupByUser : String = "VoidedAfPickupByUser"
      open static var VoidedAfPickupByDriver : String = "VoidedAfPickupByDriver"
      open static var Finished: String  = "Finished"
    
}

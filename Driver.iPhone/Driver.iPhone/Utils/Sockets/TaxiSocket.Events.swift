//
//  TaxiSocket.Actions.swift
//  Driver.iPhone
//
//  Created by Trung Dao on 6/19/16.
//  Copyright © 2016 SCONNECTING. All rights reserved.
//

import Foundation


public protocol TaxiSocketDelegate {
    
    func onTaxiSocketLogged(_ data : [AnyObject])
    
    func onCarUpdateLocation(_ data : [AnyObject])
    func onUserViewDriverProfile(_ data : [AnyObject])
    
    func onUserRequestTaxi(_ data : [AnyObject])
    func onUserCancelRequest(_ data : [AnyObject])
    
    func onUserAcceptBidding(_ data : [AnyObject])
    func onUserCancelBidding(_ data : [AnyObject])
    
    func onUserVoidedBfPickup(_ data : [AnyObject])
    func onUserVoidedAfPickup(_ data : [AnyObject])
    
    func onUserPaid(_ data : [AnyObject])
    }


extension TaxiSocket {
        
    
    
    
}

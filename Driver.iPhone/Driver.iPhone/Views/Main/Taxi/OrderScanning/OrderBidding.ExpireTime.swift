//
//  Main.CreateOrder.CustomOrder.Events.swift
//  User.iPhone
//
//  Created by Trung Dao on 6/3/16.
//  Copyright © 2016 SCONNECTING. All rights reserved.
//

import UIKit
import Foundation
import ObjectMapper
import AlamofireObjectMapper
import SClientData
import SClientModel
import CoreLocation
import RealmSwift
import GoogleMaps


extension OrderBiddingScreen : PopupDatePickerDelegate{
    
    
    func showChooseExpireTime(){
        
        let datePicker = PopupDatePicker.show()
        datePicker.delegate = self
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.setDate(self.CurrentOrder!.OrderPickupTime!)
        datePicker.setTitle("Chọn thời điểm hết hạn chờ phản hồi : ")
        self.view.addSubview(datePicker)
        
        datePicker.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: 0).isActive = true
        datePicker.heightAnchor.constraint(equalTo: self.view.heightAnchor, constant: 0).isActive = true
        datePicker.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0.0).isActive = true
        datePicker.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 0.0).isActive = true
        
        
    }
    
    func didChooseDateTime(_ sender: PopupDatePicker) {
        
        if(sender.isCancel == false){
            
           // self.navigationController?.popViewControllerAnimated(true)
            
            SCONNECTING.TaxiManager!.bidding(self.CurrentOrder!, message: nil, expireTime: sender.dateValue, completion: { (item) in
                self.invalidate(self.CurrentOrder!)
            })
        }
        
    }
}

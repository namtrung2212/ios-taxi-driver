//
//  TravelOrderScreen.Events.swift
//  User.iPhone
//
//  Created by Trung Dao on 6/23/16.
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
    
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.isActive = true
        
        if(self.CurrentOrder != nil && (self.CurrentOrder!.IsWaitingForDriver() || self.CurrentOrder!.IsMonitoring())) {
            
            self.mapView.moveToCurrentCarLocation()
            
        }
        
        
        
    }
    
    public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.isActive = false
    }
    
    public func btnHome_Clicked() {
        
        AppDelegate.mainWindow?.leftViewCtrl.invalidate{
            
        }
        AppDelegate.mainWindow?.taxiViewCtrl.slideMenuController()?.openLeft()
        
    }
    
    func hideNavigationBar(_ hide: Bool){
        if(self.isActive == false){
            return
        }
        if(hide && self.navigationController?.navigationBar.isHidden == false){
            UIView.animate(withDuration: 0.3,
                                       animations: {
                                        self.navigationController?.navigationBar.layer.position.y -= 60
                                        self.navigationController?.navigationBar.isHidden = false
                                        
                },
                                       completion: {finish in
                                        
                                        self.navigationController?.navigationBar.layer.position.y = 0
                                        self.navigationController?.navigationBar.isHidden = true
            })
        }else if(hide == false && self.navigationController?.navigationBar.isHidden == true){
            
            self.navigationController?.navigationBar.layer.position.y = 0
            UIView.animate(withDuration: 1.0,
                                       animations: {
                                        self.navigationController?.navigationBar.layer.position.y += 30
                                        self.navigationController?.navigationBar.isHidden = false
                },
                                       completion: {finish in
                                        self.navigationController?.navigationBar.layer.position.y = 42
                                        self.navigationController?.navigationBar.isHidden = false
            })
        }
    }
    
    
}

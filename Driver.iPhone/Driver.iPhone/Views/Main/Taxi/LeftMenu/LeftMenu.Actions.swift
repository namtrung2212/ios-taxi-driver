//
//  File.swift
//  User.iPhone
//
//  Created by Trung Dao on 5/13/16.
//  Copyright © 2016 SCONNECTING. All rights reserved.
//

import Foundation
//
//  HomeViewController.swift
//  User.iPhone
//
//  Created by Trung Dao on 4/13/16.
//  Copyright © 2016 SCONNECTING. All rights reserved.
//
import UIKit
import Foundation
import ObjectMapper
import AlamofireObjectMapper
import AlamofireImage
import SClientData
import SClientModel
import SClientModelControllers

import CoreLocation
import RealmSwift
import GoogleMaps

extension LeftMenuViewController {
    
    func menuItem_Clicked(_ item: MenuItemObject){
        
        if(item.Section == 0 ){
            
            if(item.Index == 0){
                
                SCONNECTING.TaxiManager!.getOpenningOrder { (item) in
                    
                    SCONNECTING.TaxiManager!.reset(item, updateUI: true){
                    }
                }
                
            }else if(item.Index == 2){
                
                let instance  =  OrderScanningScreen()
                
                AppDelegate.mainWindow?.taxiViewCtrl.hideNavigationBar(false)
                AppDelegate.mainWindow?.taxiViewCtrl.navigationController?.pushViewController(instance, animated:true)
                

                
            }else if(item.Index == 3){
                
                let instance  =  NotYetPickupScreen()
                
                AppDelegate.mainWindow?.taxiViewCtrl.hideNavigationBar(false)
                AppDelegate.mainWindow?.taxiViewCtrl.navigationController?.pushViewController(instance, animated:true)
                
            }else if(item.Index == 4){
                
                let instance  =  NotYetPaidScreen()
                
                AppDelegate.mainWindow?.taxiViewCtrl.hideNavigationBar(false)
                AppDelegate.mainWindow?.taxiViewCtrl.navigationController?.pushViewController(instance, animated:true)
                
                
            }else if(item.Index == 5){
                
                let instance  =  TravelHistoryScreen()
                
                AppDelegate.mainWindow?.taxiViewCtrl.hideNavigationBar(false)
               AppDelegate.mainWindow?.taxiViewCtrl.navigationController?.pushViewController(instance, animated:true)
                
                
            }else if(item.Index == 14){
                
              //  let instance  =  TravelHistoryScreen()
                
                AppDelegate.mainWindow?.taxiViewCtrl.hideNavigationBar(false)
               // AppDelegate.mainWindow?.taxiViewCtrl.navigationController?.pushViewController(instance, animated:true)
                
                
            }
            
        }else if(item.Section == 1 ){
            
        }
        
        AppDelegate.mainWindow?.taxiViewCtrl.slideMenuController()?.closeLeft()
    }
    
    
    
    
}

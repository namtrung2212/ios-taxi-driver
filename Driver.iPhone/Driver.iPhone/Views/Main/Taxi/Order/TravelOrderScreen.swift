//
//  TravelOrderScreen.swift
//  Driver.iPhone
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
import CoreLocation
import RealmSwift
import GoogleMaps

open class TravelOrderScreen: UIViewController {
    
    var mapView: MapView!
    var mapLocation: MapLocation!
    var mapMarkerManager: MapMarkerManager!
    
    var placeSearcher: PlaceSearcher!

    open var isActive: Bool = false
    open var isRotateEnable: Bool = true
    open var isShouldCheckCar: Bool = true
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        mapView = MapView(parent: self)
        mapLocation = MapLocation(parent: self)
        mapMarkerManager = MapMarkerManager(parent: self)
        placeSearcher = PlaceSearcher(parent: self)
        

        if(self.mapView.gmsMapView == nil){
            
                self.initControls{
                    
                    self.initLayouts{
                            
                            if(self.isShouldCheckCar == true && self.CurrentDriverStatus != nil  && self.CurrentDriverStatus!.WorkingPlan != nil){
                                
                                    SCONNECTING.DriverManager?.checkCarAvaiable({ (hasCar) in
                                        
                                        SCONNECTING.NotificationManager!.taxiSocket.resetCar()
                                        
                                        if(hasCar){
                                            
                                            SCONNECTING.TaxiManager!.getOpenningOrder { (item) in
                                                
                                                SCONNECTING.LocationManager!.startUpdatingLocation()
                                                SCONNECTING.TaxiManager!.reset(item, updateUI: true){
                                                }
                                            }
                                            
                                        }else{
                                            
                                            SCONNECTING.LocationManager!.startUpdatingLocation()                        
                                            SCONNECTING.TaxiManager!.reset(nil, updateUI: true){
                                               
                                            }
                       
                                        }
                                        

                                    })
                                
                            }
                            
                            self.isShouldCheckCar = false
                    }
                }
        }
    
    }
    
    func initControls(_ completion: (() -> ())?){
        
        self.initMapControls{
            self.initSearchControl{}
            self.initControlPanelControls{
                self.initOrderMonitoringControls{
                    self.initOtherControls(completion)
                }
            }
        }
        
    }
    
    func initLayouts(_ completion: (() -> ())?){
        
        self.initMapLayout{
            
            self.initControlPanelLayout{
                
                    self.initOrderMonitoringLayout(completion)
                
            }
        }
    }
    
   
    
    open func invalidateUI(_ completion: (() -> ())?){
        
        self.invalidateMapView{
            self.invalidateControlPanelView{
                self.invalidateOrderMonitoringView(completion)
            }
        }
        
      //  self.hideNavigationBar(( self.CurrentOrder != nil && (self.CurrentOrder!.IsMonitoring() || self.CurrentOrder!.IsStopped())))
    }
    
    
    func initOtherControls(_ completion: (() -> ())?){
        
        let btnHome = UIBarButtonItem(title: "Home", style: .plain, target: self, action: #selector(TravelOrderScreen.btnHome_Clicked))
        btnHome.setFAIcon(FAType.faBars, iconSize : 24)
        btnHome.setTitlePositionAdjustment(UIOffsetMake(0, -5), for: .default)
        
        
        self.navigationItem.leftBarButtonItem = btnHome

        completion?()
    }
    
}

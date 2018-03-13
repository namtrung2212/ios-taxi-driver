//
//  MapMarker.swift
//  Driver.iPhone
//
//  Created by Trung Dao on 4/13/16.
//  Copyright © 2016 SCONNECTING. All rights reserved.
//

import UIKit
import Foundation
import AlamofireObjectMapper
import SClientData
import SClientModel
import CoreLocation
import RealmSwift
import GoogleMaps
import SClientModelControllers
import ObjectMapper

open class MapMarkerManager{
    
    var parent: TravelOrderScreen
    
    var carList: [String: CarMarker] = [:]
    
    var currentCar: CarMarker? {
        get{
            
            if(SCONNECTING.DriverManager!.CurrentDriverStatus!.Car != nil){
                
                    return  self.carList[(SCONNECTING.DriverManager?.CurrentDriver!.id!)!]

            }else{
                
                if(SCONNECTING.DriverManager!.CurrentCarStatus != nil && SCONNECTING.DriverManager?.CurrentCarStatus!.Driver != nil){
                    
                    return self.carList[(SCONNECTING.DriverManager?.CurrentCarStatus!.Driver!)!]
           
                }
            }

            return  nil
        }
    }
    
    
    public init(parent: TravelOrderScreen){
        
        self.parent = parent
    }
    
    open func loadCars(_ coordinate: CLLocationCoordinate2D){
        
        DriverController.GetNearestDrivers(coordinate,page: nil,pagesize: nil, serverHandler: { (drivers) in
            
            self.loadCars(drivers)
            
        })
        
    }
    
    open func loadCars(_ drivers : [DriverStatus]){
        
        for driverStatus in drivers{
            
            if(driverStatus.Driver != nil && driverStatus.Location != nil ){
                
                var marker: CarMarker? =  self.carList[driverStatus.Driver!]
                
                if(marker == nil){
                    
                    marker = CarMarker(parent: self.parent, driverId: driverStatus.Driver!)
                    self.carList[driverStatus.Driver!] = marker
                    
                }
                
                marker!.updateStatus(driverStatus)
                
            }
        }
        
        
        for (driverId, marker) in self.carList {
            
            var found:Bool = false
            
            for driverStatus in drivers{
                if(driverStatus.Driver! == driverId){
                    found = true
                    break
                }
            }
            if(!found){
                marker.hideCar()
            }
            
        }
    }
    
    
    open func invalidateCar(_ driverId: String,latitude: Double, longitude: Double, degree: Double, hideOther: Bool){
        
        if(hideOther){
            self.hideCars(driverId)
        }
        
        var marker: CarMarker? =  self.carList[driverId]
        
        if(marker == nil){
            marker = CarMarker(parent: self.parent, driverId: driverId)
            self.carList[driverId] = marker
        }
        
        marker!.showCar()
        marker!.updateLocation(latitude, longitude: longitude, degree: degree)
        
    }
    
    open func hideCars(_ exceptId: String?){
        
        for (id, marker) in self.carList {
            if(exceptId == nil || exceptId != id){
                marker.hideCar()
            }
        }
    }
    
    open func hideCars(){
        
        self.hideCars(nil)
    }

    
    open func showCars(){
        
        for (_, marker) in self.carList {
            marker.showCar()
        }
    }
    
    open func rotateCars(_ degree: Double){
        
        for (_, marker) in self.carList {
            marker.rotateCar(degree)
        }
    }
    
}




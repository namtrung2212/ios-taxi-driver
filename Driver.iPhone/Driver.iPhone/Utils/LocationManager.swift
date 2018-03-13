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
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}



open class SCLocationInfo{
    
    open var Location: CLLocation?
    
    open var Country: String?
    open var Province: String?
    open var Locality: String?
    open var PostalCode: String?
    
    public init(){
    }
    
    
}

open class SCLocationManager : NSObject, CLLocationManagerDelegate {
    
    open  var manager: CLLocationManager?
    
    open static var currentLocation: SCLocationInfo?
    
    open static var latitude: Double?{
        get{
            return SCLocationManager.currentLocation!.Location!.coordinate.latitude
        }
    }
    
    open static var longitude: Double?{
        get{
            return SCLocationManager.currentLocation!.Location!.coordinate.longitude
        }
    }
    
    
    open var lastLocation: SCLocationInfo?
    open var lastUpdateLocation: CLLocation?
    
    open var locations: [SCLocationInfo]?
    var isAddingLocation: Bool = false
    
    public override init(){
        
        super.init()
        
        locations = [SCLocationInfo]()
        SCLocationManager.currentLocation = SCLocationInfo()
        
        
     //   self.startUpdatingLocation()
    }
    
    
    open func startUpdatingLocation(){
        
        if(manager == nil){
            manager =  CLLocationManager()
            manager!.delegate = self;
            manager!.distanceFilter = kCLDistanceFilterNone; //whenever we move
            manager!.desiredAccuracy = kCLLocationAccuracyBest;
            
            if (manager!.responds(to: #selector(CLLocationManager.requestAlwaysAuthorization)))  {
                manager!.requestAlwaysAuthorization()
            }
        }

    }
    
    open func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        if status == .authorizedAlways {
            manager.startUpdatingLocation()
            
            if(AppDelegate.mainWindow?.taxiViewCtrl.isActive == true){
                AppDelegate.mainWindow?.taxiViewCtrl.mapLocation.onLocationAuthorized()
            }
            
        }
    }
    
    open func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let location = locations.first {
            self.invalidate(location)
        }
        
    }
    
    open func invalidate(_ location: CLLocation){
        
        
        let _isMoved   = isMoved(location)
        
        SCLocationManager.currentLocation!.Location = location
                
        if(AppDelegate.mainWindow?.taxiViewCtrl.isActive == true){
            AppDelegate.mainWindow?.taxiViewCtrl.mapLocation.changeLocation(location, isMoved : _isMoved)
        }

        if(isAddingLocation){
            return
        }
        
        if(_isMoved){
            
            isAddingLocation = true
            
            SCLocationManager.currentLocation!.Location = location
            
            self.addNewLocation(SCLocationManager.currentLocation!)
            
            self.updateDriverPositionHistory()
            
            self.isAddingLocation = false
            
            
        }
        
        
    }
    
    func addNewLocation(_ newLocation: SCLocationInfo){
        
        if( self.locations?.count > 20 ){
            self.locations?.removeFirst()
        }
        
        let newLocationInfo = SCLocationInfo()
        newLocationInfo.Location =  newLocation.Location
        newLocationInfo.Country =  newLocation.Country
        newLocationInfo.Province =  newLocation.Province
        newLocationInfo.Locality =  newLocation.Locality
        newLocationInfo.PostalCode =  newLocation.PostalCode
        
        self.lastLocation = newLocationInfo
        self.locations?.append(newLocationInfo)
        
        
    }
    
    func updateDriverPositionHistory(){
        
        if( (SCONNECTING.DriverManager?.CurrentDriverStatus != nil && SCONNECTING.DriverManager?.CurrentDriverStatus!.IsReady ==  true) || (SCONNECTING.TaxiManager?.currentOrder != nil && SCONNECTING.TaxiManager?.currentOrder!.IsMonitoring() == true) ){
            
                let location : CLLocation? = SCLocationManager.currentLocation!.Location
                let driverId = SCONNECTING.DriverManager?.CurrentDriver?.id
                
                if ( driverId != nil && location != nil ) {
                    
                    let position = DriverPosHistory()
                    position.Driver = String(driverId!)
                    position.Location = LocationObject(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
                    position.Speed = location!.speed
                    position.Device = UIDevice.current.model
                    position.DeviceID = UIDevice.current.identifierForVendor!.uuidString
                    position.Degree = location!.course
                    
                    if(lastUpdateLocation == nil || lastUpdateLocation!.distance(from: location!) > 50){
                        ModelController<DriverPosHistory>.create(position) { (id) in
                            self.lastUpdateLocation = location
                        }
                    }
            
                    if(SCONNECTING.TaxiManager!.currentOrder != nil && SCONNECTING.TaxiManager!.currentOrder!.IsMonitoring() == true  &&
                        (SCONNECTING.TaxiManager!.currentOrder!.OrderPickupTime == nil || SCONNECTING.TaxiManager!.currentOrder!.OrderPickupTime!.isSince(30) )) {
                        SCONNECTING.TaxiManager!.nofifyLocationToUser(SCONNECTING.TaxiManager!.currentOrder, location: location!)
                        
                    }
                  
                    
                }
        }
        
    }

    func isMoved(_ location: CLLocation)-> Bool{
        
        var isMoved = false
        
        if( self.lastLocation != nil ){
            let distance = location.distance(from: self.lastLocation!.Location!)
            let time = location.timestamp.timeIntervalSince(self.lastLocation!.Location!.timestamp) // seconds
            isMoved = ( location.speed>0 &&  time > 5 &&
                // distance > max(self.lastLocation!.Location!.horizontalAccuracy,self.lastLocation!.Location!.verticalAccuracy)
                distance > 5
            )
            
        }else{
            isMoved = true
        }
        
        return isMoved
    }
    
}

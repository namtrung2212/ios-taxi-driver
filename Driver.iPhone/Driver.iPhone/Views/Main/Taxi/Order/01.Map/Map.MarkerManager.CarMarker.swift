//
//  Map.MarkerManager.CarMarker.swift
//  Driver.iPhone
//
//  Created by Trung Dao on 8/3/16.
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

open class CarMarker{
    
    var marker: GMSMarker?
    var driverId: String
    var driverStatus: DriverStatus?
    
    var lastUpdateTime: Date? = nil
    var lastUpdateLocation : CLLocationCoordinate2D? = nil
    
    var isShow: Bool = true
    
    var parent: TravelOrderScreen
    
    public init(parent: TravelOrderScreen, driverId: String){
        
        self.parent = parent
        self.driverId = driverId
    }
    
    open func updateStatus(_ status : DriverStatus){
        
        if(status.Driver == driverId  && status.Location != nil ){
            
            self.driverStatus = status
            self.invalidate{
                
            }
            
        }
        
    }
    
    open func updateLocation(_ latitude: Double, longitude: Double, degree: Double){
        
        var isAnimation : Bool = true
        
        if(self.driverStatus == nil){
            self.driverStatus = DriverStatus()
            self.driverStatus!.Driver = self.driverId
            isAnimation = false
        }
        
        if(self.driverStatus!.Location == nil){
            isAnimation = false
            
        }else{
            let source = CLLocation(latitude: latitude , longitude: longitude)
            let destiny = CLLocation(latitude: self.driverStatus!.Location!.lat , longitude: self.driverStatus!.Location!.long)
            if( abs(source.distance(from: destiny)) > 50){
                isAnimation = false
            }
            
        }
        
        self.driverStatus?.Location = LocationObject(latitude: latitude, longitude: longitude)
        self.driverStatus?.Degree = degree
        
        if(isAnimation){
            CATransaction.begin()
            CATransaction.setAnimationDuration(5)
        }
        
        self.invalidate{
            
        }
        
        if(isAnimation){
            CATransaction.commit()
        }
        
    }
    
    open func distanceFromDriver() -> Double{
        if( SCLocationManager.currentLocation != nil  && SCLocationManager.currentLocation!.Location != nil && SCONNECTING.DriverManager!.CurrentDriver != nil){
            if(self.driverStatus != nil && self.driverStatus!.Location != nil){
                return SCLocationManager.currentLocation!.Location!.distance(from: CLLocation(latitude: self.driverStatus!.Location!.lat, longitude: self.driverStatus!.Location!.long))
            }
        }
        
        return -1
    }
    
    
    open func distanceFromCLLocation(_ location : CLLocation) -> Double{
        
        if(self.driverStatus != nil && self.driverStatus!.Location != nil){
            return location.distance(from: CLLocation(latitude: self.driverStatus!.Location!.lat, longitude: self.driverStatus!.Location!.long))
        }
        
        
        return -1
    }
    open func distanceFromLocation(_ location : LocationObject) -> Double{
        
        let locationObj = CLLocation(latitude: location.coordinate().latitude, longitude: location.coordinate().longitude)
        if(self.driverStatus != nil && self.driverStatus!.Location != nil){
            return locationObj.distance(from: CLLocation(latitude: self.driverStatus!.Location!.lat, longitude: self.driverStatus!.Location!.long))
        }
        
        
        return -1
    }
    
    
    
    
    open func invalidate(_ completion: (() -> ())?){
        
        if(self.marker == nil){
            
            let position = CLLocationCoordinate2D(latitude: self.driverStatus!.Location!.lat, longitude: self.driverStatus!.Location!.long)
            self.marker = GMSMarker(position: position)
            
            let carIcon =  ImageHelper.resize(UIImage(named: "car.png")!, newWidth: 36)
            let carView = UIImageView(image: carIcon)
            self.marker!.iconView = carView
            self.marker!.tracksViewChanges = true
            
            
        }
        
        self.marker!.map = self.isShow ? self.parent.mapView.gmsMapView : nil
        self.marker!.title = self.driverStatus!.DriverName
        self.marker!.position = CLLocationCoordinate2D(latitude: self.driverStatus!.Location!.lat, longitude :  self.driverStatus!.Location!.long)
        self.rotateCar(self.parent.mapView.gmsMapView.camera.bearing)
        
        completion?()
    }
    
    
    open func hideCar(){
        
        marker?.map = nil
        isShow = (marker?.map != nil)    }
    
    open func showCar(){
        if( marker?.map == nil){
            marker?.map = self.parent.mapView.gmsMapView
        }
        
        isShow = (marker?.map != nil)

    }
    
    func moveToCarLocation(){
        
        let coordinate: CLLocationCoordinate2D = self.driverStatus!.Location!.coordinate()
        
        CATransaction.begin()
        CATransaction.setAnimationDuration(3)
        self.parent.mapView.gmsMapView.animate(toLocation: coordinate)
        CATransaction.commit()
        
    }
    
    
    
    
    open func rotateCar(_ degree: Double){
        
        self.marker?.rotation = CLLocationDegrees((self.driverStatus?.Degree)!) - CLLocationDegrees(degree)
        
    }
    
    
}



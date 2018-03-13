//
//  TravelOrderScreen.swift
//  User.iPhone
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



open class MapLocation : NSObject{
    
    var parent: TravelOrderScreen
    
    var CurrentOrder: TravelOrder! {
        
        get {
            return SCONNECTING.TaxiManager!.currentOrder
        }
    }
    
    public init(parent: TravelOrderScreen){
        
        self.parent = parent
    }
    
    open func onLocationAuthorized() {
        
        self.parent.mapView.gmsMapView.isMyLocationEnabled = false
    }
    
    open func changeLocation(_ location: CLLocation, isMoved : Bool) {
        
        if( self.parent.mapView.shouldToMoveToCurrentLocaton){
            // ravelView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
            self.parent.mapView.gmsMapView.animate(toLocation: location.coordinate)
            
            let northEast = CLLocationCoordinate2DMake(location.coordinate.latitude + 5, location.coordinate.longitude + 5)
            let southWest = CLLocationCoordinate2DMake(location.coordinate.latitude - 5, location.coordinate.longitude - 5)
            let bounds = GMSCoordinateBounds(coordinate: northEast, coordinate: southWest)
            
            self.parent.placeSearcher.searchResultController.autocompleteBounds = bounds
            
            self.parent.mapView.shouldToMoveToCurrentLocaton = false
        }
        
            
                if(SCONNECTING.DriverManager!.CurrentDriverStatus!.Car != nil){
                    
                    if(self.CurrentOrder == nil || (self.CurrentOrder != nil && (self.CurrentOrder!.IsMonitoring()))){
                    
                        self.parent.mapMarkerManager.invalidateCar((SCONNECTING.DriverManager?.CurrentDriver!.id!)!, latitude: location.coordinate.latitude, longitude: location.coordinate.longitude, degree: location.course,hideOther: true)
                       
                        if(isMoved || (self.CurrentOrder != nil && self.CurrentOrder!.IsMonitoring())){
                                 self.parent.mapMarkerManager.currentCar!.moveToCarLocation()
                        }
                    
                    }else{
                        
                         self.parent.mapMarkerManager.hideCars()
                    }
                    
              
                }
                
                if(self.CurrentOrder != nil && (self.CurrentOrder!.IsMonitoring())){
                    self.parent.monitoringView.invalidateOrderPanel(nil)
                }
                
                SCONNECTING.TaxiManager!.locationsPoints.append(location.coordinate)
        
    }
    

    
}

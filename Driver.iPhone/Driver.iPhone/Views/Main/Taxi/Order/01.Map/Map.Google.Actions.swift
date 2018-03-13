//
//  Map.Google.Actions.swift
//  Driver.iPhone
//
//  Created by Trung Dao on 8/3/16.
//  Copyright © 2016 SCONNECTING. All rights reserved.
//
//

import Foundation

extension MapView{
        
    func addPathPolyLine(_ srcLocation: CLLocationCoordinate2D , destLocation: CLLocationCoordinate2D){
        
        if(self.currentSourceLoc == nil || self.currentDestLoc == nil
            || self.currentSourceLoc!.latitude != srcLocation.latitude || self.currentSourceLoc!.longitude != srcLocation.longitude
            || self.currentDestLoc!.latitude != destLocation.latitude || self.currentDestLoc!.longitude != destLocation.longitude ){
            
            
            GoogleMapUtil.getDistance(srcLocation, destLocation: destLocation) { (routes) in
                if (routes != nil && routes!.count > 0){
                    
                    let overViewPolyLine = routes![0]["overview_polyline"]["points"].string
                    if overViewPolyLine != nil{
                        
                        let path = GMSMutablePath(fromEncodedPath: overViewPolyLine!)
                        
                        if(self.pathPolyLine == nil){
                            self.pathPolyLine = GMSPolyline(path: path)
                            self.pathPolyLine!.strokeWidth = 3
                            self.pathPolyLine!.strokeColor = UIColor(red: 73.0/255.0, green: 139.0/255.0, blue: 199.0/255.0, alpha: 1.0)
                            
                        }else{
                            self.pathPolyLine?.path = path
                        }
                        self.pathPolyLine!.map = self.gmsMapView
                        
                        // if(self.CurrentOrder.IsNewOrder() || self.CurrentOrder.IsStopped()){
                        self.gmsMapView.animate(with: GMSCameraUpdate.fit( GMSCoordinateBounds(path: path!), with: UIEdgeInsets(top: 170,left: 40,bottom: 120,right: 40)))
                        //  }
                    }
                    
                    let distance = routes![0]["legs"][0]["distance"]["value"].doubleValue
                    let duration =  routes![0]["legs"][0]["duration"]["value"].doubleValue
                    
                    self.currentSourceLoc = srcLocation
                    self.currentDestLoc = destLocation
                    
                }
            }
            
        }else{
            
            if(self.pathPolyLine != nil){
                self.gmsMapView.animate(with: GMSCameraUpdate.fit( GMSCoordinateBounds(path: self.pathPolyLine!.path!), with: UIEdgeInsets(top: 170,left: 40,bottom: 120,right: 40)))
            }else{
                self.gmsMapView.animate(with: GMSCameraUpdate.fit( GMSCoordinateBounds(coordinate: self.currentSourceLoc!, coordinate: self.currentDestLoc!), with: UIEdgeInsets(top: 170,left: 40,bottom: 120,right: 40)))
            }
        }
        
    }
    
    func clearPathPolyLine() {
        
        pathPolyLine?.map = nil
        self.currentSourceLoc = nil
        self.currentDestLoc = nil
    }
    
    
    func moveToLocation(_ target : CLLocationCoordinate2D, isAnimate : Bool?, zoom : Float?){
        
        let location = CLLocation(latitude: target.latitude, longitude: target.longitude)
        
        if(isAnimate != nil && isAnimate == true){
            
            if(zoom != nil){
                self.gmsMapView.animate(with: GMSCameraUpdate.setTarget(location.coordinate, zoom: zoom!) )
            }else{
                self.gmsMapView.animate(toLocation: location.coordinate)
            }
            
            return
        }
        
        let current =   self.gmsMapView.camera.target
        let distance = location.distance(from: CLLocation(latitude: current.latitude, longitude: current.longitude))
        
        if(distance > 100 || (isAnimate != nil && isAnimate == false)){
            
            if(zoom != nil){
                self.gmsMapView.moveCamera(GMSCameraUpdate.setTarget(location.coordinate, zoom: zoom!))
            }else{
                self.gmsMapView.moveCamera(GMSCameraUpdate.setTarget( location.coordinate))
            }
        }else{
            
            if(zoom != nil){
                self.gmsMapView.animate(with: GMSCameraUpdate.setTarget(location.coordinate, zoom: zoom!) )
            }else{
                self.gmsMapView.animate(toLocation: location.coordinate)
            }
            
        }
    }
    public func updateAndMoveToCurrentLocation(_ zoom: Float?,isAnimate: Bool ){
        
        SCONNECTING.LocationManager?.startUpdatingLocation()
        
        self.shouldToMoveToCurrentLocaton = true
        if(self.gmsMapView == nil){
            return;
        }
        
        self.shouldToMoveToCurrentLocaton = true
        
        if(  SCLocationManager.currentLocation != nil && SCLocationManager.currentLocation?.Location != nil){
       
            self.moveToLocation((SCLocationManager.currentLocation?.Location?.coordinate)!, isAnimate : isAnimate, zoom : zoom)
            
        }
                
    }

    
    public func moveToCurrentCarLocation(){
        
        if(self.parent.mapMarkerManager.currentCar != nil){
            self.parent.mapMarkerManager.currentCar!.moveToCarLocation()
        }
    }
    
    
}

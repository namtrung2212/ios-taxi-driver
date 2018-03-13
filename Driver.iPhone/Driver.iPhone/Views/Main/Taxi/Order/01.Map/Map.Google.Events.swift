//
//  Map.Google.Events.swift
//  Driver.iPhone
//
//  Created by Trung Dao on 8/3/16.
//  Copyright © 2016 SCONNECTING. All rights reserved.
//
import Foundation

extension MapView{

    
    public func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        
        if(gesture ){
            self.shouldToHideControlWhenScroll = true
            self.parent.hideNavigationBar(false)
            if(self.parent.placeSearcher.searchController.isActive){
                self.parent.placeSearcher.searchController.isActive = false
            }
        }
        
    }
    
    public func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        
        if(position.bearing > 0){
            
            self.parent.mapMarkerManager.rotateCars(position.bearing)
        }
        
        
        
    }
    
    public func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        
        
        GoogleMapUtil.getAddress(position.target) { (address,country) in
            self.parent.placeSearcher.searchController.searchBar.placeholder = address
        }
        
        
        if(self.shouldToHideControlWhenScroll ){
            
            self.shouldToHideControlWhenScroll = false
            self.parent.hideNavigationBar(false)
        }
    }
    
    
    
    public func btnMyLocation_Clicked(_ sender: UIButton) {
        
        
        
        UIView.animate(withDuration: 0.1 ,
                                   animations: {
                                    sender.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            },
                                   completion: { finish in
                                    UIView.animate(withDuration: 0.1, animations: {
                                        sender.transform = CGAffineTransform.identity
                                    })
                                    UIView.animate(withDuration: 0.25, animations: {
                                        
                                        self.updateAndMoveToCurrentLocation(nil, isAnimate: true)
                                        
                                    }) 
                                    
        })
        
        
    }

}

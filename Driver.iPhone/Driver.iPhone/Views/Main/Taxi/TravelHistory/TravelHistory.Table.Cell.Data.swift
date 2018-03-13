//
//  Driver.Profile.Comment.Cell.Binding.swift
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

import SClientModelControllers
import DTTableViewManager
import DTModelStorage
import AlamofireImage


extension TravelOrderCell{
    
    
    public  func updateWithModel(_ travelOrder: TravelOrder) {
        self.invalidatePickupDropLocation(travelOrder)
        self.invalidateActualPrice(travelOrder)
        self.invalidateStatus(travelOrder)
        self.invalidateDate(travelOrder)
        self.invalidateMap(travelOrder)
    }
    
    
    func invalidateStatus(_ travelOrder: TravelOrder){
        
        var strStatus : String = ""
        
        if(travelOrder.IsWaitingForDriver()){
         
            strStatus = "Đang đón khách"
            
        }else if(travelOrder.IsOnTheWay()){
            
            strStatus = "Đang trong hành trình. "
            
        }else if(travelOrder.IsVoidedByDriver()){
            
            strStatus = "Đã huỷ"
            
        }else if(travelOrder.IsVoidedByUser()){
            
            strStatus = "Đã huỷ"
            
        }else if(travelOrder.IsFinishedNotYetPaid()){
            
            strStatus = "Chưa thanh toán"
            
        }else if(travelOrder.IsFinishedAndPaid()){
            
            strStatus = "Hoàn tất"
            
        }else if(travelOrder.IsDriverRequested()){
            
            strStatus = "Chưa phản hồi"
            
        }else if(travelOrder.IsDriverRejected()){
            
            strStatus = "Đã từ chối"
            
        }else if(travelOrder.IsNotYetChooseDriver()){
            
            strStatus = "Chưa yêu cầu tài xế"
        }
        
        self.lblStatus.text = strStatus.uppercased()
        
        
    }
    
    func invalidateActualPrice(_ travelOrder: TravelOrder){
        
        self.lblCurrentPrice.text = (travelOrder.ActPrice >= 0) ? travelOrder.ActPrice.toCurrency(travelOrder.Currency, country: nil) :  ""

    }
    
    func invalidateDate(_ travelOrder: TravelOrder){
    
        var date : Date?
        if(travelOrder.ActPickupTime != nil){
            
            date = travelOrder.ActPickupTime
        
        }else if(travelOrder.OrderPickupTime != nil){
        
            date = travelOrder.OrderPickupTime
        
        }else{
            
            date = travelOrder.createdAt
            
        }
        
        if(date == nil){
            self.lblDateTime.text = ""
            return
        }
        
        var strPickupTime = ""
        if(date!.isNow(5)){
            
                strPickupTime = "ngay bây giờ."
        
        }else{
        
                let seconds = date!.timeIntervalSince(Date())
                
                if ((seconds > 0) || (seconds <= 0 && abs(seconds)<=60)){
                    
                        let hours =  Int(seconds / 3600)
                        let minutes =  Int(round((seconds.truncatingRemainder(dividingBy: 3600)) / 60))
                    
                        if( hours >= 1){
                            strPickupTime =  NSString(format:"sau %d giờ, %d phút", hours, minutes ) as String
                        }else{
                            strPickupTime =  NSString(format:"sau %d phút", minutes ) as String
                        }
                    
                }else {
                    
                        let strDate = date!.toString("HH:mm")
                        
                        if(date!.isToday()){
                            strPickupTime = strDate + " hôm nay"
                            
                        }else{
                            let strDate2 = date!.toString("dd/MM")
                            strPickupTime = strDate + " ngày " + strDate2
                        }
                    
                }
        }

        self.lblDateTime.text = strPickupTime
    }
    
    func invalidatePickupDropLocation(_ travelOrder: TravelOrder){
        
        
        if(travelOrder.OrderPickupLoc != nil && travelOrder.OrderPickupPlace != nil){
            self.lblPickupLocation.text = travelOrder.OrderPickupPlace
            
        }else if(travelOrder.ActPickupLoc != nil && travelOrder.ActPickupPlace != nil){
             self.lblPickupLocation.text = travelOrder.ActPickupPlace
            
        }
        
        if(travelOrder.OrderDropLoc != nil && travelOrder.OrderDropPlace != nil){
            self.lblDropLocation.text = travelOrder.OrderDropPlace
            
            
        }else if(travelOrder.ActDropLoc != nil && travelOrder.ActDropPlace != nil){
            self.lblDropLocation.text = travelOrder.ActDropPlace
            
        }
        
    }
    
    func  invalidateMap(_ travelOrder: TravelOrder){
        
        var sourceLoc: CLLocationCoordinate2D?
        var destinyLoc: CLLocationCoordinate2D?
        
        if( travelOrder.OrderPickupLoc != nil){
            sourceLoc = travelOrder.OrderPickupLoc!.coordinate()
        }
        
        if( travelOrder.ActPickupLoc != nil){
            sourceLoc = travelOrder.ActPickupLoc!.coordinate()
        }
        
        if( travelOrder.OrderDropLoc != nil){
            destinyLoc = travelOrder.OrderDropLoc!.coordinate()
        }
        
        if( travelOrder.ActDropLoc != nil){
            destinyLoc = travelOrder.ActDropLoc!.coordinate()
        }
        
        self.mSourceMarker.iconView.isHidden = ( sourceLoc == nil )
        if( self.mSourceMarker.iconView.isHidden == false){
            
            self.mSourceMarker.map = self.gmsMapView
            self.mSourceMarker.position = sourceLoc!
            self.mSourceMarker.map?.selectedMarker = self.mSourceMarker
            
        }else{
            
            self.mSourceMarker.map = nil
            
        }
        
        self.mDestinyMarker.iconView.isHidden = ( destinyLoc == nil )
        if( self.mDestinyMarker.iconView.isHidden == false){
            
            self.mDestinyMarker.map = self.gmsMapView
            self.mDestinyMarker.position = destinyLoc!
            self.mDestinyMarker.map?.selectedMarker = self.mDestinyMarker
            
        }else{
            
            self.mDestinyMarker.map = nil
            
        }

        
        if( sourceLoc == nil  ||  destinyLoc == nil ){
            
                pathPolyLine?.map = nil
                
                if( sourceLoc != nil){
                    
                        let camera  = GMSCameraPosition.camera(withLatitude: sourceLoc!.latitude, longitude: sourceLoc!.longitude, zoom: 15)
                        self.gmsMapView.moveCamera(GMSCameraUpdate.setCamera(camera))
                        
                }else  if( destinyLoc != nil){
                    
                        let camera  = GMSCameraPosition.camera(withLatitude: destinyLoc!.latitude, longitude: destinyLoc!.longitude, zoom: 15)
                        self.gmsMapView.moveCamera(GMSCameraUpdate.setCamera(camera))
                }
            
        }else{
        

        GoogleMapUtil.getDistance(sourceLoc!, destLocation: destinyLoc!) { (routes) in
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
                    
                    self.gmsMapView.moveCamera(GMSCameraUpdate.fit( GMSCoordinateBounds(path: path!), withPadding: 35.0))
                    
                }
            }
            }
        }

        
    }

    
}

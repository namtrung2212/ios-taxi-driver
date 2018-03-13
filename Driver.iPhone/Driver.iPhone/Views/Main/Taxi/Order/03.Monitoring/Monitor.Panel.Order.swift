//
//  Travel.Order.ChooseLocation.swift
//  User.iPhone
//
//  Created by Trung Dao on 5/25/16.
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

extension TravelMonitoringView{
    
    func shouldShowOrderPanel() -> Bool{
        
        let isShow : Bool = (self.CurrentOrder != nil && self.CurrentOrder!.Driver == SCONNECTING.DriverManager?.CurrentDriver!.id && (self.CurrentOrder!.IsMonitoring() ||  self.CurrentOrder!.IsStopped() ))
        
        return isShow
    }
    
    func showOrderPanel(_ show: Bool,completion: (() -> ())?){
        
        if(show){
            
                if(self.pnlOrderArea.isHidden && CurrentOrder != nil && CurrentOrder!.IsMonitoring() ){
                            
                            self.pnlOrderArea.isHidden = false
                            self.pnlButtonArea.isHidden = false
                            self.parent.view.layoutIfNeeded()
                }
                
                completion?()
            
        }else{
            
                if(self.pnlOrderArea != nil && self.pnlOrderArea.isHidden == false){
                    
                            self.pnlOrderArea.isHidden = true
                            self.pnlButtonArea.isHidden = true
                            self.parent.view.layoutIfNeeded()
                    
                }
                completion?()           
            
        }
    }
    
    
    
    func invalidateOrderPanel(_ completion: (() -> ())?){
        let isShow : Bool = shouldShowOrderPanel()
        
        if(isShow){
            
            self.pnlOrderArea.isHidden = false
            self.invalidateOrderPanelControls {
                
                    self.showOrderPanel(true) {
                        self.parent.view.layoutIfNeeded()
                        completion?()
                    }
            }
            
        }else{
            
            self.showOrderPanel(false) {
                self.pnlOrderArea.ConstraintState = self.isCollapsedOrder ? 2 : 1
                self.parent.view.layoutIfNeeded()
                completion?()
            }
            
        }
        
        
        
    }
    
    func invalidateOrderPanelControls(_ completion: (() -> ())?){
        
        self.pnlOrderArea.ConstraintState = self.isCollapsedOrder ? 2 : (self.CurrentOrder!.IsStopped() ? 3 : 1)
        self.btnCollapseOrder.setGMDIcon(self.isCollapsedOrder ? GMDType.gmdExpandLess : GMDType.gmdExpandMore, forState: UIControlState())
        
        let distance: Double = self.invalidateStatus{
            
            self.invalidatePickupDropLocation{
                
                self.invalidateMoreInfo{
                    
                    self.invalidateActualPrice{
                        
                        self.parent.view.layoutIfNeeded()
                        completion?()
                    }
                }

            }
        }
        
        self.invalidateButtonArea(distance){
            
            self.parent.view.layoutIfNeeded()
        }
        
    }
    
    func invalidateStatus(_ completion: (() -> ())?) -> Double {
        
        var strStatus : String = ""
        var distance : Double = 0
        if(self.CurrentOrder != nil){
            
            if(self.CurrentOrder!.IsWaitingForDriver()){
                strStatus = "Đang đến điểm đón khách."
                
                
                if( SCONNECTING.DriverManager?.CurrentDriver?.id == self.CurrentOrder!.Driver && self.CurrentOrder!.OrderPickupLoc != nil && SCLocationManager.currentLocation!.Location != nil){
                    
                    let locationObj = CLLocation(latitude: self.CurrentOrder!.OrderPickupLoc!.coordinate().latitude, longitude: self.CurrentOrder!.OrderPickupLoc!.coordinate().longitude)
                    distance = SCLocationManager.currentLocation!.Location!.distance(from: locationObj)
                    if(distance >= 1000){
                        strStatus = NSString(format:"Khoảng cách %.1f Km", distance/1000 ) as String
                        strStatus = "Đang đón khách. \(strStatus)"
                        
                    }else if(distance > 50) {
                        strStatus = NSString(format:"Khoảng cách %.0f m", distance ) as String
                        strStatus = "Đang đón khách. \(strStatus)"
                        
                    }else{
                        strStatus = "Đã đến điểm hẹn."
                        
                        if( strStatus.uppercased() != self.lblStatus.text){
                            
                            let alert = UIAlertController(title: "Đã đến đúng điểm hẹn.", message: "\(self.CurrentOrder!.OrderPickupPlace!) \r \n \n Khách đã nhận được tin báo.", preferredStyle: UIAlertControllerStyle.alert)
                            
                            alert.addAction(UIAlertAction(title: "Chờ khách", style: .default, handler: { (action: UIAlertAction!) in
                                self.invalidateUI(nil)
                            }))
                            
                            AppDelegate.mainWindow?.taxiViewCtrl.present(alert, animated: true, completion: nil)
                            
                        }
                        
                    }
                    
                }
                
            }else if(self.CurrentOrder!.IsOnTheWay()){
                
                strStatus = "Đang trong hành trình. "
                
            }else if(self.CurrentOrder!.IsVoidedByDriver()){
                
                strStatus = "Tài xế đã huỷ hành trình. "
                
            }else if(self.CurrentOrder!.IsVoidedByUser()){
                
                strStatus = "Khách đã huỷ hành trình. "
                
            }else if(self.CurrentOrder!.IsFinishedNotYetPaid()){
                
                strStatus = "Đã đến nơi. Chưa thanh toán."
                
            }else if(self.CurrentOrder!.IsFinishedAndPaid()){
                
                strStatus = "Đã thanh toán."
                
            }
        }
        
        self.lblStatus.text = strStatus.uppercased()
        
        completion?()
        
        return distance
    }
    
    func invalidateActualPrice(_ completion: (() -> ())?){
        
        var distance : Double? = nil
        
        if(self.CurrentOrder != nil && self.CurrentOrder!.IsOnTheWay() && self.CurrentOrder!.ActPickupLoc != nil){
            
            if( SCONNECTING.DriverManager?.CurrentDriver?.id == self.CurrentOrder!.Driver && self.CurrentOrder!.ActPickupLoc != nil){
                distance = SCONNECTING.TaxiManager!.travelDistanceFromBaseLocation()
            }
        }
        
        self.updatePriceText(distance){
            
            self.lblCurrentPrice.ConstraintState = self.isCollapsedOrder ? 2 : 1
            completion?()
            
        }
        
    }
    
    func updatePriceText(_ distance: Double?,completion: (() -> ())?){
        
        if(self.CurrentOrder!.IsOnTheWay() || self.CurrentOrder!.IsStopped()){
            
            if(distance != nil && distance! >= 0 && abs(distance! - self.CurrentOrder!.ActDistance ) > 50 && self.CurrentOrder!.IsOnTheWay()){
                
                TravelOrderController.CalculateOrderPrice((SCONNECTING.DriverManager?.CurrentDriver?.id)! , distance: distance! , currency: self.CurrentOrder!.Currency, serverHandler: { (price) in
                    self.lblCurrentPrice.text = (price != nil && price! >= 0) ? price!.toCurrency(self.CurrentOrder!.Currency, country: nil) :  self.lblCurrentPrice.text
                    self.lblCurrentPrice.isHidden = false
                    
                    self.CurrentOrder!.ActDistance = distance!
                    self.CurrentOrder!.ActPrice = (price != nil && price! > 0) ? price! : 0
                    
                    completion?()
                })
                
            }else if(self.CurrentOrder!.IsStopped()){
                
                self.lblCurrentPrice.text = (self.CurrentOrder!.ActPrice >= 0) ? self.CurrentOrder!.ActPrice.toCurrency(self.CurrentOrder!.Currency, country: nil) :  ""
                self.lblCurrentPrice.isHidden = false
                completion?()
                
            }else{
                completion?()
            }
            
            
        }else{
            
            self.lblCurrentPrice.text = ""
            self.lblCurrentPrice.isHidden = true
            completion?()
            
        }
        
    }
    
    func invalidateMoreInfo(_ completion: (() -> ())?){
        
        if(self.CurrentOrder != nil && self.CurrentOrder!.IsWaitingForDriver()){
            
            self.lblMoreInfo.isHidden = ( self.CurrentOrder!.OrderDropLoc == nil ) || ( self.CurrentOrder!.OrderPickupLoc == nil )
            
            if(self.lblMoreInfo.isHidden == false){
                
                var strPlanning: String?
                
                if(self.CurrentOrder!.OrderDistance > 0 && self.CurrentOrder!.OrderDuration > 0){
                    
                    let strDistance = NSString(format:"%.1f Km", self.CurrentOrder!.OrderDistance/1000 ) as String
                    let hours =  Int(self.CurrentOrder!.OrderDuration / 3600)
                    let minutes =  Int(round((self.CurrentOrder!.OrderDuration.truncatingRemainder(dividingBy: 3600)) / 60))
                    var strDuration = ""
                    if( hours > 0){
                        strDuration =  NSString(format:"%d giờ %d phút", hours, minutes ) as String
                    }else{
                        strDuration =  NSString(format:"%d phút", minutes ) as String
                        
                    }
                    strPlanning = strDistance + " - " + strDuration
                    
                    if(self.CurrentOrder!.OrderPrice > 0){
                        let strPrice = self.CurrentOrder!.OrderPrice.toCurrency(self.CurrentOrder!.Currency, country: nil)
                        if(strPrice != nil){
                            strPlanning = (strPlanning == nil) ? strPrice : (strPlanning! + " - " + strPrice!)
                        }
                    }
                }
                
                if(strPlanning != nil){
                    strPlanning = "Dự kiến : \(strPlanning!)"
                }else{
                    strPlanning = ""
                }
                self.lblMoreInfo.text = strPlanning
                
            }
            
        }else if(self.CurrentOrder != nil &&  self.CurrentOrder!.IsStopped()){
            
            
            self.lblMoreInfo.isHidden = false
            
            var strActual: String?
            
            if(self.CurrentOrder!.ActPickupLoc != nil && self.CurrentOrder!.ActDropLoc != nil){
                
                let actPickupLoc = CLLocation(latitude: self.CurrentOrder!.ActPickupLoc!.lat , longitude: self.CurrentOrder!.ActPickupLoc!.long)
                let actDropLoc = CLLocation(latitude: self.CurrentOrder!.ActDropLoc!.lat , longitude: self.CurrentOrder!.ActDropLoc!.long)
                let distance = self.CurrentOrder!.ActDistance > 0 ? self.CurrentOrder!.ActDistance :  actDropLoc.distance(from: actPickupLoc)
                
                let strDistance = NSString(format:"%.1f Km", distance/1000 ) as String
                let timeInterval = self.CurrentOrder!.ActDropTime!.timeIntervalSince(self.CurrentOrder!.ActPickupTime!)
                let hours =  Int(timeInterval / 3600)
                let minutes =  Int(round((timeInterval.truncatingRemainder(dividingBy: 3600)) / 60))
                
                var strDuration = ""
                if( hours > 0){
                    strDuration =  NSString(format:"%d giờ %d phút", hours, minutes ) as String
                }else{
                    strDuration =  NSString(format:"%d phút", minutes ) as String
                    
                }
                strActual = strDistance + " - " + strDuration
                
            }
            
            
            if(strActual != nil){
                strActual = "Thực tế : \(strActual!)"
            }else{
                strActual = ""
            }
            self.lblMoreInfo.text = strActual
            
        }else if(self.CurrentOrder != nil &&  self.CurrentOrder!.IsOnTheWay()){
            
            self.lblMoreInfo.text = ""
            
        }
        
        self.lblMoreInfo.showControl = !self.isCollapsedOrder && self.lblMoreInfo.text != ""
        completion?()
    }
    
    func invalidatePickupDropLocation(_ completion: (() -> ())?){
        
        self.lblPickupLocation.showControl = !self.isCollapsedOrder
        self.imgPickupLocationBG.showControl = !self.isCollapsedOrder
        self.btnPickupIcon.showControl = !self.isCollapsedOrder
        
        if(self.CurrentOrder!.OrderPickupLoc != nil && self.CurrentOrder!.OrderPickupPlace != nil){
            self.lblPickupLocation.setTitle(self.CurrentOrder!.OrderPickupPlace, for: UIControlState())
            
        }else if(self.CurrentOrder!.ActPickupLoc != nil && self.CurrentOrder!.ActPickupPlace != nil){
            self.lblPickupLocation.setTitle(self.CurrentOrder!.ActPickupPlace, for: UIControlState())
            
        }
        
        self.btnDropIcon.showControl = !self.isCollapsedOrder
        self.lblDropLocation.showControl = !self.isCollapsedOrder
        self.imgDropLocationBG.showControl = !self.isCollapsedOrder
        if(self.CurrentOrder!.OrderDropLoc != nil && self.CurrentOrder!.OrderDropPlace != nil){
            self.lblDropLocation.setTitle(self.CurrentOrder!.OrderDropPlace, for: UIControlState())
            
        }else if(self.CurrentOrder!.ActDropLoc != nil && self.CurrentOrder!.ActDropPlace != nil){
            self.lblDropLocation.setTitle(self.CurrentOrder!.ActDropPlace, for: UIControlState())
            
        }
        completion?()
        
    }
    
    func invalidateButtonArea(_ distance: Double,completion: (() -> ())?){
        
        let scrRect = UIScreen.main.bounds
        let imgSmallOrangeButton = ImageHelper.resize(UIImage(named: "SmallOrangeButton.png")!, newWidth: scrRect.width/2)
        let imgOrangeButton = ImageHelper.resize(UIImage(named: "OrangeButton.png")!, newWidth: scrRect.width/2)
        
        
        self.btnVoid.ConstraintState = (self.CurrentOrder!.IsOnTheWay() ||  (self.CurrentOrder!.IsWaitingForDriver() && distance <= 50)) ? 2 : 1
        self.btnVoid.showControl = self.CurrentOrder!.IsMonitoring()
        self.btnVoid.setBackgroundImage(self.btnVoid.ConstraintState == 2 ? imgSmallOrangeButton : imgOrangeButton, for: UIControlState())
    
        self.btnTripStart.isHidden = !(self.CurrentOrder!.IsWaitingForDriver() && distance <= 50)
        self.btnTripFinish.isHidden = !(self.CurrentOrder!.IsOnTheWay())
        self.btnDone.isHidden = !(self.CurrentOrder!.IsFinishedNotYetPaid())
        self.btnCashPayment.isHidden = !(self.CurrentOrder!.IsFinishedNotYetPaid())
        
        self.pnlButtonArea.showControl = !self.isCollapsedOrder && (!self.btnVoid.isHidden || !self.btnTripStart.isHidden || !self.btnTripFinish.isHidden ||  !self.btnCashPayment.isHidden)
        completion?()
    }
        
}





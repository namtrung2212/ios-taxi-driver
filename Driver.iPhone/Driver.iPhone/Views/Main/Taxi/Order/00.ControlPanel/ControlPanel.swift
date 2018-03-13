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

private var  ControlPanelKey1 : UInt8 = 123

extension TravelOrderScreen {
    
    public var controlPanelView: ControlPanelView {
        get {return ExHelper.getter(self, key: &ControlPanelKey1){ return ControlPanelView(parent: self) }}
        set { ExHelper.setter(self, key: &ControlPanelKey1, value: newValue) }
    }
    
    
    func initControlPanelControls(_ completion: (() -> ())?){
        
        controlPanelView.initControls(completion)
        
    }
    
    func initControlPanelLayout(_ completion: (() -> ())?){
        
        controlPanelView.initLayout(completion)
        
    }
    
    func invalidateControlPanelView(_ completion: (() -> ())?){
        controlPanelView.invalidate(completion)
    }
    
}


open class ControlPanelView{
    
    var parent: TravelOrderScreen

    var CurrentOrder: TravelOrder? {
        
        get {
            return self.parent.CurrentOrder
        }
    }
    
    
    var CurretDriverStatus: DriverStatus! {
        
        get {
            return self.parent.CurrentDriverStatus
        }
    }

    
    
    var isCollapsedOrder: Bool = false
    var pnlControlArea: UIView!
    var btnCollapseOrder: UIButton!
    var btnReady: UIButton!
    var imgOrangeButton: UIImage?
    var imgBlueButton : UIImage?
    
    public init(parent: TravelOrderScreen){
        
        self.parent = parent
    }
    
    
    
    func showOrderPanel(_ show: Bool,completion: (() -> ())?){
        
        self.parent.view.bringSubview(toFront: self.pnlControlArea)
        pnlControlArea.isUserInteractionEnabled = true

        if(show){
            
            if(self.pnlControlArea != nil && self.pnlControlArea.isHidden){
                
                        self.parent.view.bringSubview(toFront: self.pnlControlArea)
                        self.pnlControlArea.isHidden = false
                        self.parent.view.layoutIfNeeded()
                        completion?()                
                
            }else{
                completion?()
            }
            
        }else{
            if(self.pnlControlArea != nil && self.pnlControlArea.isHidden == false){
               
                        self.pnlControlArea.isHidden = true
                        self.parent.view.layoutIfNeeded()
                        completion?()
            }else{
                completion?()
            }
            
        }
    }
    
    
    func invalidate(_ completion: (() -> ())?){
        
        SCONNECTING.DriverManager?.invalidateStatus({ 
            self.invalidateUI({
                completion?()
            })
        })
        
    }
    
    func invalidateUI(_ completion: (() -> ())?){
        
        self.invalidatePanel{
                completion?()
        }
        
    }
    
    func invalidatePanel(_ completion: (() -> ())?){
        
        
        let isShow : Bool = (self.CurrentOrder == nil )
        
        
            self.showOrderPanel(isShow) {
                if(isShow){
                    self.invalidateReadyButton{
                     
                    }
                }
                self.parent.view.layoutIfNeeded()
                completion?()

            }
        
        
    }
    
    
    
    func invalidateReadyButton(_ completion: (() -> ())?){
  
        if(self.btnReady != nil){
            self.btnReady.isHidden = (self.CurretDriverStatus == nil || self.CurretDriverStatus!.Car == nil)
            self.btnReady.setTitle(self.CurretDriverStatus != nil && self.CurretDriverStatus.IsReady == true ? "ĐANG RÃNH" : "ĐANG BẬN" , for: UIControlState())
            self.btnReady.setBackgroundImage(self.CurretDriverStatus != nil && self.CurretDriverStatus.IsReady == true ? imgBlueButton :  imgOrangeButton, for: UIControlState())
        }
    }
    
}





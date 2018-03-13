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

private var  MonitoringKey1 : UInt8 = 142

extension TravelOrderScreen {
    
    public var monitoringView: TravelMonitoringView {
        get {return ExHelper.getter(self, key: &MonitoringKey1){ return TravelMonitoringView(parent: self) }}
        set { ExHelper.setter(self, key: &MonitoringKey1, value: newValue) }
    }
    
    
    func initOrderMonitoringControls(_ completion: (() -> ())?){
        
        monitoringView.initControls(completion)
        
    }
    
    func initOrderMonitoringLayout(_ completion: (() -> ())?){
        
        monitoringView.initLayout(completion)
        
    }

    func invalidateOrderMonitoringView(_ completion: (() -> ())?){
        monitoringView.invalidate(completion)
    }
    
}


open class TravelMonitoringView{
    
    var parent: TravelOrderScreen
    
    var CurrentOrder: TravelOrder? {
        
        get {
            return self.parent.CurrentOrder
        }
    }
    
    var user: User?
    var userStatus: UserStatus?
    
    //------- Top User Profile Area -----------
    var isCollapsedProfile: Bool = true
    var pnlUserProfileArea: UIView!
    var btnCollapseProfile: UIButton!
    
    var imgAvatar: UIImageView!
    var btnAvatar: UIButton!
    var redCircle : UIImageView!
    var lblMessageNo: UILabel!
    var lblLastMessage: UILabel!
    
    var lblUserName: UILabel!
    
    var chattingView: TravelChattingView!
    
    //------- Order Area -----------
    var isCollapsedOrder: Bool = false
    var pnlOrderArea: UIView!
    var btnCollapseOrder: UIButton!
    
    var lblStatus: UILabel!
    var lblCurrentPrice: UILabel!
    
    var btnPickupIcon: UIButton!
    var lblPickupLocation: UIButton!
    var imgPickupLocationBG: UIImageView!
    
    var btnDropIcon: UIButton!
    var lblDropLocation: UIButton!
    var imgDropLocationBG: UIImageView!
    
    var lblMoreInfo: UILabel!
    
    //------- Bottom Button Area -----------
    var pnlButtonArea: UIView!
    var btnVoid: UIButton!
    var btnTripStart: UIButton!
    var btnTripFinish: UIButton!
    var btnDone: UIButton!
    var btnCashPayment: UIButton!
    
    public init(parent: TravelOrderScreen){
        
        self.parent = parent
    }
    
    
    func invalidate(_ completion: (() -> ())?){
        
        if(self.CurrentOrder != nil && self.CurrentOrder!.User != nil && ( self.user == nil || self.user!.id != self.CurrentOrder!.User)){
            ModelController<User>.getById(self.CurrentOrder!.User!, clientHandler: nil, serverHandler: { (item) in
                self.user = item!.copy() as! User
                
                ModelController<UserStatus>.getOneByField("User", value: self.CurrentOrder!.User!, isGetNow: true, clientHandler: nil, serverHandler: { (item) in
                    
                    self.userStatus = item
                    self.invalidateUI(completion)
                    
                })
            })
            
            
            
            
        }else{
            
            self.invalidateUI(completion)
            
        }
        
        
        
    }
    
    func invalidateUI(_ completion: (() -> ())?){
        
        self.invalidateOrderPanel{
            self.invalidateUserProfilePanel (completion)
        }
        
    }

}





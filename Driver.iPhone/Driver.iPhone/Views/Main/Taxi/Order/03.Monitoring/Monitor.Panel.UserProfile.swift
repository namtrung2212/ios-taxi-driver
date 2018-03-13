//
//  Main.Travel.Monitor.Panel.UserProfile.swift
//  Driver.iPhone
//
//  Created by Trung Dao on 7/11/16.
//  Copyright © 2016 SCONNECTING. All rights reserved.
//

import Foundation
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
    
    func showUserProfilePanel(_ show: Bool,completion: ((_ changed : Bool) -> ())?){
        
        if(show){
            
            if(self.pnlUserProfileArea.isHidden ){
                
                        self.pnlUserProfileArea.isHidden = false
                        self.invalidateAvatar{
                            
                        }
                        self.parent.view.layoutIfNeeded()
                
                        completion?(true)
                
            }else{
                completion?(false)
            }
            
        }else{
           
            if(self.pnlUserProfileArea.isHidden == false){
                
                        self.pnlUserProfileArea.isHidden = true
                        self.invalidateAvatar{
                            
                        }
                    self.parent.view.layoutIfNeeded()
                    completion?(true)
                
            }else{
                completion?(false)
                
            }
            
        }
    }
    
    func shouldShowUserProfilePanel() -> Bool{
        
        let isShow : Bool = (self.CurrentOrder != nil) && (  self.CurrentOrder!.IsMonitoring() ||  self.CurrentOrder!.IsFinishedNotYetPaid() || (self.CurrentOrder!.IsFinishedAndPaid() && self.CurrentOrder!.ActDropTime != nil && self.CurrentOrder!.ActDropTime!.isExpired(60*12) == false) )
        
        return isShow
    }
    
    func invalidateUserProfilePanel(_ completion: (() -> ())?){
        
      if(shouldShowUserProfilePanel()){
        
            self.showUserProfilePanel(true) {changed in
                
                self.invalidateProfilePanelControls{
                    

                        self.pnlUserProfileArea.isUserInteractionEnabled = true
                        self.parent.view.bringSubview(toFront: self.pnlUserProfileArea)
                        self.parent.view.bringSubview(toFront: self.btnAvatar)
                        self.parent.view.bringSubview(toFront: self.redCircle)
                        self.parent.view.bringSubview(toFront: self.lblMessageNo)
                    
                        completion?()
                }
            }
            
        }else{
            
            self.showUserProfilePanel(false) {changed in
                completion?()
            }
            
        }
        
    }
    
    
    func invalidateAvatar(_ completion: (() -> ())?){
        
        let url = self.userStatus != nil ? SClientData.ServerURL + "/avatar/user/\(self.userStatus!.User!)" : ""
        
        self.imgAvatar.af_setImageWithURL(
            URL(string: url)!,
            placeholderImage: ImageHelper.resize(UIImage(named: "Avatar.png")!, newWidth: 60),
            filter: AspectScaledToFillSizeWithRoundedCornersFilter(size:  CGSize(width: 60,height: 60), radius: 24),
            imageTransition: .crossDissolve(0.2), completion: { (result) in
                if(result.result.isSuccess){
                    self.btnAvatar.setImage(result.result.value!, for: UIControlState())
                }
            }
        )
        
        self.btnAvatar.setImage(self.imgAvatar.image, for: UIControlState())
        self.btnAvatar.isHidden = !shouldShowUserProfilePanel()
        
        completion?()
    }

    
    
    func increaseMessageNo(_ increase : Int?, completion: ((_ number : Int) -> ())?){
        
        if(increase == nil) {
            invalidateMessageNo( nil,completion : completion)
            return
        }
        
        let strNo = lblMessageNo.text
        
        if(strNo != nil && strNo!.isEmpty == false) {
            
            var count : Int? = Int(strNo!)
            if(count != nil){
                count! += increase!
            }
            
            invalidateMessageNo(count, completion : completion)
            
        }else {
            
            invalidateMessageNo(nil, completion : completion);
        }
        
        
    }
    
   public func invalidateMessageNo(_ count : Int? , completion: ((_ number : Int) -> ())?){
        
        if(count != nil){
            
            self.redCircle.isHidden = !self.shouldShowUserProfilePanel()  || !self.isCollapsedProfile || count! <= 0
            self.lblMessageNo.isHidden = self.redCircle.isHidden
            self.lblMessageNo.text = String(count!)
            completion?(count!)
            return

        }
        
        TravelOrderController.CountNotYetViewedMessageByDriver(self.CurrentOrder!.id!) { (number) in
            
            self.redCircle.isHidden = !self.shouldShowUserProfilePanel()  || !self.isCollapsedProfile || number <= 0
            self.lblMessageNo.isHidden = self.redCircle.isHidden
            self.lblMessageNo.text = String(number)
          
            completion?(number : number)
            
        }
    }
    
  public  func invalidateLastMessage(_ message : String?, completion: (() -> ())?){
        
        self.lblLastMessage.isHidden = !self.shouldShowUserProfilePanel()  || !self.isCollapsedProfile
        
        if( message != nil){
            self.lblLastMessage.text = String(message!)
            self.lblUserName.ConstraintState =  ( self.lblLastMessage.text == nil || self.lblLastMessage.text!.isEmpty) ? 1 : 2
            completion?()
            return
        }
        
        if(self.chattingView != nil && self.chattingView.chattingTable != nil && self.chattingView.chattingTable.chatData.count > 0){
            
                    let lastObj = self.chattingView.chattingTable.chatData.sorted(by: { (item1, item2) -> Bool in
                        
                        return   item1.1.cellObject!.createdAt!.compare(item2.1.cellObject!.createdAt!) == .orderedAscending
                        
                    }).last.map { (newItem) -> TravelChattingObject in
                        return newItem.1
                    }
                    
                    
                    if( lastObj != nil && lastObj!.cellObject != nil && lastObj!.cellObject!.IsUser && lastObj!.cellObject!.Content != nil ){
                        self.lblLastMessage.text = String(lastObj!.cellObject!.Content!)
                    }else{
                        self.lblLastMessage.text = ""
                    }
                    self.lblUserName.ConstraintState =  ( self.lblLastMessage.text == nil || self.lblLastMessage.text!.isEmpty) ? 1 : 2
            
                    completion?()
        }else{
         
                TravelOrderController.GetLastChattingMessage(self.CurrentOrder!.id!, completion: { (chatting) in
                  
                    if(chatting != nil && chatting!.IsUser && chatting!.Content != nil){
                        self.lblLastMessage.text = String(chatting!.Content!)
                    }else{
                        self.lblLastMessage.text = ""
                    }
                    
                    self.lblUserName.ConstraintState =  ( self.lblLastMessage.text == nil || self.lblLastMessage.text!.isEmpty) ? 1 : 2
                    
                    completion?()
                })
        }

        
    }


    func invalidateProfilePanelControls(_ completion: (() -> ())?) {
        
        self.invalidateAvatar{
        }
        self.btnCollapseProfile.setGMDIcon(self.isCollapsedProfile ? GMDType.gmdExpandMore : GMDType.gmdExpandLess, forState: UIControlState())
        
        self.lblUserName.text = self.user != nil ? "\(self.user!.Name!.uppercased())" : ""        
        
        self.chattingView!.invalidate(!self.isCollapsedProfile){ changed in
            
            self.invalidateMessageNo(nil){ number in
                
                self.invalidateLastMessage( number <= 0 ? "" : nil){
                    completion?()
                }
                
            }

        }

        
        self.pnlUserProfileArea.ConstraintState = self.isCollapsedProfile ? 1 : 2
        self.pnlUserProfileArea.layoutIfNeeded()
        
        
    }
    
    
}





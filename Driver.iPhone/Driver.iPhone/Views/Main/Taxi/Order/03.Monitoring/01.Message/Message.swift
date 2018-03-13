//
//  Order.Travel.Message.swift
//  User.iPhone
//
//  Created by Trung Dao on 5/26/16.
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
import DTTableViewManager
import DTModelStorage
import SClientModelControllers
import AlamofireImage
import RealmSwift




open class TravelChattingView{
    
    var parent: TravelOrderScreen!
    var chattingTable : TravelChattingTable!
    var chattingInputVIew : ChattingInputView!
    var pnlContentArea: UIView!
    
    var contentBottom: NSLayoutConstraint!
    

    var CurrentOrder: TravelOrder! {
        
        get {
            return self.parent.CurrentOrder
        }
    }
    
    
    public init(parent: TravelOrderScreen){
        
        self.parent = parent
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func showChattingPanel(_ show: Bool,completionShow: ((_ changed : Bool) -> ())?){
        
        if(show){
            
            let scrRect = UIScreen.main.bounds
            
            if(self.pnlContentArea.isHidden ){
                
          
                        self.pnlContentArea.isHidden = false
                        self.parent.view.bringSubview(toFront: self.pnlContentArea)
                        self.parent.view.layoutIfNeeded()
                completionShow?(true)
                
            }else{
                completionShow?(false)
            }
            
        }else{
            
            self.chattingInputVIew.txtMessage.endEditing(true)
            if(self.pnlContentArea.isHidden == false){
                
                        self.pnlContentArea.isHidden = true
                        self.parent.view.layoutIfNeeded()
                        completionShow?(true)
               
                
            }else{
                completionShow?(false)
            }
            
        }
    }
    
    
    
    func invalidate(_ isShow: Bool, completion: ((_ changed : Bool) -> ())?){
        
        
        self.showChattingPanel(isShow) {changed in
            
            if( isShow ){
                
                self.chattingTable.refreshList{
                    
                    completion?(changed)
                }
                
            }else{
            
                    completion?(changed)
            }
        }
        
        
        
    }
    
    func setReadAll(){
        
        TravelOrderController.SetAllMessageToViewedByDriver(self.CurrentOrder!.id!, completion : nil)
        
        self.parent.monitoringView.invalidateMessageNo(0){ number in
            
            self.parent.monitoringView.invalidateLastMessage(""){
            }
            
        }

    }
    
}

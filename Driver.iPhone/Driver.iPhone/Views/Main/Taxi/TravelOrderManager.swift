//
//  BOOKTAXIswift
//  BOOKTAXI
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

enum OrderPhase {
    
}
open class TravelOrderManager : NSObject,TaxiSocketDelegate,ChatSocketDelegate {
    
    open var currentOrder: TravelOrder?
    open var locationsPoints: [CLLocationCoordinate2D] = []
    
    var checkOrderStatusTimer: Timer? = nil
    
    public override init(){
        
        currentOrder = nil
    }
    
    public convenience init(order: TravelOrder){
        
        self.init()
        
        currentOrder = order
        
    }
    
    
    func invalidate(_ orderId: String,updateUI: Bool,completion: (() -> ())?){
        
        ModelController<TravelOrder>.queryServerById(orderId) { (item) in
            if( item != nil){
                
                self.currentOrder = item?.copy() as? TravelOrder
                
                if(updateUI){
                    AppDelegate.mainWindow?.taxiViewCtrl.invalidateUI{
                        completion?()
                    }
                }else{
                    completion?()
                }
                
            }
        }
        
    }
    
    
    func invalidate(_ updateUI: Bool, completion: (() -> ())?){
        
        if(self.currentOrder != nil && self.currentOrder!.id != nil ) {
            
            ModelController<TravelOrder>.queryServerById(self.currentOrder!.id!) { (item) in
                
                if( item != nil){
                    
                    self.currentOrder = item?.copy() as? TravelOrder
                    
                    if(updateUI){
                        
                        self.invalidateUI(){
                            completion?()
                        }
                        
                    }else{
                        completion?()
                    }
                    
                }
            }
            
        }else{
            
            if(updateUI){
                AppDelegate.mainWindow?.taxiViewCtrl.invalidateUI(){
                    completion?()
                }
            }else{
                completion?()
            }
        }
        
        
    }
    
    func invalidateUI( _ completion: (() -> ())?){
        
        AppDelegate.mainWindow?.taxiViewCtrl.invalidateUI() {
            
            completion?()
        }
        
        
        self.startCheckStatusTimer(20)
        
    }
    
    func reset(_ updateUI: Bool, completion: (() -> ())?){
        
        self.reset(nil,updateUI: updateUI){
            completion?()
        }
        
    }
    
    func reset(_ order: TravelOrder?,updateUI: Bool, completion: (() -> ())?){
        
        currentOrder = order
        
        self.invalidate(updateUI){
            completion?()
        }
        
    }

    
    open func Start(_ completion: (() -> ())?){
        
        ModelController<Company>.getAll(nil, serverHandler: nil)
        ModelController<Team>.getAll(nil, serverHandler: nil)
        
        ModelController<TaxiAveragePrice>.getAll(nil, serverHandler: nil)
        ModelController<TaxiPrice>.getAll(nil, serverHandler: nil)
        ModelController<TaxiDiscount>.getAll(nil, serverHandler: nil)
        
        ModelController<ExchangeRate>.getAll(nil, serverHandler: nil)
        
        SCONNECTING.NotificationManager?.taxiSocket.delegate = self
        SCONNECTING.NotificationManager?.chatSocket.delegate = self
        
        SCONNECTING.NotificationManager?.taxiSocket.connect {
            
            SCONNECTING.NotificationManager?.chatSocket.connect {
                completion?()
            }

        }
    }
    
    
    func startCheckStatusTimer(_ seconds : TimeInterval){
        
        if(self.checkOrderStatusTimer != nil){
            self.checkOrderStatusTimer!.invalidate()
        }else{
            self.checkOrderStatusTimer = Timer.scheduledTimer(timeInterval: seconds, target: self, selector: #selector(TravelOrderManager.runCheckOrderStatusTask), userInfo: nil, repeats: true)
        }
    }
    
    func runCheckOrderStatusTask(){
        
        self.invalidate(true) {
            
            // if(self.currentOrder!.Status == OrderStatus.DriverAccepted){
            //    self.invalidate(false, updateUI: true,completion : nil)
            // }
        }
        
    }

    
}

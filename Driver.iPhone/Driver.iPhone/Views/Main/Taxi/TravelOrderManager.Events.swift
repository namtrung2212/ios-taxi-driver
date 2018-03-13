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

extension TravelOrderManager {
    
    
    
    public func onTaxiSocketLogged(_ data : [AnyObject]){
        
    }
    
    public func onChatSocketLogged(_ data : [AnyObject]){
        
    }
    

    
    public func onCarUpdateLocation(_ data : [AnyObject]){
        
        let arrData = data[0] as! [String: AnyObject]
        
        let userId = arrData["UserID"] as! String
        let carId = arrData["CarID"] as! String

        let driverId = arrData["DriverID"] as! String
        let orderId = arrData["OrderID"] as! String
       
        let latitude = arrData["latitude"] as! Double
        let longitude = arrData["longitude"] as! Double
        let degree = arrData["degree"] as! Double
        
        AppDelegate.mainWindow?.taxiViewCtrl.mapMarkerManager.invalidateCar(driverId, latitude: latitude, longitude: longitude, degree: degree,hideOther: true)
        AppDelegate.mainWindow?.taxiViewCtrl.mapMarkerManager.currentCar?.moveToCarLocation()

        
    }
    

    
    public func onUserViewDriverProfile(_ data : [AnyObject]){
        
        let refreshAlert = UIAlertController(title: "Alert", message: "User viewed your profile", preferredStyle: UIAlertControllerStyle.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            print("Handle Ok logic here")
        }))
        
        AppDelegate.mainWindow?.taxiViewCtrl.present(refreshAlert, animated: true, completion: nil)
    }

    
    public func onUserRequestTaxi(_ data : [AnyObject]){
        
        let arrData = data[0] as! [String: AnyObject]
        
        let userId = arrData["UserID"] as! String
        let driverId = arrData["DriverID"] as! String
        let orderId = arrData["OrderID"] as! String
        
        if(driverId == SCONNECTING.DriverManager?.CurrentDriver!.id!){
            
            ModelController<TravelOrder>.queryServerById(orderId) { (item) in
                if(item != nil){
                    
                    
                    let alert = UIAlertController(title: "Khách đón tại", message: " \( item?.OrderPickupPlace == nil ? "" : (item?.OrderPickupPlace)!). \r\n \n Tài xế có muốn đón khách không?", preferredStyle: UIAlertControllerStyle.alert)
                    
                    alert.addAction(UIAlertAction(title: "Có", style: .default, handler: { (action: UIAlertAction!) in

                        self.acceptRequest(item!, completion: { (item) in
                            if(item != nil){
                                
                                SCONNECTING.DriverManager?.changeReadyStatus({ (status) in
                                    self.reset(item!, updateUI: true, completion: nil)
                                })
                            }
                        })

                    }))
                    
                    alert.addAction(UIAlertAction(title: "Không", style: .cancel, handler: { (action: UIAlertAction!) in

                        self.rejectRequest(item!, completion: { (item) in
                                                    
                        })
                        
                        self.reset(true, completion: nil)
                        
                    }))
                    
                    AppDelegate.mainWindow?.taxiViewCtrl.present(alert, animated: true, completion: nil)
                    
                    
                }
            }
        }
    }
    
    public func onUserCancelRequest(_ data : [AnyObject]){
        
    }
    
    
    public func onUserAcceptBidding(_ data : [AnyObject]){
        
        let arrData = data[0] as! [String: AnyObject]
        
        let userId = arrData["UserID"] as! String
        let driverId = arrData["DriverID"] as! String
        let orderId = arrData["OrderID"] as! String
        
        if(driverId == SCONNECTING.DriverManager?.CurrentDriver!.id!){
            
            ModelController<TravelOrder>.queryServerById(orderId) { (item) in
                if(item != nil && item!.Status ==  OrderStatus.BiddingAccepted && item!.Driver == SCONNECTING.DriverManager?.CurrentDriver!.id!){
                    
                    let alert = UIAlertController(title: "Xác nhận đón trễ", message: "Khách hàng đồng ý đón tại địa chỉ : \r\n \n \(item?.OrderPickupPlace == nil ? "" : (item?.OrderPickupPlace)!) \r\n vào lúc \(item!.getPickupTimeString())", preferredStyle: UIAlertControllerStyle.alert)
                    
                    alert.addAction(UIAlertAction(title: "Xác nhận", style: .default, handler: { (action: UIAlertAction!) in
                       
                        self.acceptRequest(item!, completion: { (item) in
                            
                            if( self.currentOrder == nil){
                                self.reset(item, updateUI: true, completion: nil)
                                
                            }
                            
                        })
                        
                    }))
                    
                    alert.addAction(UIAlertAction(title: "Từ chối", style: .default, handler: { (action: UIAlertAction!) in
                        self.rejectRequest(item!, completion: { (item) in
                            
                        })
                        
                    }))
                    
                    
                    AppDelegate.mainWindow?.taxiViewCtrl.present(alert, animated: true, completion: nil)
                    
                    
                }
            }
        }
    }
    
    
    public func onUserCancelBidding(_ data : [AnyObject]){
        
    }
    
    
    public func onUserVoidedBfPickup(_ data : [AnyObject]){
        
        let arrData = data[0] as! [String: AnyObject]
        
        let userId = arrData["UserID"] as! String
        let driverId = arrData["DriverID"] as! String
        let orderId = arrData["OrderID"] as! String
        
        if(driverId == SCONNECTING.DriverManager?.CurrentDriver!.id!){
            
                ModelController<TravelOrder>.queryServerById(orderId) { (item) in
                    if(item != nil && item!.Status ==  OrderStatus.VoidedBfPickupByUser){
                        
                        self.reset(true, completion: nil)
                        
                        let alert = UIAlertController(title: "Khách hủy đón", message: "Khách hủy đón tại địa chỉ : \r\n \n \(item?.OrderPickupPlace == nil ? "" : (item?.OrderPickupPlace)!)", preferredStyle: UIAlertControllerStyle.alert)
                        
                        alert.addAction(UIAlertAction(title: "Đồng ý", style: .default, handler: { (action: UIAlertAction!) in
                            
                                    SCONNECTING.DriverManager?.changeReadyStatus({ (status) in
                                        AppDelegate.mainWindow?.taxiViewCtrl.controlPanelView.invalidateReadyButton(nil)
                                    })
                            
                            
                        }))
                        
                        
                        AppDelegate.mainWindow?.taxiViewCtrl.present(alert, animated: true, completion: nil)
                        
                        
                    }
                }
        }
    }
    
    
    public func onUserVoidedAfPickup(_ data : [AnyObject]){
        
        let arrData = data[0] as! [String: AnyObject]
        
        let userId = arrData["UserID"] as! String
        let driverId = arrData["DriverID"] as! String
        let orderId = arrData["OrderID"] as! String
        
        
        if(driverId == SCONNECTING.DriverManager?.CurrentDriver!.id!){

            ModelController<TravelOrder>.queryServerById(orderId) { (item) in
                if(item != nil && item!.Status ==  OrderStatus.VoidedAfPickupByUser){
                    
                    self.voidTrip(item!, completion: { (newitem) in
                        SCONNECTING.TaxiManager!.reset(newitem, updateUI: true, completion: {
                            
                        })
                    })
                }
            }
        }
    }
    
    public func onUserPaid(_ data : [AnyObject]){
        
        let arrData = data[0] as! [String: AnyObject]
        
        let userId = arrData["UserID"] as! String
        let driverId = arrData["DriverID"] as! String
        let orderId = arrData["OrderID"] as! String
        
        if(driverId == SCONNECTING.DriverManager?.CurrentDriver!.id!){
            
            ModelController<TravelOrder>.queryServerById(orderId) { (item) in
                if(item != nil && item!.IsPaid){
                    
                    let alert = UIAlertController(title: "Khách đã thanh toán", message: "Khách đã thanh toán bằng thẻ với số tiền \(item!.PayAmount.toCurrency(item!.Currency, country: nil)!)", preferredStyle: UIAlertControllerStyle.alert)
                    
                    alert.addAction(UIAlertAction(title: "Đồng ý", style: .default, handler: { (action: UIAlertAction!) in
                      
                        if(self.currentOrder != nil && item!.id == self.currentOrder!.id){
                            self.reset( true, completion: {
                                
                            })
                            
                            SCONNECTING.DriverManager?.changeReadyStatus({ (status) in
                                AppDelegate.mainWindow?.taxiViewCtrl.controlPanelView.invalidateReadyButton(nil)
                            })

                        }
                        
                        
                        
                    }))
                    
                    
                    AppDelegate.mainWindow?.taxiViewCtrl.present(alert, animated: true, completion: nil)
                    
                    
                }
            }
        }
    }
        
    
    public func onUserChat(_ data : [AnyObject]){
        let arrData = data[0] as! [String: AnyObject]
        
        let userId = arrData["UserID"] as! String
        let driverId = arrData["DriverID"] as! String
        let orderId = arrData["OrderID"] as! String
        let contentId = arrData["ContentID"] as! String
        let content = arrData["Content"] as! String
        
        if(driverId == SCONNECTING.DriverManager?.CurrentDriver!.id!){
            
            if(self.currentOrder != nil && self.currentOrder!.id == orderId){
                
                AppDelegate.mainWindow?.taxiViewCtrl.monitoringView.increaseMessageNo(1){ number in
                    
                    AppDelegate.mainWindow?.taxiViewCtrl.monitoringView.invalidateLastMessage(content) {
                        
                        AppDelegate.mainWindow?.taxiViewCtrl.monitoringView.chattingView!.chattingTable!.addItemFromUser(contentId, content : content) {
                            
                        }
                        
                        AppDelegate.mainWindow?.taxiViewCtrl.monitoringView.chattingView!.chattingTable!.loadNewItems({ 
                            
                            
                        })
                    }
                    
                }
                
            }
        }
    }
}

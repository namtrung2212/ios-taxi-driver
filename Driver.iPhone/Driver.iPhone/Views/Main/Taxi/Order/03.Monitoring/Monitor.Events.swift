//
//  Main.CreateOrder.CustomOrder.Events.swift
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

extension TravelMonitoringView {
    
    
    @IBAction public func btnCollapseProfile_Clicked(_ sender: UIButton) {
        
        
        UIView.animate(withDuration: 0.1 ,
                                   animations: {
                                    sender.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            },
                                   completion: { finish in
                                    UIView.animate(withDuration: 0.1, animations: {
                                        sender.transform = CGAffineTransform.identity
                                    })
                                    UIView.animate(withDuration: 0.25, animations: {
                                        
                                        self.parent.view.bringSubview(toFront: self.pnlUserProfileArea)
                                        self.parent.view.bringSubview(toFront: self.btnAvatar)
                                        self.parent.view.bringSubview(toFront: self.redCircle)
                                        self.parent.view.bringSubview(toFront: self.lblMessageNo)
                                        
                                        self.isCollapsedProfile = !self.isCollapsedProfile
                                        self.invalidateProfilePanelControls{
                                            
                                            if(self.isCollapsedProfile){
                                                self.chattingView!.setReadAll()
                                            }
                                        }
                                        
                                        if( !self.isCollapsedProfile){
                                            
                                            self.isCollapsedOrder = true
                                            self.invalidateOrderPanelControls{
                                                
                                            }
                                            
                                        }
                                        
                                    
                                    }) 
                                    
        })
        
    }
    
    
    
    
    @IBAction public func btnAvatar_Clicked(_ sender: UIButton) {
        
        
        UIView.animate(withDuration: 0.1 ,
                                   animations: {
                                    sender.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            },
                                   completion: { finish in
                                    UIView.animate(withDuration: 0.1, animations: {
                                        sender.transform = CGAffineTransform.identity
                                    })
                                    UIView.animate(withDuration: 0.25, animations: {
     
                                        
                                    }) 
                                    
        })
        
    }

    @IBAction public func btnCollapseOrder_Clicked(_ sender: UIButton) {
        
        
        UIView.animate(withDuration: 0.1 ,
                                   animations: {
                                    sender.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            },
                                   completion: { finish in
                                    UIView.animate(withDuration: 0.1, animations: {
                                        sender.transform = CGAffineTransform.identity
                                    })
                                    UIView.animate(withDuration: 0.25, animations: {
                                        
                                        self.isCollapsedOrder = !self.isCollapsedOrder
                                   
                                        self.invalidateOrderPanelControls{
                                            
                                        }
                                        
                                        
                                        if( !self.isCollapsedOrder){
                                            
                                            self.isCollapsedProfile = true
                                            self.invalidateProfilePanelControls{
                                                
                                            }
                                        }
                                        

                                    }) 
                                    
        })
        
    }

    
    
    @IBAction public func btnVoid_Clicked(_ sender: UIButton) {
        
        
        UIView.animate(withDuration: 0.1 ,
                                   animations: {
                                    sender.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            },
                                   completion: { finish in
                                    UIView.animate(withDuration: 0.1, animations: {
                                        sender.transform = CGAffineTransform.identity
                                    })
                                    UIView.animate(withDuration: 0.25, animations: {
                                        
                                        
                                        let alert = UIAlertController(title: "Bạn muốn hủy hành trình ?  ", message: "Việc hủy chuyến thường xuyên sẽ được ghi nhận vào hồ sơ của bạn. ", preferredStyle: UIAlertControllerStyle.alert)
                                        
                                        alert.addAction(UIAlertAction(title: "Hủy", style: .default, handler: { (action: UIAlertAction!) in
                                            
                                            if(self.CurrentOrder != nil){
                                                SCONNECTING.TaxiManager!.voidTrip(self.CurrentOrder!, completion: { (item) in
                                                    
                                                    if(item!.Status == OrderStatus.VoidedBfPickupByDriver ){
                                                        
                                                            SCONNECTING.TaxiManager!.reset(true){
                                                                SCONNECTING.DriverManager?.changeReadyStatus({ (status) in
                                                                    AppDelegate.mainWindow?.taxiViewCtrl.controlPanelView.invalidateReadyButton(nil)
                                                                })
                                                            }
                                                        
                                                    }else if(item!.Status == OrderStatus.VoidedAfPickupByDriver ){
                                                        SCONNECTING.TaxiManager!.reset(item, updateUI: true, completion: {
                                                            
                                                        })
                                                    }
                                                })
                                            }
                                            
                                        }))
                                        
                                        alert.addAction(UIAlertAction(title: "Không", style: .cancel, handler: { (action: UIAlertAction!) in
                                            
                                            
                                        }))
                                        
                                        AppDelegate.mainWindow?.taxiViewCtrl.present(alert, animated: true, completion: nil)
                                        
                                    }) 
                                    
        })
        
    }
    
    
    
    
    @IBAction public func btnTripStart_Clicked(_ sender: UIButton) {
        
        
        UIView.animate(withDuration: 0.1 ,
                                   animations: {
                                    sender.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            },
                                   completion: { finish in
                                    UIView.animate(withDuration: 0.1, animations: {
                                        sender.transform = CGAffineTransform.identity
                                    })
                                    UIView.animate(withDuration: 0.25, animations: {
                                        
                                        
                                        let alert = UIAlertController(title: "Bắt đầu hành trình ?  ", message: "Bắt đầu tính cước xe và thông báo đến khách hàng.", preferredStyle: UIAlertControllerStyle.alert)
                                        
                                        alert.addAction(UIAlertAction(title: "Bắt đầu", style: .default, handler: { (action: UIAlertAction!) in
                                            
                                            if(self.CurrentOrder != nil){
                                                
                                                SCONNECTING.TaxiManager!.startTrip(self.CurrentOrder!, completion: { (item) in
                                                    SCONNECTING.TaxiManager!.reset(item, updateUI: true,completion: {
                                                       
                                                    })
                                                    
                                                })
                                            }
                                            
                                        }))
                                        
                                        alert.addAction(UIAlertAction(title: "Không", style: .cancel, handler: { (action: UIAlertAction!) in
                                            
                                            
                                        }))
                                        
                                        AppDelegate.mainWindow?.taxiViewCtrl.present(alert, animated: true, completion: nil)
                                        
                                    }) 
                                    
        })
        
    }

    
    @IBAction public func btnTripFinish_Clicked(_ sender: UIButton) {
        
        
        UIView.animate(withDuration: 0.1 ,
                                   animations: {
                                    sender.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            },
                                   completion: { finish in
                                    UIView.animate(withDuration: 0.1, animations: {
                                        sender.transform = CGAffineTransform.identity
                                    })
                                    UIView.animate(withDuration: 0.25, animations: {
                                        
                                        let alert = UIAlertController(title: "Trả khách tại đây ? ", message: "Đề nghị kiểm tra lại hành lý. \n Giữ thái độ chuyên nghiệp, thân thiện.", preferredStyle: UIAlertControllerStyle.alert)
                                        
                                        alert.addAction(UIAlertAction(title: "Trả khách", style: .default, handler: { (action: UIAlertAction!) in
                                            
                                            if(self.CurrentOrder != nil){
                                                
                                                SCONNECTING.TaxiManager!.finishTrip(self.CurrentOrder!, completion: { (item) in
                                                    SCONNECTING.TaxiManager!.reset(item, updateUI: true){
                                                        
                                                    }
                                                    
                                                })
                                            }
                                            
                                        }))
                                        
                                        alert.addAction(UIAlertAction(title: "Không", style: .cancel, handler: { (action: UIAlertAction!) in
                                            
                                            
                                        }))
                                        
                                        AppDelegate.mainWindow?.taxiViewCtrl.present(alert, animated: true, completion: nil)
                                        
                                    }) 
                                    
        })
        
    }
    
    @IBAction public func btnCashPayment_Clicked(_ sender: UIButton) {
        
        
        UIView.animate(withDuration: 0.1 ,
                                   animations: {
                                    sender.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            },
                                   completion: { finish in
                                    UIView.animate(withDuration: 0.1, animations: {
                                        sender.transform = CGAffineTransform.identity
                                    })
                                    UIView.animate(withDuration: 0.25, animations: {
                                        
                                        let alert = UIAlertController(title: "Nhận tiền thanh toán bằng tiền mặt ? ", message: "Số tiền : \(self.CurrentOrder!.ActPrice.toCurrency(self.CurrentOrder!.Currency, country: nil)!) \r \n Xác nhận và kiểm tra lại tiền thực nhận.", preferredStyle: UIAlertControllerStyle.alert)
                                        alert.addAction(UIAlertAction(title: "Đã nhận", style: .default, handler: { (action: UIAlertAction!) in
                                            
                                            if(self.CurrentOrder != nil){
                                                
                                                SCONNECTING.TaxiManager!.cashPaid(self.CurrentOrder!, completion: { (item) in
                                                   
                                                })
                                                
                                                SCONNECTING.TaxiManager!.reset( true, completion: {
                                                    
                                                    
                                                })
                                                
                                                SCONNECTING.DriverManager?.changeReadyStatus({ (item) in
                                                    self.parent.controlPanelView.invalidateReadyButton(nil)
                                                })
 
                                            }
                                            
                                        }))
                                        
                                        alert.addAction(UIAlertAction(title: "Bỏ qua", style: .cancel, handler: { (action: UIAlertAction!) in
                                            
                                            
                                        }))
                                        
                                        AppDelegate.mainWindow?.taxiViewCtrl.present(alert, animated: true, completion: nil)
                                        
                                    }) 
                                    
        })
        
    }
    
    
    @IBAction public func btnDone_Clicked(_ sender: UIButton) {
        
        
        UIView.animate(withDuration: 0.1 ,
                                   animations: {
                                    sender.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            },
                                   completion: { finish in
                                    UIView.animate(withDuration: 0.1, animations: {
                                        sender.transform = CGAffineTransform.identity
                                    })
                                    UIView.animate(withDuration: 0.25, animations: {
                                        
                                        let alert = UIAlertController(title: "Hoàn tất hành trình ", message: "Số tiền : \(self.CurrentOrder!.ActPrice.toCurrency(self.CurrentOrder!.Currency, country: nil)!) sẽ được ghi nợ cho khách hàng.", preferredStyle: UIAlertControllerStyle.alert)
                                        
                                        alert.addAction(UIAlertAction(title: "Hoàn tất", style: .default, handler: { (action: UIAlertAction!) in
                                            
                                                if(self.CurrentOrder != nil){
                                                    
                                                    SCONNECTING.TaxiManager!.finishTrip(self.CurrentOrder!, completion: { (item) in
                                                        
                                                    })
                                                    
                                                }
                                                
                                                SCONNECTING.TaxiManager!.reset( true, completion: {
                                                    SCONNECTING.DriverManager?.changeReadyStatus({ (item) in
                                                        self.parent.controlPanelView.invalidateReadyButton(nil)
                                                    })
                                                })
                                        }))
                                        
                                        alert.addAction(UIAlertAction(title: "Bỏ qua", style: .cancel, handler: { (action: UIAlertAction!) in
                                            
                                            
                                        }))
                                        
                                        AppDelegate.mainWindow?.taxiViewCtrl.present(alert, animated: true, completion: nil)

                                        
                                        
                                        
                                    }) 
                                    
        })
        
    }


    
    
    @IBAction public func btnPickupIcon_Clicked(_ sender: UIButton) {
        if( self.CurrentOrder?.OrderPickupLoc != nil){
            
            self.parent.mapView.gmsMapView.animate(toLocation: self.CurrentOrder!.OrderPickupLoc!.coordinate())
        }
        
        UIView.animate(withDuration: 0.1 ,
                                   animations: {
                                    self.btnPickupIcon.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            },
                                   completion: { finish in
                                    UIView.animate(withDuration: 0.1, animations: {
                                        self.btnPickupIcon.transform = CGAffineTransform.identity
                                    })
            }
        )
        
    }
    
    @IBAction public func btnDropIcon_Clicked(_ sender: UIButton) {
        
        if( self.CurrentOrder?.OrderDropLoc != nil){
            self.parent.mapView.gmsMapView.animate(toLocation: self.CurrentOrder!.OrderDropLoc!.coordinate())
        }
        
        
        UIView.animate(withDuration: 0.1 ,
                                   animations: {
                                    self.btnDropIcon.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            },
                                   completion: { finish in
                                    UIView.animate(withDuration: 0.1, animations: {
                                        self.btnDropIcon.transform = CGAffineTransform.identity
                                    })
            }
        )
        
    }
    
}

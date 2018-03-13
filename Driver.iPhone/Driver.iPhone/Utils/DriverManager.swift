//
//  DriverManager.swift
//  Driver.iPhone
//
//  Created by Trung Dao on 6/15/16.
//  Copyright © 2016 SCONNECTING. All rights reserved.
//

import UIKit
import Foundation
import ObjectMapper
import AlamofireObjectMapper
import SClientData
import SClientModel
import SClientModelControllers
import CoreLocation
import RealmSwift
import GoogleMaps
import Alamofire
import SwiftyJSON
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}



open class SCDriverManager : NSObject {
    
    
    open var CurrentDriver : Driver?
    open var CurrentDriverSetting : DriverSetting?
    open var CurrentDriverStatus : DriverStatus?
    open var CurrentWorkingPlan : WorkingPlan?
    open var CurrentCarStatus : CarStatus?

    open var CurrentLongtitude : Double?
    open var CurrentLatitude : Double?
    
    
    open static  var Token: String?{
        
        get {
            return UserDefaults.standard.string(forKey: "Token")
        }
    }
    
    
    open static  var DefaultDriverID: String?{
        
        get {
            return UserDefaults.standard.string(forKey: "DefaultDriverID")
        }
    }
    
    
    
    open func login(_ driverId : String,completion: ((_ success: Bool,_ setting:  DriverSetting?) -> ())?){
        
        self.registerNewDevice(driverId) { (success, setting) in
            
            if(success){
                
                    self.initCurrentDriver { isValidDriver in
                        completion?(success:isValidDriver, setting: setting)
                    }
                
            }else{
                    completion?(success:false, setting: nil)
            }
            
        }
        
    }
  
    
    
    open func registerNewDevice(_ driverId : String,completion: ((_ success: Bool,_ setting:  DriverSetting?) -> ())?){
        
        SCDriverManager.requestNewToken(driverId) { (token) in
        
            ModelController<DriverSetting>.getOneByField("Driver", value: driverId, isGetNow: true, clientHandler: { (item) in
                
                }, serverHandler: { (item) in
                    
                    let newItem = item?.copy() as! DriverSetting
                    newItem.Device = UIDevice.current.model
                    newItem.DeviceID = UIDevice.current.identifierForVendor!.uuidString
                    
                    ModelController<DriverSetting>.update(newItem, completion: { (success, updatedItem) in
                        if(success){
                            self.CurrentDriverSetting = updatedItem?.copy() as? DriverSetting
                            UserDefaults.standard.setValue(driverId, forKey: "DefaultDriverID")
                        }
                        completion?(success: success, setting: updatedItem)
                    })
                    
            })
        }
        
    }
    
    
    
    open static func isValidDevice(_ completion: ((Bool) -> ())?){
        
        let driverId = DefaultDriverID
        
        if (driverId != nil){
            
            
            getToken({ (token) in
                    ModelController<DriverSetting>.getOneByField("Driver", value: driverId!, isGetNow: true, clientHandler: { (item) in
                        
                        }, serverHandler: { (item) in
                            
                            if(item == nil){
                                
                                completion?(false)

                            }else{
                                
                                #if (arch(i386) || arch(x86_64)) && os(iOS)
                                    
                                    let isValid = true
                                    
                                #else
                                    
                                    let isValid = (item!.Device == UIDevice.currentDevice().model) && ( item!.DeviceID == UIDevice.currentDevice() .identifierForVendor!.UUIDString )
                                    
                                #endif
                                
                                completion?(isValid)
                            }
                            
                    })
            })
            
            
        }else{
            
            completion?(false)
            
        }
        
        
    }
    
    
    
    
    open static func getToken(_ completion: ((String?) -> ())?){
        
        if let driverId = DefaultDriverID{
            
            requestNewToken(driverId, completion: { (newToken) in
                completion?(newToken)
            })
            
        }else{
            completion?(nil)
        }
    }
    
    open static func requestNewToken(_ driverId: String, completion: ((String?) -> ())?){
        
        
        let url = SClientData.ServerURL + "/authenticate/driver"
        let headers = ["Content-Type": "text/plain"]
        let parameters = ["id": driverId]
        
        Alamofire.request(.POST, url, parameters: parameters, headers: headers, encoding : .json)
            .responseJSON { response in
                
                switch response.result {
                    
                case .success(let data):
                    
                    let json = JSON(data)
                    let success = json["success"].boolValue
                    
                    if (success == true){
                        
                        let token = json["token"].stringValue
                        UserDefaults.standard.setValue(token, forKey: "Token")
                        completion?(token)
                        
                    }else{
                        completion?(nil)
                    }
                    
                case .failure( _):
                    
                    completion?( nil)
                }
        }
    }
    
    
    open static func isValidToken(_ driverId: String, completion: ((Bool) -> ())?){
        
        if let token = UserDefaults.standard.string(forKey: "Token") {
            
            let url = SClientData.ServerURL + "/authenticate/driver/checktoken"
            let headers = ["Content-Type": "application/x-www-form-urlencoded"]
            let parameters = ["id": driverId,"token": token]
            
            Alamofire.request(.POST, url, parameters: parameters, headers: headers, encoding: .urlEncodedInURL)
                .responseJSON { response in
                    
                    switch response.result {
                        
                    case .success(let data):
                        
                        let json = JSON(data)
                        let success = json["success"]
                        
                        completion?((success == true))
                        
                    case .failure( _):
                        
                        completion?( false)
                    }
            }
            
        }else{
            
            completion?( false)
            
        }
    }
    
    

    
    open func invalidateStatus(_ completion: (() -> ())?){
        
        if(self.CurrentDriver != nil){
            ModelController<DriverStatus>.getOneByField("Driver", value: self.CurrentDriver!.id!, isGetNow: true, clientHandler: nil, serverHandler: { (item) in
                self.CurrentDriverStatus = item!.copy() as? DriverStatus
                completion?()
            })
            
            
        }else{
            completion?()
        }
        
    }
    
    open func initCurrentDriver(_ completion: ((_ validDriver : Bool ) -> ())?){
        
            let driverId = SCDriverManager.DefaultDriverID
            if(driverId == nil){
                completion?(false)
                return
            }
        
             ModelController<Driver>.queryServerById(driverId!, serverHandler: { (driver) in
                
                    self.CurrentDriver = driver
                    
                    if(driver == nil){
                        completion?(validDriver : false)
                        return
                    }
            
                    ModelController<DriverSetting>.getOneByField("Driver", value: driverId, isGetNow: true, clientHandler: nil, serverHandler: { (setting) in
                            self.CurrentDriverSetting = setting
                    })
                    
                    ModelController<DriverStatus>.getOneByField("Driver", value: driverId, isGetNow: true, clientHandler: nil, serverHandler: { (status) in
                        
                            self.CurrentDriverStatus = status
                            self.CurrentWorkingPlan = nil
                            self.CurrentCarStatus = nil
                            
                            if(status == nil){
                                completion?(validDriver : false)
                                return
                            }
                                
                             if(status!.WorkingPlan != nil){
                        
                                            ModelController<WorkingPlan>.queryServerById( status!.WorkingPlan!, serverHandler: { (plan) in
                                                
                                                        if(plan != nil && plan!.IsActive && plan!.IsEnable && plan!.Car != nil){
                                                            
                                                            self.CurrentWorkingPlan = plan
                                                            
                                                            if(self.CurrentDriverStatus!.Car == nil){
                                                                
                                                                    ModelController<CarStatus>.queryServer("selectall", filter: "Car=\(plan!.Car!)", serverHandler: { (carStatuses) in

                                                                        if(carStatuses?.count > 0){
                                                                            self.CurrentCarStatus = carStatuses![0]
                                                                        }
                                                                        completion?(validDriver : true)
                                                                    })
                                                                
                                                            }else{
                                                                
                                                                    ModelController<CarStatus>.queryServer("selectall", filter: "Car=\(self.CurrentDriverStatus!.Car!)", serverHandler: { (carStatuses2) in
                                                                        
                                                                        if(carStatuses2?.count > 0){
                                                                            self.CurrentCarStatus = carStatuses2![0]
                                                                        }
                                                                        completion?(validDriver : true)
                                                                        
                                                                    })

                                                            }
                                                            
                                                        }else{
                                                            completion?(validDriver : true)
                                                        }
                                                
                                            })
                                
                             }else if(self.CurrentDriverStatus!.Car != nil){
                                
                                            ModelController<CarStatus>.queryServerById(self.CurrentDriverStatus!.Car!, serverHandler: { (carStatus2) in
                                                
                                                self.CurrentCarStatus = carStatus2
                                                completion?(validDriver : true)
                                                
                                            })
                                
                             }
                        
                    })
            

             })
        
        
    }
    
    
    
    open func changeReadyStatus(_ completion:(( _ item: DriverStatus?) -> ())?){
        
        DriverController.ChangeDriverReadyStatus((SCONNECTING.DriverManager?.CurrentDriver?.id!)!) { (status) in
            
            if(status != nil){
                self.CurrentDriverStatus = status?.copy() as? DriverStatus
                completion?(item: status)
                
            }else{
                completion?(item: nil)
            }
        }
        
        
    }
    
    open func checkCarAvaiable(_ completion:((Bool) -> ())?){

        self.queryToCheckCarAvaiable { (validPlan, otherDrivers) in
                    
                    if(validPlan != nil){
                        
                                if(otherDrivers != nil && otherDrivers!.count > 0){
                                    
                                    let alert = UIAlertController(title: "Xe \(validPlan!.CarNo!) đã giao cho tài khác", message: "Tài xế \(otherDrivers![0].DriverName!) đang sử dụng xe. \r\n Bạn có thể theo dõi toạ độ xe hoặc đề nghị đổi xe.", preferredStyle: UIAlertControllerStyle.alert)
                                    
                                    alert.addAction(UIAlertAction(title: "Theo dõi", style: .default, handler: { (action: UIAlertAction!) in
                                        completion?(false)
                                    }))
                                    
                                    alert.addAction(UIAlertAction(title: "Gọi tài", style: .default, handler: { (action: UIAlertAction!) in
                                        if let url = URL(string: "tel://\(otherDrivers![0].PhoneNo!)") {
                                            UIApplication.shared.openURL(url)
                                        }
                                          completion?(false)
                                    }))
                                    
                                    AppDelegate.mainWindow?.taxiViewCtrl.present(alert, animated: true, completion: nil)
                                
                                
                                }else{
                                    
                                    if( self.CurrentDriverStatus!.Car == nil || self.CurrentDriverStatus!.IsCarTaken == false){
                                            let alert = UIAlertController(title: "Bạn đã nhận xe \(validPlan!.CarNo!) ?", message: "Xác nhận để bắt đầu hoạt động. \r\n Bỏ qua để theo dõi toạ độ xe.", preferredStyle: UIAlertControllerStyle.alert)
                                            
                                            alert.addAction(UIAlertAction(title: "Đã nhận", style: .default, handler: { (action: UIAlertAction!) in
                                                self.takeDefaultCar({
                                                      completion?(true)
                                                })
                                            }))
                                            
                                            alert.addAction(UIAlertAction(title: "Theo dõi", style: .default, handler: { (action: UIAlertAction!) in
                                                     completion?(false)
                                            }))
                                              AppDelegate.mainWindow?.taxiViewCtrl.present(alert, animated: true, completion: { 
                                                
                                              })
                                        
                                    }else{
                                     
                                         completion?(true)
                                        
                                    }
                                }
                        
                    }else{
                        
                        
                                let alert = UIAlertController(title: "Chưa được giao xe", message: "Vui lòng liên hệ quản lý để giao nhận xe. \r\n Bạn cũng có thể nhận xe từ tài khác.", preferredStyle: UIAlertControllerStyle.alert)
                        
                                alert.addAction(UIAlertAction(title: "Đồng ý", style: .default, handler: { (action: UIAlertAction!) in
                                      completion?(false)
                                }))
                                
                                AppDelegate.mainWindow?.taxiViewCtrl.present(alert, animated: true, completion: nil)
                        
                    }
            
        }
        
    
    }
    
    open func queryToCheckCarAvaiable(_ completion:(( _ validPlan: WorkingPlan?, _ otherDrivers: [DriverStatus]?) -> ())?){
        
        
            ModelController<WorkingPlan>.queryServerById(self.CurrentDriverStatus!.WorkingPlan!, serverHandler: { (plan) in
                
                        if(plan != nil && plan!.IsActive && plan!.IsEnable && plan!.Car != nil && ( self.CurrentDriverStatus!.Car == nil || self.CurrentDriverStatus!.IsCarTaken == false)){
                                
                                ModelController<DriverStatus>.queryServer("selectall", filter: "Car=\(plan!.Car!)&IsCarTaken=1", serverHandler: { (otherDrivers) in
                                    
                                    completion?(validPlan: plan, otherDrivers : otherDrivers)
                                    
                                })
                            
                        }else{
                            
                            completion?(validPlan: plan, otherDrivers : nil)
                            
                        }
            })
        
        
    }
    
    
    
    
    open func takeDefaultCar(_ completion:(() -> ())?){
        
        ModelController<DriverStatus>.queryServerForOne("takedefaultcar/\(self.CurrentDriverStatus!.Driver!)", filter: nil, serverHandler: { (status) in
            
            if(status != nil){
                self.CurrentDriverStatus = status
            }
            
            completion?()
            
        })
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    

}

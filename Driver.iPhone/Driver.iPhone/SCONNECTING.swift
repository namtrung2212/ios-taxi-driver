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


open class SCONNECTING : NSObject {
    
    open static var isDebugging: Bool = true
    
    open static var DriverManager : SCDriverManager?
    
    open static var LocationManager: SCLocationManager?
    
    open static var NotificationManager: SNotificationManager?
    
    open static var TaxiManager : TravelOrderManager?
    
    
    open static func Init(_ completion: (() -> ())?){
        
        let realm = try! Realm()
        let folderPath = ((realm.configuration.fileURL?.absoluteString)! as NSString).deletingLastPathComponent
        // try! NSFileManager.defaultManager().setAttributes([NSFileProtectionKey: NSFileProtectionNone],ofItemAtPath: folderPath)
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        
        DriverManager = SCDriverManager()
        
        LocationManager = SCLocationManager()
        NotificationManager = SNotificationManager()
        TaxiManager = TravelOrderManager()

        SetupCachingTime(completion)
        
    }
    

    open static func Start(_ completion: (() -> ())?){
        
            if(TaxiManager == nil){
                completion?()
            }
        
        let notificationTypes: UIUserNotificationType = [UIUserNotificationType.alert, UIUserNotificationType.badge, UIUserNotificationType.sound]
        let pushNotificationSettings = UIUserNotificationSettings(types: notificationTypes, categories: nil)
        
        
        UIApplication.shared.registerUserNotificationSettings(pushNotificationSettings)
        UIApplication.shared.registerForRemoteNotifications()
        
        TaxiManager!.Start(completion)

        
    }
    
    open static func SetupCachingTime(_ completion: (() -> ())?){
        
        ClientCachingConfig.register( "Car", cachingminutes: 60 * 24, cleanupdays: 10)
        
        ClientCachingConfig.register( "CarStatus", cachingminutes: 1, cleanupdays: 10)
        
        ClientCachingConfig.register( "CellStatistic", cachingminutes: 5, cleanupdays: 10)
        
        ClientCachingConfig.register( "Company", cachingminutes: 60 * 24, cleanupdays: 10)
        
        ClientCachingConfig.register( "Driver", cachingminutes: 60 * 24, cleanupdays: 10)
        
        ClientCachingConfig.register( "DriverActivity", cachingminutes: 60 * 24, cleanupdays: 10)
        
      //  ClientCachingConfig.register( "DriverPosHistory", cachingminutes: 2, cleanupdays: 10)
        
        ClientCachingConfig.register( "DriverSetting", cachingminutes: 60 * 24, cleanupdays: 10)
        
      //  ClientCachingConfig.register( "DriverStatus", cachingminutes: 1, cleanupdays: 10)
        
        ClientCachingConfig.register( "ExchangeRate", cachingminutes: 60 * 24, cleanupdays: 10)
        
        ClientCachingConfig.register( "TaxiAveragePrice", cachingminutes: 60 * 24 * 10, cleanupdays: 30)
        
        ClientCachingConfig.register( "TaxiDiscount", cachingminutes: 60 * 24, cleanupdays: 10)
        
        ClientCachingConfig.register( "TaxiPrice", cachingminutes: 60 * 24, cleanupdays: 10)
        
        ClientCachingConfig.register( "Team", cachingminutes: 60 * 24, cleanupdays: 10)
        
      //  ClientCachingConfig.register( "TravelOrder", cachingminutes: 1, cleanupdays: 10)
        
        ClientCachingConfig.register( "Driver", cachingminutes: 60 * 24, cleanupdays: 10)
        
        ClientCachingConfig.register( "DriverActivity", cachingminutes: 60 * 24, cleanupdays: 10)
        
        //ClientCachingConfig.register( "DriverPosHistory", cachingminutes: 2, cleanupdays: 10)
        
        ClientCachingConfig.register( "DriverSetting", cachingminutes: 60 * 24, cleanupdays: 10)
        
       // ClientCachingConfig.register( "DriverStatus", cachingminutes: 1, cleanupdays: 10)
        
        ClientCachingConfig.register( "WorkingPlan", cachingminutes: 60 * 1, cleanupdays: 10)
        
        
        completion?()

    }
    
    
}

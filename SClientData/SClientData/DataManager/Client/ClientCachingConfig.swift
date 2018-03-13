//
//  CachingManager.swift
//  BOOKTAXI
//
//  Created by Trung Dao on 4/9/16.
//  Copyright © 2016 SCONNECTING. All rights reserved.
//

//
//  User.swift
//  BOOKTAXI
//
//  Created by Trung Dao on 4/7/16.
//  Copyright © 2016 SCONNECTING. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper
import SClientModel

open class CachingInfo: Object {
    
    open dynamic var id : String?
    dynamic var URL : String = ""
    dynamic var ModelType : String = ""
    
    open dynamic var RetrievedAt : Date? = nil
    open dynamic var ExpireTime : Date? = nil
    
    
    override open static func primaryKey() -> String? {
        return "id"
    }
    
    required public convenience init(URL: String, ModelType: BaseModel.Type, expireMinutes : Double?) {
        
        self.init()
        self.id = String(ModelType) + URL
        self.URL = URL
        self.ModelType = String(ModelType)
        self.RetrievedAt = Date()
        
        self.ExpireTime = self.RetrievedAt!.addingTimeInterval(expireMinutes! * 60)
        
    }
    
}

open class ClientCachingConfig: NSObject{
    
    
    open static var intance : ClientCachingConfig?
    
    open var cachingMinutes : [String : Double]
    open var cleanUpDays : [String : Double]
    
    open static func Init(){
        if( intance == nil){
            intance =  ClientCachingConfig()
            
            intance!.cachingMinutes = [:]
            intance!.cleanUpDays = [:]
        }
    }
    
    public override init()
    {
        
        cachingMinutes = [:]
        cleanUpDays = [:]
        super.init()
        
    }
    
    open static func register(_ modelType: String, cachingminutes : Double?, cleanupdays: Double?)->Void{
        
        Init()
        
        if( cachingminutes != nil){
            if let minute = intance!.cachingMinutes[modelType] {
                intance!.cachingMinutes.updateValue(cachingminutes!, forKey: modelType)
            }else{
                intance!.cachingMinutes[modelType] = cachingminutes!
            }
        }
        
        if( cleanupdays != nil){
            if let days = intance!.cleanUpDays[modelType] {
                intance!.cleanUpDays.updateValue(cleanupdays!, forKey: modelType)
            }else{
                intance!.cleanUpDays[modelType] = cleanupdays!
            }
        }
        

    }
    
    open static func getCachingMinutes(_ modelType: String) -> Double{
        ClientCachingConfig.Init()
        if let minute = ClientCachingConfig.intance!.cachingMinutes[modelType]{
            return minute
        }else{
            return 0
        }
    }
    open static func getCleanUpDays(_ modelType: String) -> Double{
        ClientCachingConfig.Init()
        if let days =  ClientCachingConfig.intance!.cleanUpDays[modelType] {
            return days
        }else{
            return 0
        }
    }
    
    
    
}


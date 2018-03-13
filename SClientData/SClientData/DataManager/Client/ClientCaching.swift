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

open class ClientCaching<T:BaseModel>{
    
    open static func isExpired(_ URL: String) -> Bool{
        
        let realm = try! Realm()
        var cachInfo  = realm.objects(CachingInfo).filter("URL == '\(URL)' AND ModelType == '\(T.self)'" ).first
        
        return ( cachInfo == nil || cachInfo!.ExpireTime!.compare(Date()) == ComparisonResult.orderedAscending ) //less than =>  expired
        
    }

    open static func isExpired(_ item: T) -> Bool{
        let cachingMInutes = ClientCachingConfig.getCachingMinutes(String(describing: T))
        return cachingMInutes <= 0 || (item.retrieveAt != nil && item.retrieveAt?.addingTimeInterval(cachingMInutes*60).compare(Date()) == ComparisonResult.orderedAscending )  //  expired
    }
    
    
    open static func set(_ URL: String, newExpireMinutes : Double?){
        
        let realm = try! Realm()
        var cachInfo  = realm.objects(CachingInfo).filter("URL == '\(URL)' AND ModelType == '\(T.self)'" ).first
        
        
        var minutes = ClientCachingConfig.getCachingMinutes(String(describing: T))
        if( newExpireMinutes != nil ){
            minutes = newExpireMinutes!
        }

        if(minutes <= 0){
            return
        }
        
        if ( cachInfo != nil  && cachInfo?.RetrievedAt != nil){
            
                var newexpireTime = cachInfo!.RetrievedAt!.addingTimeInterval(minutes * 60)
            
                try! realm.write {
                    cachInfo!.ExpireTime = newexpireTime
                    
                    realm.add(cachInfo!, update: true)
                }
            

        }else{
            
                try! realm.write {
                    cachInfo =  CachingInfo (URL: URL, ModelType: T.self, expireMinutes: minutes)
                    realm.add(cachInfo!, update: true)
                }
            
        }
        
    }
    
}


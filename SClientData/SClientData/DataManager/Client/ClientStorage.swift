//
//  RealmDB.swift
//  BOOKTAXI
//
//  Created by Trung Dao on 4/8/16.
//  Copyright © 2016 SCONNECTING. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper
import AlamofireObjectMapper
import RealmSwift
import SClientModel
import Realm

open class ClientStorage<T:BaseModel> {

    open static func retrieve(_ items: [T]){
        
            let realm = try! Realm
            try! realm.write {
                for item in items {
                    item.retrieveAt = Date()
                    realm.add(item, update: true)
                }
            }
    }

    
    open static func retrieve(_ item: T){
        
            let realm = try! Realm
            try! realm.write {
                
                item.retrieveAt = Date()
                realm.add(item, update: true)
                
            }
    }
    

    open static func use(_ items: [T]){
        
        let realm = try! Realm
            try! realm.write {
                for item in items {
                    item.useAt = Date()
                    realm.add(item, update: true)
                }
            }
        
    }
    
    open static func use(_ item: T){
        RLMRealm.default()
            let realm = try! Realm
            try! realm.write {
                
                    item.useAt = Date()
                    realm.add(item, update: true)
                
            }
        
    }

    
    open static func get(_ filter: String?,completion: ((_ items: [T]) -> ())?)->Void{
        
        let realm = try! Realm
        var items: [T]
        
        if(filter != nil){
                    items = Array(realm.objects(T).filter(filter!) )
        }else{
                    items = Array(realm.objects(T))
        }
        
        ClientStorage.use(items)
        
        completion?(items )
        
    }
    
    open static func getById (_ id: String,completion: ((_ item: T?) -> ())?)->Void {
        let realm = try! Realm
        realm.refresh()
        var item =  realm.objects(T).filter("id == '\(id)'").first
        if(item?.id == nil){
            item = nil
        }
        if( item != nil){
           // ClientStorage.use(item!)
        }
        
        completion?(item : item )
        
    }

    
    open static func getOne (_ filter: String?,completion: ((_ item: T?) -> ())?)->Void {
        
        let realm = try! Realm
        var item = (filter != nil) ? (realm.objects(T).filter(filter!).first) : (realm.objects(T).first)
        
        if( item != nil){
            ClientStorage.use(item!)
        }
        if(item?.id == nil){
            item = nil
        }
        completion?(item : item )

    }
    
    open static func save (_ obj: T) {
        
            let realm = try! Realm
        
            try! realm.write {
                realm.add(obj, update: true)
            }
    }
    
    open static func saveAndRefresh (_ obj: inout T) {
        
            let realm = try! Realm
            
            try! realm.write {
                realm.add(obj, update: true)
            }
        
            getById(obj.id!) { (item) in
                    obj=item!
                }
    }
    
    open static func delete (_ obj: T) {
        
            let realm = obj.realm
            if(realm != nil){
                try! realm!.write {
                    realm!.delete(obj)
                }
            }
    }
    
    open static func deleteById (_ id: String) {
        
            let realm = try! Realm
            let item =  realm.objects(T).filter("id == '\(id)'").first
            
            if( item != nil){
                delete(item!)
            }
        
    }

    
    open static func delete(_ filter: String?, completion: ((_ deleted : Int) -> ())?){
        
        if(filter != nil){
            
            let realm = try! Realm
            let items = Array(realm.objects(T).filter(filter!) )
            
            try! realm.write {
                for item in items {
                    realm.delete(item)
                }
            }
            
            completion?(deleted: items.count)

        }else{
            completion?(0)
        }
    }
    
    open static func deleteAll()->Void{
        
        
                let realm = try! Realm
                
                let items = Array(realm.objects(T))
                
                try! realm.write {
                    for item in items {
                        realm.delete(item)
                    }
                }
    }
    
    open static func cleanUpIfNeeded() {
        ClientStorage<T>.cleanUp(ClientCachingConfig.getCleanUpDays(String(describing: T))) {}
    }

    
    
    open static func cleanUp(_ cleanUpDays: Double, completion: (() -> ())?){
        
                let realm = try! Realm
            
                let items = Array(realm.objects(T).filter("useAt == nil OR useAt < %@",Date().addingTimeInterval( -cleanUpDays*24*60*60)) )
        
                try! realm.write {
                    for item in items {
                        realm.delete(item)
                    }
                }
        
                completion?()
    }
}


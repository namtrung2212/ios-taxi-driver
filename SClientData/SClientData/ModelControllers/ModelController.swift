//
//  BaseModelController.swift
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



open class ModelController<T:BaseModel> {
    
    
    open static func queryServer ( _ type: String,filter: String? ,serverHandler: (( _ items: [T]?) -> ())?)->Void {
        
        DataManager<T>.queryServer(type, filter: filter) { (items) in
             serverHandler?(items)
        }
        
    }
    
    open static func queryServerForOne ( _ type: String,filter: String? ,serverHandler: (( _ item: T?) -> ())?)->Void {
        
        DataManager<T>.queryServerForOne(type, filter: filter) { (item) in
            serverHandler?(item)
        }
        
    }
    
    open static func queryServer ( _ URL: String, serverHandler: (( _ items: [T]?) -> ())?)->Void {
        
        DataManager<T>.queryServer(URL) { (items) in
            serverHandler?(items)
        }
        
    }
    
    open static func getById(_ id: String,obj: inout T?){
        
        DataManager<T>.getById(id,isGetNow: false, clientHandler: { (item) in
            
            obj = item
            
        }) { (item) in
            
            obj = item
        }
    }
    
    
    open static func getById(_ id: String,clientHandler: (( _ item: T?) -> ())?,serverHandler: (( _ item: T?) -> ())?){
        
        DataManager<T>.getById(id,isGetNow: false, clientHandler: { (item) in
            
            clientHandler?(item)
            
        }) { (item) in
            
            serverHandler?(item)
        }
        
        
    }
    
    open static func queryServerById(_ id: String,serverHandler: (( _ item: T?) -> ())?){
        
        DataManager<T>.queryServerById(id) { (item) in
            serverHandler?(item)
        }
        
        
    }
    
    
    open static func getOne(_ clientFilter: String?, serverFilter: String?, clientHandler: (( _ item: T?) -> ())?,serverHandler: (( _ item: T?) -> ())?){
        
        DataManager<T>.getOne(clientFilter,serverFilter: serverFilter,isGetNow: false, clientHandler: { (item) in
            
            clientHandler?(item)
            
        }) { (item) in
            
            serverHandler?(item)
        }
        
    }
    
    open static func getAll (_ clientHandler: (( _ items: [T]?) -> ())?,serverHandler: (( _ items: [T]?) -> ())?) {
        DataManager<T>.getAll(false, clientHandler: clientHandler, serverHandler: serverHandler)
    }
    
    open static func getAll ( _ isGetNow : Bool , clientHandler: (( _ items: [T]?) -> ())?,serverHandler: (( _ items: [T]?) -> ())?)->Void {
        
        DataManager<T>.getAll(isGetNow, clientHandler: { (items) in
            
            clientHandler?(items)
            
        }) { (items) in
            
            serverHandler?(items)
        }
        
    }
    
    
    open static func getAll (_ clientFilter: String?, serverFilter: String?, isGetNow : Bool , clientHandler: (( _ items: [T]?) -> ())?,serverHandler: (( _ items: [T]?) -> ())?) {
        
        DataManager<T>.getAll(clientFilter, serverFilter: serverFilter, isGetNow: isGetNow, clientHandler: { (items) in
            
            clientHandler?(items)
            
        }) { (items) in
            
            serverHandler?(items)
        }
        
    }
    
    
    open static func getByField (_ field: String, value: Any, clientHandler: (( _ items: [T]?) -> ())?,serverHandler: (( _ items: [T]?) -> ())?) {
        DataManager<T>.getByField(field, value: value, isGetNow:false, clientHandler: clientHandler, serverHandler: serverHandler)
    }
    
    open static func getByField (_ field: String, value: Any, isGetNow : Bool , clientHandler: (( _ items: [T]?) -> ())?,serverHandler: (( _ items: [T]?) -> ())?) {
        
        DataManager<T>.getByField(field, value: value, isGetNow: isGetNow, clientHandler: { (items) in
            
            clientHandler?(items)
            
        }) { (items) in
            
            serverHandler?(items)
        }
        
        
    }
    
    
    open static func getOneByField(_ field: String, value: Any,obj: inout T?){
        
        DataManager<T>.getOneByField(field, value: value, isGetNow: false, clientHandler: { (item) in
            
            obj = item
            
        }) { (item) in
            
            obj = item
        }
    }

    
    open static func getOneByField (_ field: String, value: Any, isGetNow : Bool, clientHandler: (( _ item: T?) -> ())?,serverHandler: (( _ item: T?) -> ())?) {
        
        DataManager<T>.getOneByField(field, value: value, isGetNow: isGetNow, clientHandler: { (item) in
            
            clientHandler?(item)
            
        }) { (item) in
            
            serverHandler?(item)
        }
        
        
    }
    
    open static func getOneByFields (_ params: [QueryParam<T>], clientHandler: (( _ item: T?) -> ())?,serverHandler: (( _ item: T?) -> ())?)->Void {
        
        DataManager<T>.getOneByFields(params, isGetNow: false, clientHandler: { (item) in
            
            clientHandler?(item)
            
        }) { (item) in
            
            serverHandler?(item)
        }
        
    }
    
    open static func getByFields (_ params: [QueryParam<T>] , clientHandler: (( _ items: [T]?) -> ())?,serverHandler: (( _ items: [T]?) -> ())?) {
        DataManager<T>.getByFields(params, isGetNow: false,clientHandler: clientHandler, serverHandler: serverHandler)
    }
    
    open static func getByFields (_ params: [QueryParam<T>], isGetNow : Bool , clientHandler: (( _ items: [T]?) -> ())?,serverHandler: (( _ items: [T]?) -> ())?) {
        
        DataManager<T>.getByFields(params, isGetNow: isGetNow, clientHandler: { (items) in
            
            clientHandler?(items)
            
        }) { (items) in
            
            serverHandler?(items)
        }
        
    }
    
    open static func create (_ obj: T,params: [String]?,completion: ((_ success: Bool, _ item: T?) -> ())?)->Void {
        
        DataManager<T>.create(obj, params: params,completion: { (success, newitem) in
            completion?( success , newitem)
        })
        
    }
    open static func create (_ obj: T,completion: ((_ success: Bool, _ item: T?) -> ())?)->Void {
        
        DataManager<T>.create(obj, completion: { (success, newitem) in
           completion?( success , newitem)
        })
    }
    
    
    
    open static func update(_ obj: T,completion: ((_ success: Bool, _ item: T?) -> ())?) {
        
        DataManager<T>.update(obj, completion: { (success, newitem) in
            completion?( success , newitem)
        })
    }
    
    open static func delete (_ obj: T,completion:(()->Void)?)->Void {
        
        DataManager<T>.delete(obj, completion: { (item) in
            completion?(item)
        })
        
    }
    
    open static func deleteBulk (_ objs: [T],completion:(()->Void)?)->Void {
        
    }
    
    open static func deleteByField(_ field: String, value: Any,completion: ((_ deleted: Int)->Void)?)->Void {
        
        DataManager<T>.deleteByField(field,value: value, completion: { (deleted) in
            completion?(deleted)
        })
    }
    
    open static func deleteByFields(_ fields: Dictionary<String,Any> ,completion: ((_ deleted: Int)->Void)?)->Void {
        
        DataManager<T>.deleteByFields(fields, completion: { (deleted) in
            completion?(deleted)
        })
    }


    
}

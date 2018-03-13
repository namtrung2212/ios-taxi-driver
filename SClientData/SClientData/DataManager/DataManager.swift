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


open class DataManager<T:BaseModel> {
    
    open static func copyArray(_ array: [T]) -> [T]{
        
        var newArr : [T] = []

        array.forEach { (item) in
                newArr.append((item.copy() as? T)!)
        }
        
        return newArr
    }

    
    open static func queryServerForStringResponse ( _ type: String,filter: String? ,serverHandler: (( _ result: String?) -> ())?)->Void {
     
        let newFilter = type + ( filter != nil ? ("?" + filter!) : "" )

        DispatchQueue(label: "queryServer", attributes: []).async {
            
            ServerStorage<T>.get(newFilter, completion: { (result: String?) in
                DispatchQueue.main.async(execute: { () -> Void in
                    serverHandler?(result)
                })

            })
            
        }
        
    }
    
    open static func queryServerForDoubleResponse ( _ type: String,filter: String? ,serverHandler: (( _ result: Double?) -> ())?)->Void {
        
        let newFilter =  type + ( filter != nil ? ("?" + filter!) : "" )
        
        DispatchQueue(label: "queryServer", attributes: []).async {
            
            ServerStorage<T>.get(newFilter, completion: { (result: Double?) in
                DispatchQueue.main.async(execute: { () -> Void in
                    serverHandler?(result)
                })
                
            })
            
        }
        
    }
    

    
    open static func queryServer ( _ type: String,filter: String? ,serverHandler: (( _ items: [T]?) -> ())?)->Void {
        
            let newFilter =  type + ( filter != nil ? ("?" + filter!) : "" )

            DataManager<T>.queryServer(newFilter) { (items) in
               
                    serverHandler?(items)
            
            }
        
    }
    
    
    open static func queryServerForOne ( _ type: String,filter: String? ,serverHandler: (( _ item: T?) -> ())?)->Void {
        
        let newFilter =  type + ( filter != nil ? ("?" + filter!) : "" )
        
        DataManager<T>.queryServerForOne(newFilter) { (item) in
            
            serverHandler?(item)
            
        }
        
    }

    open static func queryServer ( _ filter: String, serverHandler: (( _ items: [T]?) -> ())?)->Void {
        
        DispatchQueue(label: "queryServer", attributes: []).async {
            
                ServerStorage<T>.get(filter, completion: { (success, items) in
                    
                    if(success){
                        
                        DispatchQueue.main.async(execute: { () -> Void in
                            serverHandler?(DataManager<T>.copyArray(items))
                        })
                        
                        ClientStorage<T>.retrieve(items)
                        
                    }else{
                        DispatchQueue.main.async(execute: { () -> Void in
                            serverHandler?([])
                        })
                    }
                })
        }
        
    }
    
    
    open static func queryServerForOne ( _ filter: String, serverHandler: (( _ item: T?) -> ())?)->Void {
        
        DispatchQueue(label: "queryServer", attributes: []).async {
            
            ServerStorage<T>.getOne(filter, completion: { (success, item) in
                
                if(success){
                    
                    DispatchQueue.main.async(execute: { () -> Void in
                        serverHandler?(item?.copy() as! T)
                    })
                    
                    if(item != nil){
                        ClientStorage<T>.retrieve(item!)
                    }
                    
                }else{
                    DispatchQueue.main.async(execute: { () -> Void in
                        serverHandler?(nil)
                    })
                }
            })
        }
        
    }

    
    open static func queryServerIfNeeded(_ type: String, filter: String?, isGetNow : Bool,completion: ((_ isQueried: Bool,_ items: [T]) -> ())?){
        
        let newFilter =  type + ( filter != nil ? ("?" + filter!) : "" )
        
        DataManager<T>.queryServerIfNeeded(newFilter, isGetNow: isGetNow) { (isQueried,items) in
             completion?(isQueried,items)
        }
    }
    
    open static func queryServerIfNeeded(_ filter: String,isGetNow : Bool,completion: ((_ isQueried: Bool, _ items: [T]) -> ())?){
        
                if( ClientCaching<T>.isExpired(filter) == false  &&  isGetNow == false){ // not expired
                                        
                        completion?(false,[])
                    
                }else{ // query and caching
                    
                    DispatchQueue(label: "queryServerIfNeeded", attributes: []).async {

                                 ServerStorage<T>.get(filter, completion: { (success, items) in
                                    
                                    if(success){
                                        
                                        ClientStorage<T>.retrieve(items)
                                        ClientCaching<T>.set(filter,  newExpireMinutes: nil)
                                        
                                        DispatchQueue.main.async(execute: { () -> Void in
                                            completion?(true,DataManager<T>.copyArray(items))
                                        })
                                    }
                                 })
                    }
                }
        
    }
 
    open static func getById(_ id: String,isGetNow : Bool,clientHandler: (( _ item: T?) -> ())?,serverHandler: (( _ item: T?) -> ())?){
       
            ClientStorage<T>.getById(id, completion: { (item) in
            
                    if(item != nil && ClientCaching.isExpired(item!) == false && isGetNow == false) {// not expired
                        
                        clientHandler?(item)
                        
                    }else{
                        
                        
                        DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default).async {

                                    ServerStorage<T>.getById(id, completion: { (success, newitem) in
                                        if(success){
                                            
                                            if(newitem != nil){
                                                ClientStorage<T>.retrieve(newitem!)
                                                
                                            }else{
                                                
                                                ClientStorage<T>.deleteById(id)
                                                
                                            }
                                        }
                                            
                                        DispatchQueue.main.async(execute: { () -> Void in
                                            serverHandler?(newitem?.copy() as? T)
                                        })
                                        
                                    })
                        }
                    }
            })
        
        
    }
    
    open static func queryServerById(_ id: String,serverHandler: (( _ item: T?) -> ())?){
        
        
        DispatchQueue(label: "getFromServerById", attributes: []).async {
            
                ServerStorage<T>.getById(id, completion: { (success, newitem) in
                    if(success){
                        
                        if(newitem != nil){
                            ClientStorage<T>.retrieve(newitem!)
                            
                        }else{
                            
                            ClientStorage<T>.deleteById(id)
                            
                        }
                        
                        DispatchQueue.main.async(execute: { () -> Void in
                            serverHandler?(newitem?.copy() as? T)
                        })

                    }
                })
        }
        
    }

    
    open static func getOne(_ clientFilter: String?, serverFilter: String?,isGetNow : Bool, clientHandler: (( _ item: T?) -> ())?,serverHandler: (( _ item: T?) -> ())?){
        
                ClientStorage<T>.getOne(clientFilter, completion: { (item) in
                    
                            if(item != nil && ClientCaching.isExpired(item!) == false && isGetNow == false ) {// not expired
                                
                                DispatchQueue.main.async(execute: { () -> Void in
                                    clientHandler?(item?.copy() as? T)
                                })

                                
                            }else{
                                
                                DispatchQueue(label: "getOne", attributes: []).async {

                                            ServerStorage<T>.getOne(serverFilter, completion: { (success, newitem) in
                                                if(success){
                                                    
                                                    if(newitem != nil){
                                                       
                                                        ClientStorage<T>.retrieve(newitem!)
                                                        
                                                    }else{
                                                        
                                                        ClientStorage<T>.delete(clientFilter, completion: nil)
                                                        
                                                    }
                                                    
                                                    DispatchQueue.main.async(execute: { () -> Void in
                                                        serverHandler?(newitem?.copy() as? T)
                                                    })

                                                }
                                            })
                                }
                                
                            }

                })
    
    }
    
    open static func getAll (_ clientHandler: (( _ items: [T]?) -> ())?,serverHandler: (( _ items: [T]?) -> ())?) {
        DataManager<T>.getAll(false, clientHandler: clientHandler, serverHandler: serverHandler)
    }
    
    open static func getAll ( _ isGetNow : Bool , clientHandler: (( _ items: [T]?) -> ())?,serverHandler: (( _ items: [T]?) -> ())?) {
        
         DataManager<T>.getAll(nil, serverFilter: nil, isGetNow: isGetNow, clientHandler: { (items) in
            
             clientHandler?(items)
            
         }) { (items) in
                
             serverHandler?(items)
         }
        
    }
    
    
    open static func getAll (_ clientFilter: String?, serverFilter: String?, isGetNow : Bool, clientHandler: (( _ items: [T]?) -> ())?,serverHandler: (( _ items: [T]?) -> ())?) {
        
        
        
                ClientStorage<T>.get(clientFilter) {(items) in
                    
                    DispatchQueue.main.async(execute: { () -> Void in
                        clientHandler?(DataManager<T>.copyArray(items))
                    })
                    
                }
                
        
                DispatchQueue(label: "getAll", attributes: []).async {
                        DataManager<T>.queryServerIfNeeded("selectall", filter: serverFilter, isGetNow: isGetNow) { (isQueried,newitems) in
                            
                            if(isQueried){
                                    ClientStorage<T>.get(clientFilter) {(olditems) in
                                        let realm = try! Realm()
                                        
                                        try! realm.write {
                                            
                                            for item in olditems {
                                                let filterArr = newitems.filter({
                                                    $0.id == item.id
                                                })
                                                if ( filterArr.count <= 0 ){
                                                    realm.delete(item)
                                                }
                                            }
                                        }
                                    }
                            }
                            
                            DispatchQueue.main.async(execute: { () -> Void in
                                serverHandler?(DataManager<T>.copyArray(newitems))
                            })
                            
                        }
                }
        
    }

   
    open static func getByField (_ field: String, value: Any, clientHandler: (( _ items: [T]?) -> ())?,serverHandler: (( _ items: [T]?) -> ())?) {
        DataManager<T>.getByField(field, value: value, isGetNow: false, clientHandler: clientHandler, serverHandler: serverHandler)
    }
    
    open static func getByField (_ field: String, value: Any,isGetNow : Bool, clientHandler: (( _ items: [T]?) -> ())?,serverHandler: (( _ items: [T]?) -> ())?) {
        
        let realmFilter = QueryParam<T>(field: field, value: value).RealmQuery
        let restAPIFilter = QueryParam<T>(field: field, value: value).RESTQuery
        
        DataManager<T>.getAll(realmFilter, serverFilter: restAPIFilter, isGetNow: isGetNow, clientHandler: { (items) in
            
            clientHandler?(items)
            
        }) { (items) in
            
            serverHandler?(items)
        }
        
        
    }

    
    open static func getOneByField (_ field: String, value: Any, isGetNow : Bool , clientHandler: (( _ item: T?) -> ())?,serverHandler: (( _ item: T?) -> ())?) {
        
        let realmFilter = QueryParam<T>(field: field, value: value).RealmQuery
        let restAPIFilter = QueryParam<T>(field: field, value: value).RESTQuery
        
        DataManager<T>.getOne(realmFilter, serverFilter: restAPIFilter, isGetNow: isGetNow, clientHandler: { (item) in
            
             clientHandler?(item)
            
        }) { (item) in
                
             serverHandler?(item)
        }
        
    }
    
    open static func getOneByFields (_ params: [QueryParam<T>], isGetNow : Bool, clientHandler: (( _ item: T?) -> ())?,serverHandler: (( _ item: T?) -> ())?)->Void {
        
        let realmFilter = FilterBuilder<T>.getRealmQuery(params)
        let restAPIFilter = FilterBuilder<T>.getRESTQuery(params)
        
        
        DataManager<T>.getOne(realmFilter, serverFilter: restAPIFilter, isGetNow: isGetNow, clientHandler: { (item) in
            
            clientHandler?(item)
            
        }) { (item) in
            
            serverHandler?(item)
        }
        

    }
    
    open static func getByFields (_ params: [QueryParam<T>] , clientHandler: (( _ items: [T]?) -> ())?,serverHandler: (( _ items: [T]?) -> ())?) {
        DataManager<T>.getByFields(params, isGetNow: false, clientHandler: clientHandler, serverHandler: serverHandler)
    }
    
    open static func getByFields (_ params: [QueryParam<T>], isGetNow : Bool , clientHandler: (( _ items: [T]?) -> ())?,serverHandler: (( _ items: [T]?) -> ())?) {
        
        let realmFilter = FilterBuilder<T>.getRealmQuery(params)
        let restAPIFilter = FilterBuilder<T>.getRESTQuery(params)
        
        
        DataManager<T>.getAll(realmFilter, serverFilter: restAPIFilter, isGetNow: isGetNow, clientHandler: { (items) in
            
            clientHandler?(items)
            
        }) { (items) in
            
            serverHandler?(items)
        }

        
    }

        
    open static func create (_ obj: T,params: [String]?,completion: ((_ success: Bool, _ item: T?) -> ())?)->Void {
        
        DispatchQueue(label: "create", attributes: []).async {
            
                ServerStorage<T>.create(obj, params: params,completion: { (success, newitem) in
               
                    DispatchQueue.main.async(execute: { () -> Void in
                        completion?( success , newitem)
                    })
                    
                    if(success){
                        
                        if(newitem != nil){
                            ClientStorage<T>.save(newitem!)
                            ClientStorage<T>.retrieve(newitem!)
                            
                        }else{
                            if(obj.id != nil){
                                ClientStorage<T>.deleteById(obj.id!)
                            }
                        }
                    }
                    
                })
            
        }
        
    }
    open static func create (_ obj: T,completion: ((_ success: Bool, _ item: T?) -> ())?)->Void {
        
    //    dispatch_async(dispatch_queue_create("create", nil)) {

                ServerStorage<T>.create(obj, completion: { (success, newitem) in
          
                    //dispatch_async(dispatch_get_main_queue(), { () -> Void in
                          completion?( success , newitem)
                  //  })
                    
                    if(success){
                        
                        if(newitem != nil){
                            ClientStorage<T>.save(newitem!)
                            ClientStorage<T>.retrieve(newitem!)
                            
                        }else{
                            if(obj.id != nil){
                                ClientStorage<T>.deleteById(obj.id!)
                            }
                        }
                    }

                })
       // }
    }
    
    
    open static func update (_ obj: T,params: [String]?,completion: ((_ success: Bool, _ item: T?) -> ())?)->Void {
        
     //   dispatch_async(dispatch_queue_create("update", nil)) {
            
            ServerStorage<T>.update(obj, params: params,completion: { (success, newitem) in
                
             //   dispatch_async(dispatch_get_main_queue(), { () -> Void in
                       completion?( success , newitem)
              //  })
                
                if(success){
                    
                    if(newitem != nil){
                        ClientStorage<T>.save(newitem!)
                        ClientStorage<T>.retrieve(newitem!)
                        
                    }else{
                        if(obj.id != nil){
                            ClientStorage<T>.deleteById(obj.id!)
                        }
                    }
                }
                
            })
            
       // }
        
    }
    open static func update (_ obj: T,completion: ((_ success: Bool, _ item: T?) -> ())?)->Void {
        
      //  dispatch_async(dispatch_queue_create("update", nil)) {
            
            ServerStorage<T>.update(obj, completion: { (success, newitem) in
                
              //  dispatch_async(dispatch_get_main_queue(), { () -> Void in
                       completion?( success , newitem)
              //  })
                
                if(success){
                    
                    if(newitem != nil){
                        ClientStorage<T>.save(newitem!)
                        ClientStorage<T>.retrieve(newitem!)
                        
                    }else{
                        if(obj.id != nil){
                            ClientStorage<T>.deleteById(obj.id!)
                        }
                    }
                }
                
            })
       // }
    }
    
    
    
    
    
    open static func delete (_ obj: T,completion:(()->Void)?)->Void {
        
     //   dispatch_async(dispatch_queue_create("delete", nil)) {
                    ServerStorage<T>.delete(obj) {
                        ClientStorage<T>.delete(obj)
             //           dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            completion?()
            //            })
                    }
     //   }
        
    }
    
    open static func deleteByField(_ field: String, value: Any,completion: ((_ deleted: Int)->Void)?)->Void {
        
        
      //  dispatch_async(dispatch_queue_create("deleteByField", nil)) {
            
                    let realmFilter = QueryParam<T>(field: field, value: value).RealmQuery
                    ClientStorage<T>.delete(realmFilter) { (deleted) in
                        
                    }
                    
                    let restAPIFilter = QueryParam<T>(field: field, value: value).RESTQuery
                    ServerStorage<T>.delete(restAPIFilter) { (deleted) in

                     //   dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            completion?(deleted)
                   //     })

                    }
       // }
    }
    
    
    open static func deleteByFields(_ fields : Dictionary<String,Any> , completion: ((_ deleted: Int)->Void)?)->Void {
        
        
        var params : [QueryParam<T>] = []

        fields.forEach { (field,value) in

            params .append(QueryParam<T>(field: field, value: value))

        }
       
        let realmFilter =  FilterBuilder.getRealmQuery(params)
        ClientStorage<T>.delete(realmFilter) { (deleted) in
            
        }
        
        let restAPIFilter =  FilterBuilder.getRESTQuery(params)
        ServerStorage<T>.delete(restAPIFilter) { (deleted) in
            
            completion?(deleted)
                        
        }

    }

    
}

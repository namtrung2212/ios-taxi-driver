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
import JWT
import SClientModel


open class ServerStorage<T:BaseModel> {
          
    open static  var Token: String?{
        
        get {
            let token = UserDefaults.standard.string(forKey: "Token")
            
            return token == nil ? "" : token!
        }
    }
        
    open static func get (_ filter: String,completion: ((_ result : Double?) -> ())?)->Void {
        
        var url : String = SClientData.ServerURL + "/" + String(describing: T) + "/" +  filter
        let headers = [ "Token" : Token! , "Hash" : CryptoHelper.generateHashKey( String(describing: T) + "/" +  filter) ]
        
        Alamofire.request(Method.GET,  url, headers:  headers)
            .responseString  { (response: Response<String, NSError>) in
                
                if(response.result.value != nil){
                    completion?(result: Double(response.result.value!))
                    
                }else{
                    completion?(result: nil)
                }
                
        }
        
    }

    
    open static func get (_ filter: String,completion: ((_ result : String?) -> ())?)->Void {
        
            var url : String = SClientData.ServerURL + "/" + String(describing: T) + "/" +  filter
            let headers = [ "Token" : Token! , "Hash" : CryptoHelper.generateHashKey( String(describing: T) + "/" +  filter) ]
        
            Alamofire.request(Method.GET, url, headers: headers)
                .responseString  { (response: Response<String, NSError>) in
                    
                    if(response.result.value != nil){
                        completion?(result: response.result.value!)
                        
                    }else{
                        completion?(result: nil)
                    }
                    
            }
        
    }


    
    open static func get (_ filter: String,completion: ((_ success: Bool, _ items: [T]) -> ())?)->Void {
        
        
            var url : String = SClientData.ServerURL + "/" + String(describing: T) + "/" +  filter
            let headers = [ "Token" : Token! , "Hash" : CryptoHelper.generateHashKey( String(describing: T) + "/" +  filter) ]
        
            Alamofire.request(Method.GET,url, headers: headers)
                .responseArray { (response: Response<[T], NSError>) in
                    
                    switch response.result {
                        
                    case .success:
                        let newitems = response.result.value
                        
                        if  newitems != nil {
                            completion?(success: true, items: newitems!)
                            
                        }else{
                             completion?(success: false, items: [T]())
                        }
                        
                    case .failure(_):
                                completion?(success: false, items: [T]())
                                break
                    }
            }

        
    }
 
    
    
    
    open static func getOne (_ filter: String,completion: ((_ success: Bool, _ item: T?) -> ())?)->Void {
        
        var url : String = SClientData.ServerURL + "/" + String(describing: T) + "/" +  filter
        let headers = [ "Token" : Token! , "Hash" : CryptoHelper.generateHashKey( String(describing: T) + "/" +  filter) ]

        
        Alamofire.request(Method.GET,url, headers:headers)
            .responseObject { (response: Response<T, NSError>) in
                
                switch response.result {
                    
                case .success:
                    let newitem = response.result.value
                    
                    if  newitem != nil {
                        completion?(success: true, item: newitem!)
                        
                    }else{
                        completion?(success: false, item: nil)
                    }
                    
                case .failure(_):
                    completion?(success: false, item: nil)
                    break
                }
        }
        
        
    }

    
    open static func getById (_ id: String,completion: ((_ success: Bool, _ item: T?) -> ())?)->Void {
        
                var url = "/" + String(describing: T) + "/ID/" + id
                let headers = [ "Token" : Token! , "Hash" : CryptoHelper.generateHashKey( url) ]
                
                url = SClientData.ServerURL + url
        
                Alamofire.request(Method.GET, url, headers: headers)
                    .responseObject(completionHandler: { (response: Response<T, NSError>) in
                        
                        switch response.result {
                            
                        case .success:
                            
                                    let newitem = response.result.value
                                    if newitem != nil {
                                        
                                        if(newitem!.id == nil){
                                            completion?(success: true, item: nil)
                                            
                                        }else{
                                            completion?(success: true, item: newitem)
                                        }
                                        
                                    }else{
                                         completion?(success: false, item: nil)
                                    }
                            
                        case .failure(_):
                            
                                    completion?(success: false, item: nil)
                                    break
                        }
                    })
                
        

    }
    
    open static func getOne (_ filter: String?,completion: ((_ success: Bool, _ item: T?) -> ())?)->Void {
        
        
                        var url = "/" + String(describing: T)
            
                        if ( filter != nil ){
                            url = url + "/selectall?" + filter! + "&page=1&pagesize=1";
                        }else{
                            url = url + "/selectall?page=1&pagesize=1";
                        }
        
                        let headers = [ "Token" : Token! , "Hash" : CryptoHelper.generateHashKey( url) ]
                        
                        url = SClientData.ServerURL + url

        
                        Alamofire.request(Method.GET, url, headers: headers)
                            .responseArray { (response: Response<[T], NSError>) in
                                
                                switch response.result {
                                    
                                case .success:
                                        let items = response.result.value
                                        
                                        if let items = items {
                                            
                                                if (items.count>0){
                                                    
                                                    if(items[0].id == nil){
                                                        completion?(success: true, item: nil)
                                                        
                                                    }else{
                                                        completion?(success: true, item: items[0])
                                                    }

                                                }else{
                                                    completion?(success: true, item: nil)
                                                }
                                        }
                                    
                                case .failure(_):
                                    
                                            completion?(success: false, item: nil)
                                            break
                                }
                        }
        
        
    }
    
    
    open static func create (_ obj: T,params: [String]? ,completion: ((_ success: Bool, _ item: T?) -> ())?)->Void {
        
            let filtered = Mapper().toJSON(obj).filter { (item) -> Bool in
                
                if( params != nil ) {
                    return params!.contains(item.0)
                }
                
                return true;
            }
            var newParams = [String:AnyObject]()
            for result in filtered {
                newParams[result.0] = result.1
            }
        
            var url = "/" + String(describing: T) + "/create"
            let headers = ["Content-Type": "text/plain",  "Token" : Token! , "Hash" : CryptoHelper.generateHashKey( url + newParams.description) ]
            
            url = SClientData.ServerURL + url

        
            Alamofire.request(.POST, url, parameters: newParams,encoding: .json, headers: headers)
                .responseObject(completionHandler: { (response: Response<T, NSError>) in
                
                    
                    switch response.result {
                        
                    case .success:
                        
                        let newitem = response.result.value
                        if newitem != nil {
                            
                            if(newitem!.id == nil){
                                completion?(success: true, item: nil)
                                
                            }else{
                                completion?(success: true, item: newitem)
                            }
                            
                        }else{
                            completion?(success: false, item: nil)
                        }
                        
                    case .failure(_):
                        
                        completion?(success: false, item: nil)
                        break
                    }

        
            })
        
        
    }
    open static func create (_ obj: T,completion: ((_ success: Bool, _ item: T?) -> ())?)->Void {
        
                let params =  (obj as Mappable).toJSON()
                var url = "/" + String(describing: T) + "/create"
                let headers = [ "Content-Type": "text/plain", "Token" : Token! , "Hash" : CryptoHelper.generateHashKey( url + params.description) ]
                
                url = SClientData.ServerURL + url

        
            Alamofire.request(.POST, url, parameters: params,encoding: .json, headers: headers)
                .responseObject(completionHandler: { (response: Response<T, NSError>) in
                    
                    switch response.result {
                        
                    case .success:
                        
                        let newitem = response.result.value
                        if newitem != nil {
                            
                            if(newitem!.id == nil){
                                completion?(success: true, item: nil)
                                
                            }else{
                                completion?(success: true, item: newitem)
                            }
                            
                        }else{
                            completion?(success: false, item: nil)
                        }
                        
                    case .failure(_):
                        
                        completion?(success: false, item: nil)
                        break
                    }

                })
        
        
    }
        
    open static func createBulk (_ objs: [T],completion:(()->Void)?)->Void {
        
    }
    
    open static func update (_ obj: T,params: [String]?,completion: ((_ success: Bool, _ item: T?) -> ())?)->Void {
        
            let filtered = Mapper().toJSON(obj).filter { (item) -> Bool in
                
                if( params != nil ) {
                    return params!.contains(item.0)
                }
                
                return true;
            }
            var newParams = [String:AnyObject]()
            for result in filtered {
                newParams[result.0] = result.1
            }

            var url =  "/" + String(T) + "/ID/" + obj.id!
            let headers = [ "Content-Type": "text/plain", "Token" : Token! , "Hash" : CryptoHelper.generateHashKey( url + newParams.description) ]
            
            url = SClientData.ServerURL + url

        
            Alamofire.request(.PATCH, url, parameters: newParams,encoding: .json, headers: headers)
                .responseObject(completionHandler: { (response: Response<T, NSError>) in
                    
                    switch response.result {
                        
                    case .success:
                        
                        let newitem = response.result.value
                        if newitem != nil {
                            
                            if(newitem!.id == nil){
                                completion?(success: true, item: nil)
                                
                            }else{
                                completion?(success: true, item: newitem)
                            }
                            
                        }else{
                            completion?(success: false, item: nil)
                        }
                        
                    case .failure(_):
                        
                        completion?(success: false, item: nil)
                        break
                    }
                    
                })
        
    }
    open static func update (_ obj: T,completion: ((_ success: Bool, _ item: T?) -> ())?)->Void {
        
                let params = Mapper().toJSON(obj)
                let paramstring = Mapper().toJSONString(obj)
                var url =  "/" + String(T) + "/ID/" + obj.id!
        
                let headers = ["Content-Type": "text/plain", "Token" : Token! , "Hash" : CryptoHelper.generateHashKey( url + params.description) ]
                
                url = SClientData.ServerURL + url

        
                Alamofire.request(.PATCH, url, parameters: params,encoding: .json, headers: headers)
                    .responseObject(completionHandler: { (response: Response<T, NSError>) in
                        
                        switch response.result {
                            
                        case .success:
                            
                            let newitem = response.result.value
                            if newitem != nil {
                                
                                if(newitem!.id == nil){
                                    completion?(success: true, item: nil)
                                    
                                }else{
                                    completion?(success: true, item: newitem)
                                }
                                
                            }else{
                                completion?(success: false, item: nil)
                            }
                            
                        case .failure(_):
                            
                            completion?(success: false, item: nil)
                            break
                        }
                        
                    })
        
    }
    
    open static func updateBulk (_ objs: [T],completion: (()->Void)?)->Void {
        
    }
    
    
    open static func delete (_ obj: T,completion:(()->Void)?)->Void {
        
            var url =  "/" + String(T) + "/ID/"  + obj.id!
            let headers = ["Content-Type": "text/plain",  "Token" : Token! , "Hash" : CryptoHelper.generateHashKey( url ) ]
            
            url = SClientData.ServerURL + url

        
            Alamofire.request(.DELETE, url, headers: headers ).responseString { response in
                
                        completion?()
            }
        
    }
    
    open static func delete (_ filter: String?,completion: ((_ deleted: Int) -> ())?)->Void {
        
            var url =  "/" + String(describing: T) + "/delete"
        
            if(filter != nil){
                url = url + "?" + filter!
            }
            let headers = [ "Content-Type": "text/plain", "Token" : Token! , "Hash" : CryptoHelper.generateHashKey( url ) ]
            
            url = SClientData.ServerURL + url
        
            Alamofire.request(.DELETE, url, headers: headers).responseString { response in
                        completion?(deleted: Int(response.result.value!)!)
            }
        
    }
    
    open static func delete (_ objs: [T])->Void {
        objs.forEach { (obj) in
            delete(obj, completion:nil)
        }
    }
    
    
}

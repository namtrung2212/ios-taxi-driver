//
//  FilterBuilder.swift
//  BOOKTAXI
//
//  Created by Trung Dao on 4/9/16.
//  Copyright © 2016 SCONNECTING. All rights reserved.

import Foundation

import SClientModel

public struct QueryParam<T:BaseModel> {
    var field : String
    var value : Any
    
    var RESTQuery : String {
        get {
            let type = ObjectReflection.getPropertyType(T.self, propertyName: field)
            
            switch  type! {
                
            case  "String" , "Optional<String>":
                return field + "=" + String(value as! String)
                
            case  "NSDate" , "Optional<NSDate>":
                return field + "=" + MongoDateTransform.stringFromDate(value as! Date)
                
            case  "Double" , "Optional<Double>":
                return field + "=" + String(value as! Double)
                
            case  "Int" , "Optional<Int>":
                return field + "=" + String(value as! Int)
                
            case  "Bool" , "Optional<Bool>":
                return field + "=" + String(value as! Int)
                
            default:
                return ""
            }
            
        }
    }
    
    
    var RealmQuery : String {
        get {
            let type = ObjectReflection.getPropertyType(T.self, propertyName: field)
            
            switch  type! {
                
            case  "String" , "Optional<String>":
                return field + " == '" + String(value as! String) + "'"
                
            case  "NSDate" , "Optional<NSDate>":
                return field + " == " + MongoDateTransform.stringFromDate(value as! Date)
                
            case  "Double" , "Optional<Double>":
                return field + " == " + String(value as! Double)
                
            case  "Int" , "Optional<Int>":
                return field + " == " + String(value as! Int)
                
            case  "Bool" , "Optional<Bool>":
                return field + " == " + String(value as! Int)
                
            default:
                return ""
            }
            
        }
    }
    
    
    
    
}

open class FilterBuilder<T:BaseModel> {
    
    open static func getRealmQuery(_ params: [QueryParam<T>]) -> String{
        
        var arr = [String]()
        
        for param in params {
            arr.append(param.RealmQuery)
        }
        
        return arr.joined(separator: " AND ")
    }
    
    
    open static func getRESTQuery(_ params: [QueryParam<T>]) -> String{
        
        var arr = [String]()
        
        for param in params {
            arr.append(param.RESTQuery)
        }
        
        return arr.joined(separator: "&")
    }
    
}

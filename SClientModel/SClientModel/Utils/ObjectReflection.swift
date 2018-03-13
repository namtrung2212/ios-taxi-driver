//
//  ObjectReflection.swift
//  BOOKTAXI
//
//  Created by Trung Dao on 4/9/16.
//  Copyright © 2016 SCONNECTING. All rights reserved.
//

import Foundation


open class ObjectReflection: NSObject {
    
    
    
    open static func propertyNames(_ objClass : AnyClass) -> Array<String> {
        var results: Array<String> = [];
        
        // retrieve the properties via the class_copyPropertyList function
        var count: UInt32 = 0;
        
        
        let properties = class_copyPropertyList(objClass, &count);
        
        // iterate each objc_property_t struct
        for i: UInt32 in 0 ..< count {
            let property = properties?[Int(i)];
            
            // retrieve the property name by calling property_getName function
            let cname = property_getName(property);
            // var ctype = property_getAttributes(property);
            //    var nametype = String.fromCString(ctype);
            // covert the c string into a Swift string
            let name = String(cString: cname!);
            results.append(name);
        }
        
        // release objc_property_t structs
        free(properties);
        
        return results;
    }
    
    
    open static func getProperties(_ objType: NSObject.Type) -> Array<String> {
        
         var results: Array<String> = [];
        
        let instance = objType.init()
        let mirror = Mirror(reflecting: instance)
        
        for case let (label?, value) in mirror.children {
            results.append(label);
        }
        
        let mirror2 = mirror.superclassMirror
        for case let (label?, value) in mirror2!.children {
            results.append(label);
        }
        
        return results;
    
    }
    
    open static func getPropertyType(_ parentType: NSObject.Type, propertyName: String) ->String? {
        let instance = parentType.init()
        let mirror = Mirror(reflecting: instance)
        
        for case let (label?, value) in mirror.children {
            if(label == propertyName){
                return String(describing: type(of: (value) as AnyObject))
                
            }
        }
        
        let mirror2 = mirror.superclassMirror
        for case let (label?, value) in mirror2!.children {
            if(label == propertyName){
                return String(describing: type(of: (value) as AnyObject))
                
            }
        }
        
        
        return nil
    }
    
    
    
    
}

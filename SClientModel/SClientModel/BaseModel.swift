//
//  BaseModel.swift
//  BOOKTAXI
//
//  Created by Trung Dao on 4/8/16.
//  Copyright © 2016 SCONNECTING. All rights reserved.
//
import RealmSwift
import ObjectMapper


open class BaseModel: Object,Mappable,NSCopying {
    
    open dynamic var id : String?
    open dynamic var createdAt : Date?
   open  dynamic var updatedAt : Date?
   open dynamic var retrieveAt : Date?
   open dynamic var useAt : Date?
    
    
    open static var TableName: String = ""
    
    override open static func ignoredProperties() -> [String] {
        return ["cacheMinutes"]
    }

    override open static func primaryKey() -> String? {
        return "id"
    }
    
    //Impl. of Mappable protocol
    convenience public  required init?(_ map: Map) {
        self.init()
    }

    
 
    
    open func mapping(_ map: Map) {
        id    <- map["_id"]
        createdAt <- (map["createdAt"], MongoDateTransform())
        updatedAt <- (map["updatedAt"], MongoDateTransform())
    }
      
    open func copy(with zone: NSZone?) -> Any {
        
        var properites: Array<String> =  ObjectReflection.getProperties( type(of: self))
        
        let newObj =  type(of: self).init()
        
        for i in 0 ..< properites.count {
            var proName = String(properites[i])
            
            let value = self.value(forKey: proName)
            
            newObj.setValue(value, forKey: proName)
        }
        
        return newObj
    }
    
    open func isNew() -> Bool{
        return self.id == nil
        
    }
        
}

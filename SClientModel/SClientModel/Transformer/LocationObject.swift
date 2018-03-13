
import UIKit
import Realm
import RealmSwift
import ObjectMapper
import SwiftyJSON
import CoreLocation

open class LocationObject: Object {
   open dynamic var long: Double = 0
   open dynamic var lat: Double = 0
    
    public init(coordinate: CLLocationCoordinate2D){
        super.init()
        self.long = coordinate.longitude
        self.lat = coordinate.latitude
    }

    
   public init(latitude: Double, longitude: Double){
        super.init()
        self.long = longitude
        self.lat = latitude
    }
    
    required public init() {
        super.init()
    }
    
    required public init(realm: RLMRealm, schema: RLMObjectSchema) {
        super.init(realm: realm, schema: schema)
    }
    
    required public init(value: AnyObject, schema: RLMSchema) {
        super.init(value: value, schema: schema)
    }
    
    open func coordinate() -> CLLocationCoordinate2D{
        return CLLocationCoordinate2D(latitude: self.lat, longitude: self.long)
    }
}

open class LocationTransform : TransformType {
    public typealias Object = LocationObject
    public typealias JSON = [NSNumber]
    
    
    open func transformFromJSON(_ value: AnyObject?) -> LocationObject? {
   
        var result :LocationObject? = nil
     
        if let arr = value as! [NSNumber]? {
         
            result = LocationObject()
            result!.lat = Double(arr[0] )
            result!.long = Double(arr[1] )
            
        }
        
        return result
    }
    
    
    open func transformToJSON(_ value: LocationObject?) -> JSON? {
        
        var results = [NSNumber]()
        if let value = value {
            
            results.append(value.lat as NSNumber )
            results.append(value.long as NSNumber)
            
        }
        
        return results
    }
}

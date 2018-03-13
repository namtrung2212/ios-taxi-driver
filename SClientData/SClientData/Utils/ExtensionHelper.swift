import Foundation
import ObjectiveC

open class ExHelper {
    
    open static func getter<ValueType: AnyObject>(_ base: AnyObject,key: UnsafePointer<UInt8>,initialiser: () -> ValueType)-> ValueType {
        
        if let associated = objc_getAssociatedObject(base, key) as? ValueType {
            return associated
        }
        
        let associated = initialiser()
        objc_setAssociatedObject(base, key, associated, .OBJC_ASSOCIATION_RETAIN)
        return associated
    }

    open static func setter<ValueType: AnyObject>(_ base: AnyObject,key: UnsafePointer<UInt8>,value: ValueType) {
        objc_setAssociatedObject(base, key, value, .OBJC_ASSOCIATION_RETAIN)
    }
}



import UIKit
import Foundation
import ObjectMapper
import AlamofireObjectMapper
import SClientData
import SClientModel
import CoreLocation
import RealmSwift
import GoogleMaps
import  SocketIOClientSwift

open class SNotificationManager : NSObject {
    
    open var taxiSocket : TaxiSocket
    open var chatSocket : ChatSocket
    
    public override init(){
        
        taxiSocket = TaxiSocket()
        chatSocket = ChatSocket()
        
        super.init()
        
    }
    
}



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

open class TaxiSocket  {
    
    
    open static var ServerURL: String = "http://localhost:4050"

    open var socket : SocketIOClient
    
    open var delegate: TaxiSocketDelegate?
    

    public init(){
        
        socket = SocketIOClient(socketURL: URL(string: TaxiSocket.ServerURL)!, options: [.log(true), .forcePolling(true)])
        socket.reconnects = true
        
        self.addHandlers()
    }
    
    open func connect(_ completion: (() -> ())?){
        
        socket.on("connect") {data, ack in
            self.loggin()
            completion?()
        }
        
        
        socket.connect()
        
    }
    
    
    open func addHandlers(){
        
        socket.on("disconnect") {data, ack in
            self.socket.connect()
        }

        socket.on("DriverLogged") {data, ack in
            self.delegate?.onTaxiSocketLogged(data)
        }

        
        
        socket.on("CarUpdateLocation") {data, ack in
            self.delegate?.onCarUpdateLocation(data)
        }

        socket.on("UserViewDriverProfile") {data, ack in
             self.delegate?.onUserViewDriverProfile(data)
        }
        
        socket.on("UserRequestTaxi") {data, ack in
          
            self.delegate?.onUserRequestTaxi(data)
        }
        
        socket.on("UserCancelRequest") {data, ack in
            self.delegate?.onUserCancelRequest(data)
        }

        
        socket.on("UserAcceptBidding") {data, ack in
            self.delegate?.onUserAcceptBidding(data)
        }
        
        socket.on("UserCancelBidding") {data, ack in
            self.delegate?.onUserCancelBidding(data)
        }

        socket.on("UserVoidedBfPickup") {data, ack in
              self.delegate?.onUserVoidedBfPickup(data)
        }
        
        socket.on("UserVoidedAfPickup") {data, ack in
             self.delegate?.onUserVoidedAfPickup(data)
        }
        
        socket.on("UserPaid") {data, ack in
             self.delegate?.onUserPaid(data)
        }
        
    }

        
}

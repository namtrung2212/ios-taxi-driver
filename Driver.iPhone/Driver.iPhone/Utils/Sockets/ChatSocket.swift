

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


public protocol ChatSocketDelegate {
    
    func onChatSocketLogged(_ data : [AnyObject])
    
    func onUserChat(_ data : [AnyObject])
    
}

open class ChatSocket  {
    
    
    open static var ServerURL: String = "http://localhost:4060"
    
    open var socket : SocketIOClient
    
    open var delegate: ChatSocketDelegate?
    
    
    public init(){
        
        socket = SocketIOClient(socketURL: URL(string: ChatSocket.ServerURL)!, options: [.log(true), .forcePolling(true)])
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
            self.delegate?.onChatSocketLogged(data)
        }
        
        
        socket.on("UserChat") {data, ack in
            self.delegate?.onUserChat(data)
        }
        
    }
    
    open func loggin(){
        socket.emit("DriverLogin", ["DriverID": SCONNECTING.DriverManager!.CurrentDriver!.id!])
    }
    
    open func chat(_ order: TravelOrder, message: TravelOrderChatting){
        
        socket.emit("DriverChat", ["DriverID": SCONNECTING.DriverManager!.CurrentDriver!.id! , "UserID" : order.User! , "OrderID" : order.id! , "ContentID" : message.id!, "Content" : message.Content! ])
        
    }
    
    
}

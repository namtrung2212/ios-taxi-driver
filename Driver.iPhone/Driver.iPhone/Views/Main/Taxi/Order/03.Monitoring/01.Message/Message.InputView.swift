//
//  Order.Travel.Message.swift
//  User.iPhone
//
//  Created by Trung Dao on 5/26/16.
//  Copyright © 2016 SCONNECTING. All rights reserved.
//

import UIKit
import Foundation
import ObjectMapper
import AlamofireObjectMapper
import SClientData
import SClientModel
import CoreLocation
import RealmSwift
import GoogleMaps
import DTTableViewManager
import DTModelStorage
import SClientModelControllers
import AlamofireImage
import RealmSwift




open class ChattingInputView: UIViewController, UITextFieldDelegate{
    
    open var parent: TravelChattingView!
    var pnlContentArea: UIView!
    var pnlButtonArea: UIView!
    var txtMessage: UITextField!
    var btnSend: UIButton!
    
    var txtMessageHeight: NSLayoutConstraint!
    
    var CurrentOrder: TravelOrder! {
        
        get {
            return self.parent.CurrentOrder
        }
    }
    
    
    public init(parent: TravelChattingView){
        
        self.parent = parent
        super.init(nibName: nil, bundle: nil)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

//
//  File.swift
//  User.iPhone
//
//  Created by Trung Dao on 5/13/16.
//  Copyright © 2016 SCONNECTING. All rights reserved.
//

import Foundation
//
//  HomeViewController.swift
//  User.iPhone
//
//  Created by Trung Dao on 4/13/16.
//  Copyright © 2016 SCONNECTING. All rights reserved.
//
import UIKit
import Foundation
import ObjectMapper
import AlamofireObjectMapper
import AlamofireImage
import SClientData
import SClientModel
import SClientModelControllers

import CoreLocation
import RealmSwift
import GoogleMaps

extension LeftMenuViewController {
    
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
       
        
    }

    public func leftWillOpen(){
         self.resetScrollSize()
    }
    public func leftDidOpen(){
        
        self.resetScrollSize()
    }
 

}

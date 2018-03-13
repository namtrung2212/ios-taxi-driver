//
//  Map.swift
//  Driver.iPhone
//
//  Created by Trung Dao on 8/3/16.
//  Copyright © 2016 SCONNECTING. All rights reserved.
//

import Foundation


extension TravelOrderScreen {
    
    func initMapControls(_ completion: (() -> ())?){
        
        mapView.initControls{
            completion?()
        }
    }
    
    func initMapLayout(_ completion: (() -> ())?){
        
        mapView.initLayout{
            completion?()
        }
        
    }
    
    func invalidateMapView(_ completion: (() -> ())?){
        
        mapView.invalidate {
            completion?()
        }
        
    }
    
    
}

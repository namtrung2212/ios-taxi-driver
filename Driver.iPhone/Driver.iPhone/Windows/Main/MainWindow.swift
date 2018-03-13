//
//  MainWindow.swift
//  User.iPhone
//
//  Created by Trung Dao on 5/4/16.
//  Copyright © 2016 SCONNECTING. All rights reserved.
//

import UIKit
import Foundation
import ObjectMapper
import Alamofire
import AlamofireObjectMapper
import SClientData
import SClientModel
import SClientUI
import CoreLocation
import RealmSwift
import SwiftyJSON
import GoogleMaps

open class MainWindow: UIWindow, UITabBarControllerDelegate{
    
    
    open var leftMenu : SlideMenuController!
    open var leftViewCtrl : LeftMenuViewController!
        
    open var taxiViewCtrl : TravelOrderScreen!
    open var taxiNAVCtrl : UINavigationController!
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.initAppearance()
        
        self.bounds = UIScreen.main.bounds
        self.backgroundColor = UIColor.white
        
        taxiViewCtrl =  TravelOrderScreen(nibName: nil, bundle: nil)
        taxiNAVCtrl = UINavigationController(rootViewController: taxiViewCtrl)
        taxiNAVCtrl.navigationBar.barStyle = .default
        taxiNAVCtrl.navigationBar.layer.shadowColor = UIColor.gray.cgColor
        taxiNAVCtrl.navigationBar.layer.shadowOpacity = 0.7
        taxiNAVCtrl.navigationBar.layer.shadowOffset = CGSize(width: 0, height: 3)
        taxiNAVCtrl.navigationBar.layer.shadowRadius = 2.5
        taxiNAVCtrl.navigationBar.layer.shouldRasterize = true
        taxiNAVCtrl.navigationBar.layer.shadowPath = UIBezierPath(rect: taxiNAVCtrl.navigationBar.bounds).cgPath
        
        taxiViewCtrl.navigationController?.isNavigationBarHidden = false
        
        
        leftViewCtrl =  LeftMenuViewController(nibName: nil, bundle: nil)
        leftMenu = SlideMenuController(mainViewController: taxiNAVCtrl, leftMenuViewController: leftViewCtrl)
        leftMenu.delegate = leftViewCtrl
        
        self.rootViewController = leftMenu
        
        
    }
    
    func initAppearance(){       
        
        
        UINavigationBar.appearance().isTranslucent = true
        UINavigationBar.appearance().barTintColor =  UIColor(red: 73.0/255.0, green: 139.0/255.0, blue: 199.0/255.0, alpha: 1.0)
        UINavigationBar.appearance().tintColor =  UIColor.white
        
        UINavigationBar.appearance().layer.shadowColor = UIColor.gray.cgColor
        UINavigationBar.appearance().layer.shadowOpacity = 0.7
        UINavigationBar.appearance().layer.shadowOffset = CGSize(width: 0, height: 3)
        UINavigationBar.appearance().layer.shadowRadius = 2.5
        UINavigationBar.appearance().layer.shadowPath = UIBezierPath(rect: UINavigationBar.appearance().bounds).cgPath
        UINavigationBar.appearance().layer.shouldRasterize = true
        
        let attrs = [
            NSForegroundColorAttributeName : UIColor.white,
            NSFontAttributeName : UIFont(name: "HelveticaNeue-Bold", size: 15)!
        ]
        
        UINavigationBar.appearance().titleTextAttributes = attrs
        
        
        UILabel.appearance().font = UIFont(name: "HelveticaNeue-Light", size: 12)
        
        // UIButton.appearance().titleLabel.font = UIFont(name: "HelveticaNeue-Light", size: 12)
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        self.init()
    }
    
}

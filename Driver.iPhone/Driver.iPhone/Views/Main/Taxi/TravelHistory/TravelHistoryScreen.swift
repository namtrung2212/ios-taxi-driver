//
//  TripMateViewController.swift
//  User.iPhone
//
//  Created by Trung Dao on 4/13/16.
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

open class TravelHistoryScreen: UIViewController {
    
    var historyTable: TravelHistoryTable!
    
    var lblNoTravel: UILabel!
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        self.initControls{
            
        }
    }
    
    
    func initControls(_ completion: (() -> ())?){
        
        
        let btnBack = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(TravelHistoryScreen.btnBack_Clicked))
        btnBack.setFAIcon(FAType.faArrowLeft, iconSize : 20)
        btnBack.setTitlePositionAdjustment(UIOffsetMake(0, -5), for: .default)
        self.navigationItem.leftBarButtonItem = btnBack
        self.navigationItem.title = "Đã phục vụ"
        
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.white]
        self.navigationController!.navigationBar.titleTextAttributes = titleDict as? [String : AnyObject]
        
        
        lblNoTravel = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 50))
        lblNoTravel.font = UIFont(name: "HelveticaNeue", size: 14)
        lblNoTravel.textColor = UIColor.darkGray
        lblNoTravel.textAlignment = NSTextAlignment.center
        lblNoTravel.text = "Không có chuyến nào."
        lblNoTravel.translatesAutoresizingMaskIntoConstraints = false
        lblNoTravel.isHidden = true
        
        historyTable = TravelHistoryTable(parent: self)
        historyTable.initControls{
            self.historyTable.initLayout{
                
                self.view.addSubview(self.lblNoTravel)
                self.lblNoTravel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 110.0).isActive = true
                self.lblNoTravel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant : 0.0).isActive = true
                self.lblNoTravel.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.95).isActive = true
                self.lblNoTravel.heightAnchor.constraint(equalToConstant: 15).isActive = true
                

                self.historyTable.invalidate()
                
                completion?()
            }
        }
        
        
    }
    
    
    open func btnBack_Clicked() {
        
        self.navigationController?.popViewController(animated: true)
        AppDelegate.mainWindow?.leftViewCtrl.invalidate{
            
        }
        AppDelegate.mainWindow?.taxiViewCtrl.slideMenuController()?.openLeft()
        
    }
    
}

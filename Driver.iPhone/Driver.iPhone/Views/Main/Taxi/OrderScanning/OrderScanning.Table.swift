//
//  Driver.Profile.Comment.swift
//  User.iPhone
//
//  Created by Trung Dao on 6/1/16.
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

import SClientModelControllers
import DTTableViewManager
import DTModelStorage
import AlamofireImage


open class OrderScanningTable : UITableViewController, DTTableViewManageable {
    
    open var parent: OrderScanningScreen
    
    var currentPages = 1
    public init(parent: OrderScanningScreen){
        
        self.parent = parent
        super.init(nibName: nil, bundle: nil)
        
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl!.addTarget(self, action: #selector(OrderScanningTable.refresh(_:)), for: .valueChanged)
        self.tableView.addSubview(self.refreshControl!)
        
        manager.startManagingWithDelegate(self)
        manager.registerCellClass(OrderScanningCell)
        manager.cellSelection(OrderScanningTable.selectedItem)
        
    }
    
    open func selectedItem(_ cell: OrderScanningCell, item: TravelOrder, indexPath: IndexPath) {
        
        UIView.animate(withDuration: 0.1 ,
                                   animations: {
                                    cell.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            },
                                   completion: { finish in
                                    UIView.animate(withDuration: 0.1, animations: {
                                        cell.transform = CGAffineTransform.identity
                                    })
                                    
                                    let instance  =  OrderBiddingScreen(travelOrder: item)
                                    instance.invalidate(item)
                                    self.parent.navigationController?.pushViewController(instance, animated:true)
                                    
                                    
        })
        
        
    }
    

    open func initControls(_ completion: (() -> ())?){
        
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        self.tableView.backgroundColor = UIColor(red: 222/255.0, green: 220/255.0, blue: 222/255.0, alpha: 1.0)
        completion?()
    }
    
    open func initLayout(_ completion: (() -> ())?){
        
        self.parent.view.addSubview(self.tableView)
        self.tableView.widthAnchor.constraint(equalTo: self.parent.view.widthAnchor , constant : 0.0).isActive = true
        self.tableView.centerXAnchor.constraint(equalTo: self.parent.view.centerXAnchor, constant: 0).isActive = true
        self.tableView.topAnchor.constraint(equalTo: self.parent.view.topAnchor, constant: 60).isActive = true
        self.tableView.bottomAnchor.constraint(equalTo: self.parent.view.bottomAnchor, constant: 0).isActive = true
        
        completion?()
    }
    
    func refresh(_ refreshControl: UIRefreshControl) {
        
        self.invalidate{
            
        }
        refreshControl.endRefreshing()
    }
    
    open func invalidate(_ completion: (() -> ())?){
        
        currentPages = 1
        
        self.manager.memoryStorage.removeAllItems()
        
        
        TravelOrderController.GetNearestOpenOrders(SCLocationManager.currentLocation!.Location!.coordinate,page: currentPages,pagesize: 20, serverHandler: { (orders) in
          
            self.parent.lblNoTravel.isHidden = (orders.count > 0)
            self.manager.memoryStorage.addItems(orders)
            
            self.loadMores()
            
        })

        
    }
    
    
    open func loadMores(){
        
        
        if(currentPages < 0){
            return
        }
        //self.parent.btnLoadMore.hidden = (currentPages <= 0)
        currentPages += 1
        
        TravelOrderController.GetNearestOpenOrders(SCLocationManager.currentLocation!.Location!.coordinate,page: currentPages,pagesize: 20, serverHandler: { (orders) in
            
            if(orders.count > 0){
                
                self.manager.memoryStorage.addItems(orders)
                
            }else{
                self.currentPages = -1
            }
        })
        
    }
    
    
    
    open override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        
        let scrRect = UIScreen.main.bounds
        
        let model = self.manager.storage.itemAtIndexPath(indexPath)! as! TravelOrder
        
        return 350
        
    }
    
    open override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath){
        
        let lastSectionIndex = tableView.numberOfSections - 1
        let lastRowIndex = tableView.numberOfRows(inSection: lastSectionIndex) - 1
        
        if (((indexPath as NSIndexPath).section == lastSectionIndex) && ((indexPath as NSIndexPath).row == lastRowIndex)) {
            self.loadMores()
        }
        
    }
    
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

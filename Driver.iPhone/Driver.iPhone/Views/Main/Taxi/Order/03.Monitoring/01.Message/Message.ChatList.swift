//
//  Order.ChooseDriver.DriverList.swift
//  User.iPhone
//
//  Created by Trung Dao on 6/3/16.
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


open class TravelChattingTable : UITableViewController, DTTableViewManageable {
    
    open var parent: TravelChattingView
    
    var currentPages = 0
    var shouldScrollToBottom: Bool = true
    
    var isFirstTimeLoaded: Bool = false
    var isDisplayingData: Bool = false

    
    var chatData : [String: TravelChattingObject] = [:]
    var rowHeights : [IndexPath: CGFloat] = [:]
    
    var CurrentOrder: TravelOrder! {
        
        get {
            return  self.parent.CurrentOrder
        }
    }
    
    
    public init(parent: TravelChattingView){
        
        self.parent = parent
        super.init(nibName: nil, bundle: nil)
        
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        self.tableView.backgroundColor = UIColor.clear
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl!.addTarget(self, action: "refresh:", for: .valueChanged)
        self.tableView.addSubview(self.refreshControl!)
        
        manager.configuration.reloadRowAnimation = UITableViewRowAnimation.none
        manager.configuration.reloadSectionAnimation = UITableViewRowAnimation.none
        manager.configuration.insertRowAnimation = UITableViewRowAnimation.none
        manager.configuration.insertSectionAnimation = UITableViewRowAnimation.none
        manager.startManagingWithDelegate(self)
        manager.registerCellClass(TravelChattingCell)
        manager.cellSelection(TravelChattingTable.selectedItem)
        
        
    }
    
    open func initLayout(_ completion: (() -> ())?){
        
        self.parent.pnlContentArea.addSubview(self.tableView)
        self.tableView.widthAnchor.constraint(equalTo: self.parent.pnlContentArea.widthAnchor , constant : -20.0).isActive = true
        self.tableView.centerXAnchor.constraint(equalTo: self.parent.pnlContentArea.centerXAnchor, constant: 0).isActive = true
        self.tableView.topAnchor.constraint(equalTo: self.parent.pnlContentArea.topAnchor, constant: 20).isActive = true
        self.tableView.bottomAnchor.constraint(equalTo: self.parent.chattingInputVIew.txtMessage.topAnchor, constant: -5).isActive = true
        
        
        self.tableView.setContentOffset(CGPoint(x: 0, y:self.tableView.contentSize.height - self.tableView.bounds.size.height), animated: true)
        
        completion?()
    }

    
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

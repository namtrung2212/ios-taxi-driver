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


extension TravelChattingTable  {
    
    func refreshList(_ completion: (() -> ())?){
        
        currentPages = 0
        UIView.setAnimationsEnabled(false)
        self.chatData.removeAll()
        self.manager.memoryStorage.removeAllItems()
        
        self.loadItems{
             completion?()
        }
        
    }
    
    func  createNewItem(_ content: String, completion: (() -> ())?){
        var obj = TravelOrderChatting()
        obj.Order = self.CurrentOrder.id
        obj.User = self.CurrentOrder.User
        obj.UserName = self.CurrentOrder.UserName
        obj.Driver = self.CurrentOrder.Driver
        obj.DriverName = self.CurrentOrder.DriverName
        obj.Car = self.CurrentOrder.Car
        obj.CarNo = self.CurrentOrder.CarNo
        obj.CitizenID = self.CurrentOrder.CitizenID
        // obj.Location = SCLocationManager.currentLocation!.Location
        obj.IsUser = false
        obj.IsViewed = false;
        obj.Content = content
        obj.createdAt = Date()
        obj.updatedAt = Date()
        
        ModelController<TravelOrderChatting>.create(obj) { (success, item) in
            
            if(success){
                
                self.addItem(item!, completion: completion)
                
                SCONNECTING.TaxiManager?.chat(self.CurrentOrder, message: item!, completion: {
                    
                    self.currentPages = 0
                    
                })
              
            }
        }
        
        
        
    }
    
    
    func loadNewItems(_ completion: (() -> ())?){
        self.currentPages = 0
        self.loadItems{
            completion?()
        }
    }
    
    func loadItems(_ completion: (() -> ())?){
        
        if(self.CurrentOrder == nil || self.CurrentOrder!.id == nil){
            self.isDisplayingData = false
            completion?()
            
            return
        }
        
        currentPages += 1
        
        
        let query = "Order=\(self.CurrentOrder!.id!)&sortField=createdAt&pagesize=10&page=\(currentPages)&sort=-1"
        DataManager<TravelOrderChatting>.queryServer("selectall", filter: query) { (chattings) in
            
            
            self.isDisplayingData = true
            TravelChattingObject.fromArray(self.CurrentOrder!, arrItems: chattings, completion: { (items) in
                
                if(items != nil && items!.count > 0){
                    
                    items!.forEach({ (item) in
                        
                        if(self.chatData[item.cellObject!.id!] == nil){
                            self.chatData[item.cellObject!.id!]  = item
                        }
                        
                    })
                    
                    
                    self.displayData{
                        
                        if(self.currentPages == 1){
                            
                            UIView.setAnimationsEnabled(false)
                            let model = self.manager.memoryStorage.itemAtIndexPath(IndexPath(row: self.chatData.values.count - 1 , section: 0))! as! TravelChattingObject
                            let currentID = model.cellObject!.id
                            
                            self.scrollToObjectId(currentID!)
                           // UIView.setAnimationsEnabled(true)
                        }
                        
                        self.isDisplayingData = false
                        completion?()
                    }
                    
                }else{
                    
                    
                    self.isDisplayingData = false
                    completion?()
                }
                
            })
            
        }
        
    }
    
    
    
    func addItemFromUser(_ contentId: String, content : String, completion: (() -> ())?){
        
        var obj = TravelOrderChatting()
        obj.id = contentId;
        obj.Order = self.CurrentOrder.id
        obj.User = self.CurrentOrder.User
        obj.UserName = self.CurrentOrder.UserName
        obj.Driver = self.CurrentOrder.Driver
        obj.DriverName = self.CurrentOrder.DriverName
        obj.Car = self.CurrentOrder.Car
        obj.CarNo = self.CurrentOrder.CarNo
        obj.CitizenID = self.CurrentOrder.CitizenID
        // obj.Location = SCLocationManager.currentLocation!.Location
        obj.IsUser = true
        obj.IsViewed = false;
        obj.Content = content
        obj.createdAt = Date()
        obj.updatedAt = Date()
        
        

        addItem(obj,completion: completion)
    }
    
    func addItem(_ item : TravelOrderChatting, completion: (() -> ())?){
        
            if(self.CurrentOrder == nil || self.CurrentOrder!.id == nil){
                self.isDisplayingData = false
                completion?()
                
                return
            }
        
            self.isDisplayingData = true
        
            let newObject = TravelChattingObject(order: self.CurrentOrder,item: item)
        
            if(self.chatData[newObject.cellObject!.id!] == nil){
                self.chatData[newObject.cellObject!.id!]  = newObject
            }
        
            self.tableView.beginUpdates()
            manager.memoryStorage.addItem(newObject)
            self.tableView.endUpdates()
        
            scrollToObjectId(newObject.cellObject!.id!)
        
            completion?()
    }

    
    func  displayData(_ completion: (() -> ())?){
        
        
        manager.configuration.reloadRowAnimation = UITableViewRowAnimation.none
        manager.configuration.reloadSectionAnimation = UITableViewRowAnimation.none
        manager.configuration.insertRowAnimation = UITableViewRowAnimation.none
        manager.configuration.insertSectionAnimation = UITableViewRowAnimation.none
        manager.configuration.deleteRowAnimation = UITableViewRowAnimation.none
        manager.configuration.deleteSectionAnimation = UITableViewRowAnimation.none
        
        
        let newArray = self.chatData.sorted(by: { (item1, item2) -> Bool in
            
            return   item1.1.cellObject!.createdAt!.compare(item2.1.cellObject!.createdAt!) == .orderedAscending
            
        }).map { (newItem) -> TravelChattingObject in
            return newItem.1
        }
        UIView.setAnimationsEnabled(false)
        self.manager.memoryStorage.removeAllItems()
        self.manager.memoryStorage.addItems(newArray)
        
     //  UIView.setAnimationsEnabled(true)
        
        completion?()
    }
    
    
    
    func scrollToObjectId(_ id: String){
        
        if(self.manager.memoryStorage.sections.count > 0 && self.manager.memoryStorage.sections[0].items.count > 0){
            
            var  i : Int = -1
            self.manager.memoryStorage.sections[0].items.forEach { (item) in
                
                i =  i + 1
                if( (item as! TravelChattingObject).cellObject!.id == id){
                    
                    let index =  IndexPath(row: i , section: 0)
                    self.tableView.scrollToRow(at: index, at: UITableViewScrollPosition.bottom, animated: false)
                    
                }
            }
        }
    }
    
}

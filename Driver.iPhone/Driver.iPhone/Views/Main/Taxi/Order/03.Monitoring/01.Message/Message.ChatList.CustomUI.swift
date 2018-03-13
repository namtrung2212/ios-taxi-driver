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


extension TravelChattingTable {
    
    func selectedItem(_ cell: TravelChattingCell, object: TravelChattingObject, indexPath: IndexPath) {
        
        UIView.animate(withDuration: 0.1 ,
                                   animations: {
                                    cell.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            },
                                   completion: { finish in
                                    UIView.animate(withDuration: 0.1, animations: {
                                        cell.transform = CGAffineTransform.identity
                                    })
                                    UIView.animate(withDuration: 0.25, animations: {
                                        
                                        
                                    }) 
        })
        
        
    }
    
    
    func refresh(_ refreshControl: UIRefreshControl) {
        
        self.loadItems{
            
        }
        refreshControl.endRefreshing()
    }
    
    public override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath){
        
        let lastSectionIndex = tableView.numberOfSections - 1
        let lastRowIndex = tableView.numberOfRows(inSection: lastSectionIndex) - 1
        
        if ((indexPath as NSIndexPath).row > 0) {
            
            let model = self.manager.memoryStorage.itemAtIndexPath(indexPath)! as! TravelChattingObject
            
            let preIndexPath=IndexPath(row: (indexPath as NSIndexPath).row - 1, section: (indexPath as NSIndexPath).section)
            
            let preModel = self.manager.memoryStorage.itemAtIndexPath(preIndexPath) as? TravelChattingObject
            
            (cell as! TravelChattingCell).hideAvatar((preModel != nil && preModel!.cellObject!.id! != model.cellObject!.id! && preModel!.cellObject!.IsUser == model.cellObject!.IsUser))
            
        }
        
        
        
        if((indexPath as NSIndexPath).row == 0 &&  self.isFirstTimeLoaded && self.isDisplayingData == false){
            self.loadItems{
                
            }
        }
        
        if((indexPath as NSIndexPath).row == lastRowIndex){
            self.isFirstTimeLoaded = true
        }
        
        
        
    }
    public override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        let scrRect = UIScreen.main.bounds
       
        if(self.manager.memoryStorage.itemAtIndexPath(indexPath) != nil){
            let model = self.manager.memoryStorage.itemAtIndexPath(indexPath)! as! TravelChattingObject
            
            let height = model.preferHeight + 14
            
            self.rowHeights[indexPath] = height
            
            return height
        }else{
            return TravelChattingCell.CellHeight
        }
    }
    
    public override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        
        let scrRect = UIScreen.main.bounds
        
        if(self.manager.memoryStorage.itemAtIndexPath(indexPath) != nil){
            let model = self.manager.memoryStorage.itemAtIndexPath(indexPath)! as! TravelChattingObject
            
            let height = model.preferHeight + 14
            
            self.rowHeights[indexPath] = height
            
            return height
        }else{
            return TravelChattingCell.CellHeight
        }
        
        
    }
    

    public override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        let lastSectionIndex = tableView.numberOfSections - 1
        let lastRowIndex = tableView.numberOfRows(inSection: lastSectionIndex) - 1
        
        let lastndexPath=IndexPath(row: lastRowIndex, section: (indexPath as NSIndexPath).section)
        
        
    }

}

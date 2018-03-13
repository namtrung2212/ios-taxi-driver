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




extension ChattingInputView {
    
    
    func keyboardWasShown(_ notification: Foundation.Notification)
    {
        
        let scrRect = UIScreen.main.bounds
        let info : NSDictionary = (notification as NSNotification).userInfo! as NSDictionary
        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
        var contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize!.height, 0.0)
        
        let h1 = scrRect.height - (keyboardSize?.height)!
        let h2 = (self.txtMessage.superview?.convert(self.txtMessage.frame.origin, to: nil).y)! + self.txtMessage.frame.size.height
        self.parent.contentBottom.constant = (h1 < h2) ? (h1 - h2 - 33) : ( -30 )
        
        if(self.parent.chattingTable.tableView.numberOfSections > 0){
            let lastSectionIndex = self.parent.chattingTable.tableView.numberOfSections - 1
            let lastRowIndex = self.parent.chattingTable.tableView.numberOfRows(inSection: lastSectionIndex) - 1
            let lastndexPath=IndexPath(row: lastRowIndex, section: 0)
            self.parent.chattingTable.tableView.scrollToRow(at: lastndexPath, at: UITableViewScrollPosition.top, animated: false)
            
        }

    }
    
    
    func keyboardWillBeHidden(_ notification: Foundation.Notification)
    {
        
        let scrRect = UIScreen.main.bounds
        let info : NSDictionary = (notification as NSNotification).userInfo! as NSDictionary
        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
        var contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, -keyboardSize!.height, 0.0)

        self.parent.contentBottom.constant = -30
        
    }
    
    
    func textMessageDidChange(_ textField: UITextField) {
//        let height = textField.font!.sizeOfJustifiedString(textField.text!, constrainedToWidth: textField.frame.width).height

  //     txtMessageHeight.constant = height
    }
    
    public func textFieldDidBeginEditing(_ textField: UITextField!)
    {
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField)
    {
        
    }
    
    
    
    
    @IBAction public func btnSend_Clicked(_ sender: UIButton) {
        
        
        UIView.animate(withDuration: 0.1 ,
                                   animations: {
                                    sender.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            },
                                   completion: { finish in
                                    UIView.animate(withDuration: 0.1, animations: {
                                        sender.transform = CGAffineTransform.identity
                                    })
                                    UIView.animate(withDuration: 0.25, animations: {
                                        
                                        self.parent.chattingTable.createNewItem(self.txtMessage.text!){
                                            self.txtMessage.text = ""
                                        }
                                    }) 
                                    
        })
        
    }

}

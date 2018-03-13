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




extension ChattingInputView{
    
    
    func initControls(_ completion: (() -> ())?){
        
        let scrRect = UIScreen.main.bounds
        
        
        pnlContentArea = UIView()
        pnlContentArea.backgroundColor = UIColor.clear
        pnlContentArea.translatesAutoresizingMaskIntoConstraints = false
        pnlContentArea.alpha = 1.0
        pnlContentArea.isUserInteractionEnabled = true
        
        
        
        txtMessage = UITextField(frame: CGRect(x: 20, y: 100, width: 300, height: 40))
        txtMessage.placeholder = "gửi tin nhắn ..."
        txtMessage.layer.backgroundColor = UIColor.white.cgColor
        txtMessage.layer.cornerRadius = 3
        txtMessage.font = UIFont.systemFont(ofSize: 13)
        txtMessage.borderStyle = UITextBorderStyle.none
        txtMessage.autocorrectionType = UITextAutocorrectionType.no
        txtMessage.keyboardType = UIKeyboardType.default
        txtMessage.returnKeyType = UIReturnKeyType.send
        txtMessage.clearButtonMode = UITextFieldViewMode.whileEditing;
        txtMessage.contentVerticalAlignment = UIControlContentVerticalAlignment.center
        txtMessage.textAlignment = .left
        
        txtMessage.translatesAutoresizingMaskIntoConstraints = false
        txtMessage.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: self.txtMessage.frame.height))
        txtMessage.leftViewMode = UITextFieldViewMode.always
        
        txtMessage.delegate = self

        btnSend   = UIButton(type: UIButtonType.custom) as UIButton
        btnSend.setTitle("Gửi", for: UIControlState())
        btnSend.layer.borderWidth = 2.0
        btnSend.layer.borderColor =  UIColor(red: CGFloat(125/255.0), green: CGFloat(187/255.0), blue: CGFloat(233/255.0), alpha: 1.0).cgColor
        btnSend.layer.backgroundColor =  UIColor(red: CGFloat(125/255.0), green: CGFloat(187/255.0), blue: CGFloat(233/255.0), alpha: 1.0).cgColor
        btnSend.tintColor = UIColor.white
        btnSend.layer.cornerRadius = 5
        btnSend.titleLabel!.font =   btnSend.titleLabel!.font.withSize(13)
        btnSend.titleLabel!.textAlignment = NSTextAlignment.center
        btnSend.contentEdgeInsets = UIEdgeInsetsMake(1,1,1,1)
        btnSend.titleLabel!.lineBreakMode = .byTruncatingTail
        btnSend.contentHorizontalAlignment = .center
        btnSend.contentVerticalAlignment = .center
        btnSend.contentMode = .scaleToFill
        btnSend.translatesAutoresizingMaskIntoConstraints = false
       
        txtMessage.addTarget(self, action: #selector(ChattingInputView.textMessageDidChange(_:)), for: UIControlEvents.editingChanged)
        btnSend.addTarget(self, action: Selector("btnSend_Clicked:"), for:.touchUpInside)
        
        NotificationCenter.default.addObserver(self, selector: "keyboardWasShown:", name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: "keyboardWillBeHidden:", name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ChattingInputView.dismissKeyboard))
        self.parent.chattingTable.view.addGestureRecognizer(tap)
        
        completion?()
    }
    
    func dismissKeyboard() {
        self.txtMessage.endEditing(true)
    }
    
    
    func initLayout(_ completion: (() -> ())?){
        
        let scrRect = UIScreen.main.bounds
        
        self.parent.pnlContentArea.addSubview(self.btnSend)
        self.btnSend.widthAnchor.constraint(equalToConstant: 60.0).isActive = true
        self.btnSend.rightAnchor.constraint(equalTo: self.parent.pnlContentArea.rightAnchor, constant: -3).isActive = true
        self.btnSend.heightAnchor.constraint(equalToConstant: 28).isActive = true
        
        self.parent.pnlContentArea.addSubview(self.txtMessage)
        self.txtMessage.leftAnchor.constraint(equalTo: self.parent.pnlContentArea.leftAnchor , constant : 5.0).isActive = true
        self.txtMessage.rightAnchor.constraint(equalTo: self.btnSend.leftAnchor, constant: -5).isActive = true
        txtMessageHeight = self.txtMessage.heightAnchor.constraint(equalToConstant: 28)
        txtMessageHeight.isActive = true
        
        self.txtMessage.bottomAnchor.constraint(equalTo: self.parent.pnlContentArea.bottomAnchor, constant: 0).isActive = true
        self.btnSend.bottomAnchor.constraint(equalTo: self.txtMessage.bottomAnchor, constant: 0).isActive = true
        
        completion?()
        
    }
    

}

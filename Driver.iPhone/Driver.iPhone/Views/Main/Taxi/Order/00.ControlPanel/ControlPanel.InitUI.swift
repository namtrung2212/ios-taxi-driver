//
//  Main.CreateOrder.ChooseLocation.InitUI.swift
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
import SClientUI
import CoreLocation
import RealmSwift
import GoogleMaps



extension ControlPanelView {
    
    func initControls(_ completion: (() -> ())?){
        
        self.initControlPanel(completion)
        
    }
    
    func initLayout(_ completion: (() -> ())?){
        self.initControlPanelLayout(completion)
    }
    
    
    func initControlPanel(_ completion: (() -> ())?){
        
        let scrRect = UIScreen.main.bounds
        
        pnlControlArea = UIView()
        pnlControlArea.translatesAutoresizingMaskIntoConstraints = false
        pnlControlArea.isUserInteractionEnabled = true
        pnlControlArea.isHidden = true

        
        self.imgOrangeButton = ImageHelper.resize(UIImage(named: "OrangeButton.png")!, newWidth: scrRect.width/2)
        self.imgBlueButton = ImageHelper.resize(UIImage(named: "BlueButton.png")!, newWidth: scrRect.width/2)
        
        btnReady   = UIButton(type: UIButtonType.custom) as UIButton
        btnReady.setTitle("ĐANG RÃNH", for: UIControlState())
        btnReady.setBackgroundImage(imgOrangeButton, for: UIControlState())
        btnReady.titleLabel!.font =   btnReady.titleLabel!.font.withSize(15)
        btnReady.titleLabel!.textAlignment = NSTextAlignment.center
        btnReady.contentEdgeInsets = UIEdgeInsetsMake(1,1,1,1)
        btnReady.titleLabel!.lineBreakMode = .byTruncatingTail
        btnReady.contentHorizontalAlignment = .center
        btnReady.contentVerticalAlignment = .center
        btnReady.contentMode = .scaleToFill
        btnReady.translatesAutoresizingMaskIntoConstraints = false
        btnReady.addTarget(self, action: Selector("btnReady_Clicked:"), for:.touchUpInside)
        
        completion?()
    }
    
    func initControlPanelLayout(_ completion: (() -> ())?){
        
        
        let scrRect = UIScreen.main.bounds
        
        self.parent.view.addSubview(pnlControlArea)
        pnlControlArea.widthAnchor.constraint(equalToConstant: scrRect.width-7.0).isActive = true
        pnlControlArea.centerXAnchor.constraint(equalTo: self.parent.view.centerXAnchor, constant: 2.0).isActive = true
        pnlControlArea.bottomAnchor.constraint(equalTo: self.parent.view.bottomAnchor, constant: -3).isActive = true
        pnlControlArea.initHeightConstraints(45,related: nil, second: nil, third: nil, fourth: nil)
        
        pnlControlArea.addSubview(btnReady)
        btnReady.widthAnchor.constraint(equalTo: pnlControlArea.widthAnchor, multiplier: 1.0).isActive = true
        btnReady.heightAnchor.constraint(equalToConstant: 45).isActive = true
        btnReady.centerXAnchor.constraint(equalTo: pnlControlArea.centerXAnchor, constant: 0.0).isActive = true
        btnReady.topAnchor.constraint(equalTo: pnlControlArea.topAnchor, constant: 0.0).isActive = true
        
        self.parent.view.layoutIfNeeded()
        
        completion?()
    }
    
    
}

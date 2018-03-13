//
//  Driver.Profile.Comment.Cell.swift
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

import SClientModelControllers
import DTTableViewManager
import DTModelStorage
import AlamofireImage

open class MenuHeaderCell: UITableViewHeaderFooterView, ModelTransfer {
    
    open var lblCaption: UILabel!
    
    open var topLine: CAShapeLayer!
    open var bottomLine: CAShapeLayer!
    
    open var imgLeft: UIImageView!

    
    public override init(reuseIdentifier: String?){
        super.init( reuseIdentifier: reuseIdentifier)
        
        self.backgroundView =  UIView()
        self.backgroundView!.backgroundColor = UIColor(red: CGFloat(236/255.0), green: CGFloat(236/255.0), blue: CGFloat(236/255.0), alpha: 1.0)
        
        lblCaption = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 50))
        lblCaption.font = UIFont(name: "HelveticaNeue-Bold", size: 13)
        lblCaption.textColor = UIColor.darkGray
        lblCaption.textAlignment = NSTextAlignment.center
        
        lblCaption.translatesAutoresizingMaskIntoConstraints = false
        
        self.contentView.addSubview(lblCaption)
        lblCaption.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor, constant : 0.0).isActive = true
        lblCaption.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor, constant : 0.0).isActive = true
      //  lblCaption.widthAnchor.constraintEqualToAnchor(self.contentView.widthAnchor, constant : -15.0).active = true
        lblCaption.heightAnchor.constraint(equalToConstant: 25.0).isActive = true
        
        imgLeft = UIImageView()
        imgLeft.translatesAutoresizingMaskIntoConstraints = false
        
        self.contentView.addSubview(imgLeft)
        imgLeft.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor, constant : 0.0).isActive = true
        imgLeft.leftAnchor.constraint(equalTo: self.lblCaption.leftAnchor, constant : -40.0).isActive = true
        imgLeft.widthAnchor.constraint(equalToConstant: 25.0).isActive = true
        imgLeft.heightAnchor.constraint(equalToConstant: 25.0).isActive = true
        

        
        topLine = CAShapeLayer()
        topLine.fillColor = UIColor.gray.cgColor
        topLine.path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0 , width: SlideMenuOptions.leftViewWidth, height: 0.5), cornerRadius: 0).cgPath
        self.backgroundView?.layer.addSublayer(topLine)
        
        bottomLine = CAShapeLayer()
        bottomLine.fillColor = UIColor.gray.cgColor
        bottomLine.path = UIBezierPath(roundedRect: CGRect(x: 0, y: 40 , width: SlideMenuOptions.leftViewWidth, height: 0.5), cornerRadius: 0).cgPath
        self.backgroundView?.layer.addSublayer(bottomLine)

    }
    
    public required init?(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
        
    }
    
    
    open  func updateWithModel(_ model: (String, String)) {
       
        self.lblCaption.text = model.0.uppercased()
        self.lblCaption.sizeToFit()
        
        if(model.1 == "Taxi"){
            
            self.imgLeft.setFAIconWithName(FAType.faCar, textColor: UIColor(red: 73.0/255.0, green: 139.0/255.0, blue: 199.0/255.0, alpha: 1.0))
            
        }else if(model.1 == "TripMate"){
            
            self.imgLeft.setFAIconWithName(FAType.faUsers, textColor: UIColor(red: 73.0/255.0, green: 139.0/255.0, blue: 199.0/255.0, alpha: 1.0))
            
        }else if(model.1 == "Revenue"){
            
            self.imgLeft.setFAIconWithName(FAType.faBarChart, textColor: UIColor(red: 73.0/255.0, green: 139.0/255.0, blue: 199.0/255.0, alpha: 1.0))
            
        }else if(model.1 == "Setting"){
            
            self.imgLeft.setFAIconWithName(FAType.faCogs, textColor: UIColor(red: 73.0/255.0, green: 139.0/255.0, blue: 199.0/255.0, alpha: 1.0))
            
        }
    }
    
    
}


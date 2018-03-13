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
import CoreLocation
import RealmSwift
import GoogleMaps

import SClientUI
import SClientModelControllers
import DTTableViewManager
import DTModelStorage
import AlamofireImage

open class MenuItemCell: UITableViewCell, ModelTransfer {
    
    open var lblCaption: UILabel!
    open var lblDesc: UILabel!
    
    open var imgLeft: UIImageView!
    open var imgRight: UIImageView!
    
    open var topLine: CAShapeLayer!
    open var bottomLine: CAShapeLayer!
    
    public override init(style: UITableViewCellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = UITableViewCellSelectionStyle.none
        self.backgroundView =  UIView()
        self.backgroundColor = UIColor.white
        
        lblCaption = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 50))
        lblCaption.font = UIFont(name: "HelveticaNeue", size: 11)
        lblCaption.textColor = UIColor.black
        lblCaption.textAlignment = NSTextAlignment.left
        lblCaption.backgroundColor = UIColor.clear
        lblCaption.translatesAutoresizingMaskIntoConstraints = false
        
        self.contentView.addSubview(lblCaption)
        lblCaption.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor, constant : 0.0).isActive = true
        lblCaption.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor, constant : 40.0).isActive = true
        lblCaption.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, constant : -15.0).isActive = true
        lblCaption.heightAnchor.constraint(equalToConstant: 25.0).isActive = true
        
        imgLeft = UIImageView()
        imgLeft.translatesAutoresizingMaskIntoConstraints = false
        
        self.contentView.addSubview(imgLeft)
        imgLeft.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor, constant : 0.0).isActive = true
        imgLeft.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant : 10.0).isActive = true
        imgLeft.widthAnchor.constraint(equalToConstant: 25.0).isActive = true
        imgLeft.heightAnchor.constraint(equalToConstant: 25.0).isActive = true

        
        self.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
    }
    
    public required init?(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
        
    }
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    
    open  func updateWithModel(_ item: MenuItemObject) {
        
        self.lblCaption.text = item.Caption.uppercased()
        
        if(item.Index != 0 && topLine == nil){
            topLine = CAShapeLayer()
            topLine.fillColor = UIColor.gray.cgColor
            topLine.path = UIBezierPath(roundedRect: CGRect(x: 40, y: 0 , width: SlideMenuOptions.leftViewWidth, height: 0.5), cornerRadius: 0).cgPath
            self.backgroundView?.layer.addSublayer(topLine)
        }
        
        if(item.leftIcon == "NewTravel"){
            self.imgLeft.setFAIconWithName(FAType.faPlusCircle, textColor: UIColor(red: 73.0/255.0, green: 139.0/255.0, blue: 199.0/255.0, alpha: 1.0))
        }else if(item.leftIcon == "NotYetStart"){
            self.imgLeft.setFAIconWithName(FAType.faStreetView, textColor: UIColor(red: 73.0/255.0, green: 139.0/255.0, blue: 199.0/255.0, alpha: 1.0))
        }else if(item.leftIcon == "OnTheWay"){
            self.imgLeft.setFAIconWithName(FAType.faRandom, textColor: UIColor(red: 73.0/255.0, green: 139.0/255.0, blue: 199.0/255.0, alpha: 1.0))
        }else if(item.leftIcon == "NotYetPaid"){
            self.imgLeft.setFAIconWithName(FAType.faCreditCard, textColor: UIColor(red: 73.0/255.0, green: 139.0/255.0, blue: 199.0/255.0, alpha: 1.0))
        }else if(item.leftIcon == "History"){
            self.imgLeft.setFAIconWithName(FAType.faHistory, textColor: UIColor(red: 73.0/255.0, green: 139.0/255.0, blue: 199.0/255.0, alpha: 1.0))
        }else if(item.leftIcon == "Home"){
            self.imgLeft.setFAIconWithName(FAType.faHome, textColor: UIColor(red: 73.0/255.0, green: 139.0/255.0, blue: 199.0/255.0, alpha: 1.0))
        }else if(item.leftIcon == "PieChart"){
            self.imgLeft.setFAIconWithName(FAType.faPieChart, textColor: UIColor(red: 73.0/255.0, green: 139.0/255.0, blue: 199.0/255.0, alpha: 1.0))
        }else if(item.leftIcon == "Spinner"){
            self.imgLeft.setFAIconWithName(FAType.faSpinner, textColor: UIColor(red: 73.0/255.0, green: 139.0/255.0, blue: 199.0/255.0, alpha: 1.0))
        }else if(item.leftIcon == "calendar"){
            self.imgLeft.setFAIconWithName(FAType.faCalendarO, textColor: UIColor(red: 73.0/255.0, green: 139.0/255.0, blue: 199.0/255.0, alpha: 1.0))
        }else if(item.leftIcon == "Spinner"){
            self.imgLeft.setFAIconWithName(FAType.faSpinner, textColor: UIColor(red: 73.0/255.0, green: 139.0/255.0, blue: 199.0/255.0, alpha: 1.0))
        }else if(item.leftIcon == "Spinner"){
            self.imgLeft.setFAIconWithName(FAType.faSpinner, textColor: UIColor(red: 73.0/255.0, green: 139.0/255.0, blue: 199.0/255.0, alpha: 1.0))
        }



    }

    
}


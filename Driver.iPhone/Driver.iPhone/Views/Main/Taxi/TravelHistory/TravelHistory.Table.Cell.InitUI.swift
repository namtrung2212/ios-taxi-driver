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

import SClientModelControllers
import DTTableViewManager
import DTModelStorage
import AlamofireImage
import GoogleMaps

open class TravelOrderCell: UITableViewCell, ModelTransfer,GMSMapViewDelegate {
    
    
    var lblStatus: UILabel!
    var lblCurrentPrice: UILabel!
    
    var btnPickupIcon: UIButton!
    var lblPickupLocation: UILabel!
    
    var btnDropIcon: UIButton!
    var lblDropLocation: UILabel!
    
    var lblDateTime: UILabel!
    var pnlCellArea: UIView!
    var pnlBottomInfoArea: UIView!
    
    
    var gmsMapView: GMSMapView!
    var pathPolyLine : GMSPolyline?
    
    var mSourceMarker : GMSMarker!
    var mDestinyMarker : GMSMarker!
    
    public override init(style: UITableViewCellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = UITableViewCellSelectionStyle.none
        self.backgroundView =  UIView()
        self.backgroundColor = UIColor.clear
        
        self.contentView.backgroundColor = UIColor.clear
        
        self.initControls{
            self.initLayouts({ 
                
                
            })
        }
    }
    
    func initControls(_ completion: (() -> ())?){
        
        let scrRect = UIScreen.main.bounds
        
        pnlCellArea = UIView()
        pnlCellArea.backgroundColor = UIColor.white
       // pnlCellArea.layer.borderColor = UIColor.grayColor().CGColor
        //pnlCellArea.layer.borderWidth = 0.5
        pnlCellArea.layer.shadowOffset = CGSize(width: 2, height: 2)
        pnlCellArea.layer.shadowOpacity = 0.5
        pnlCellArea.layer.shadowRadius = 3
        pnlCellArea.translatesAutoresizingMaskIntoConstraints = false
        pnlCellArea.alpha = 1.0
        pnlCellArea.isUserInteractionEnabled = true
        
        pnlBottomInfoArea = UIView()
        pnlBottomInfoArea.backgroundColor = UIColor.white
        pnlBottomInfoArea.translatesAutoresizingMaskIntoConstraints = false
        pnlBottomInfoArea.alpha = 1.0
        pnlBottomInfoArea.isUserInteractionEnabled = true
        

        // Source Point Left Button
        let imgSource = ImageHelper.resize(UIImage(named: "pickupIcon.png")!, newWidth: 25)
        btnPickupIcon   = UIButton(type: UIButtonType.custom) as UIButton
        btnPickupIcon.frame = CGRect(x: 25, y: 25, width: 25, height: 25)
        btnPickupIcon.setImage(imgSource, for: UIControlState())
        btnPickupIcon.translatesAutoresizingMaskIntoConstraints = false
        
        // Source Point Label
        lblPickupLocation   =  UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 50))
        lblPickupLocation.frame = CGRect(x: 0, y: 0, width: 0, height: 10)
        lblPickupLocation.text = ""
        lblPickupLocation.textColor = UIColor.darkGray
        lblPickupLocation.font = lblPickupLocation.font.withSize(12)
        lblPickupLocation.textAlignment = NSTextAlignment.left
        lblPickupLocation.translatesAutoresizingMaskIntoConstraints = false
        
        // Destiny Point Left Button
        let imgDrop = ImageHelper.resize(UIImage(named: "dropicon.png")!, newWidth: 25)
        btnDropIcon   = UIButton(type: UIButtonType.custom) as UIButton
        btnDropIcon.frame = CGRect(x: 25, y: 25, width: 25, height: 25)
        btnDropIcon.setImage(imgDrop, for: UIControlState())
        btnDropIcon.translatesAutoresizingMaskIntoConstraints = false
        
        // Destiny Point Label
        lblDropLocation   =  UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 50))
        lblDropLocation.frame = CGRect(x: 0, y: 0, width: 0, height: 10)
        lblDropLocation.text = ""
        lblDropLocation.textColor = UIColor.darkGray
        lblDropLocation.font = lblDropLocation.font.withSize(12)
        lblDropLocation.textAlignment = NSTextAlignment.left
        lblDropLocation.translatesAutoresizingMaskIntoConstraints = false
        
        // Path Statistic Label
        lblDateTime = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 50))
        lblDateTime.font = UIFont(name: "HelveticaNeue", size: 12)
        lblDateTime.textColor = UIColor.darkGray
        lblDateTime.textAlignment = NSTextAlignment.left
        lblDateTime.text = ""
        lblDateTime.translatesAutoresizingMaskIntoConstraints = false
        
        
        lblStatus = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 50))
        lblStatus.font = UIFont(name: "HelveticaNeue-Bold", size: 11)
        lblStatus.textColor = UIColor(red: 73.0/255.0, green: 139.0/255.0, blue: 199.0/255.0, alpha: 1.0)
        lblStatus.textAlignment = NSTextAlignment.center
        lblStatus.text = ""
        lblStatus.translatesAutoresizingMaskIntoConstraints = false
        
        lblCurrentPrice = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 50))
        lblCurrentPrice.font = UIFont(name: "HelveticaNeue-Bold", size: 17)
        lblCurrentPrice.textColor = UIColor.darkGray
        lblCurrentPrice.textAlignment = NSTextAlignment.right
        lblCurrentPrice.text = ""
        lblCurrentPrice.translatesAutoresizingMaskIntoConstraints = false

        let camera  = GMSCameraPosition.camera(withLatitude: 0.702812, longitude: 106.643604, zoom: 15)
        
        gmsMapView = GMSMapView.map(withFrame: CGRect(x: 10,y: 10,width: scrRect.size.width * 0.9, height: 220), camera: camera)
        gmsMapView.isMyLocationEnabled = false
        gmsMapView.settings.myLocationButton = false
        gmsMapView.settings.scrollGestures = false
        gmsMapView.settings.zoomGestures = false
        gmsMapView.settings.tiltGestures = false
        gmsMapView.settings.rotateGestures = false
        gmsMapView.isUserInteractionEnabled = false
        gmsMapView.mapType = kGMSTypeNormal
        
        gmsMapView.delegate = self
        gmsMapView.padding = UIEdgeInsets(top: 5, left: 5,bottom: 5, right: 5)
        
        
        
        
        mSourceMarker = GMSMarker(position: CLLocationCoordinate2D(latitude: 0, longitude: 0))
        mSourceMarker.title = "Điểm đi"
        let imgSourcePin =  ImageHelper.resize(UIImage(named: "sourcePin.png")!, newWidth: 35)
        let sourcePinView = UIImageView(image: imgSourcePin)
        mSourceMarker.iconView = sourcePinView
        mSourceMarker.groundAnchor = CGPoint(x: 0.5, y: 1);
        mSourceMarker.tracksViewChanges = true
        mSourceMarker.map = self.gmsMapView
        
        mDestinyMarker = GMSMarker(position: CLLocationCoordinate2D(latitude: 0, longitude: 0))
        mDestinyMarker.title = "Điểm đến"
        let imgDestinyPin =  ImageHelper.resize(UIImage(named: "destinyPin.png")!, newWidth: 35)
        let destinyPinView = UIImageView(image: imgDestinyPin)
        mDestinyMarker.iconView = destinyPinView
        mDestinyMarker.groundAnchor = CGPoint(x: 0.5, y: 1);
        mDestinyMarker.tracksViewChanges = true
        mDestinyMarker.map = self.gmsMapView
        

        completion?()
    }
    
    func initLayouts(_ completion: (() -> ())?){
        
        
        let scrRect = UIScreen.main.bounds
        
        self.contentView.addSubview(pnlCellArea)
        pnlCellArea.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10.0).isActive = true
        pnlCellArea.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant : -10.0).isActive = true
        pnlCellArea.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.95).isActive = true
        pnlCellArea.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant : 0.0).isActive = true
        
        self.pnlCellArea.addSubview(gmsMapView)
        gmsMapView.centerXAnchor.constraint(equalTo: pnlCellArea.centerXAnchor, constant : 0.0).isActive = true
        gmsMapView.topAnchor.constraint(equalTo: self.pnlCellArea.topAnchor, constant: 15.0).isActive = true
        gmsMapView.widthAnchor.constraint(equalTo: pnlCellArea.widthAnchor, multiplier: 0.9).isActive = true
        gmsMapView.heightAnchor.constraint(equalToConstant: 220).isActive = true

        
        self.pnlCellArea.addSubview(pnlBottomInfoArea)
        pnlBottomInfoArea.topAnchor.constraint(equalTo: gmsMapView.bottomAnchor, constant : 10.0).isActive = true
        pnlBottomInfoArea.widthAnchor.constraint(equalTo: pnlCellArea.widthAnchor, multiplier: 0.95).isActive = true
        pnlBottomInfoArea.centerXAnchor.constraint(equalTo: pnlCellArea.centerXAnchor, constant : 0.0).isActive = true
        pnlBottomInfoArea.heightAnchor.constraint(equalToConstant: 85).isActive = true
        
       let topLine = CAShapeLayer()
        topLine.fillColor = UIColor.gray.cgColor
        topLine.path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0 , width: scrRect.width * 0.95 * 0.95, height: 0.5), cornerRadius: 0).cgPath
        self.pnlBottomInfoArea?.layer.addSublayer(topLine)
        
        self.pnlBottomInfoArea.addSubview(lblPickupLocation)
        lblPickupLocation.topAnchor.constraint(equalTo: self.pnlBottomInfoArea.topAnchor, constant: 10.0).isActive = true
        lblPickupLocation.leftAnchor.constraint(equalTo: pnlBottomInfoArea.leftAnchor, constant : 40.0).isActive = true
        lblPickupLocation.widthAnchor.constraint(equalTo: pnlBottomInfoArea.widthAnchor, constant : -40.0).isActive = true
        lblPickupLocation.heightAnchor.constraint(equalToConstant: 13).isActive = true

        self.pnlBottomInfoArea.addSubview(btnPickupIcon)
        btnPickupIcon.leftAnchor.constraint(equalTo: pnlBottomInfoArea.leftAnchor, constant : 10.0).isActive = true
        btnPickupIcon.centerYAnchor.constraint(equalTo: lblPickupLocation.centerYAnchor, constant: 0.0).isActive = true
        btnPickupIcon.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        self.pnlBottomInfoArea.addSubview(lblDropLocation)
        lblDropLocation.topAnchor.constraint(equalTo: lblPickupLocation.bottomAnchor, constant : 15.0).isActive = true
        lblDropLocation.leftAnchor.constraint(equalTo: lblPickupLocation.leftAnchor, constant : 0.0).isActive = true
        lblDropLocation.widthAnchor.constraint(equalTo: lblPickupLocation.widthAnchor, constant : 0.0).isActive = true
        lblDropLocation.heightAnchor.constraint(equalToConstant: 13).isActive = true
        
        self.pnlBottomInfoArea.addSubview(btnDropIcon)
        btnDropIcon.centerYAnchor.constraint(equalTo: lblDropLocation.centerYAnchor, constant: 0.0).isActive = true
        btnDropIcon.leftAnchor.constraint(equalTo: btnPickupIcon.leftAnchor, constant : 0.0).isActive = true
        btnDropIcon.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        
        self.pnlBottomInfoArea.addSubview(lblDateTime)
        lblDateTime.topAnchor.constraint(equalTo: self.lblDropLocation.bottomAnchor, constant: 12.0).isActive = true
        lblDateTime.leftAnchor.constraint(equalTo: btnDropIcon.leftAnchor, constant : 0.0).isActive = true
        lblDateTime.widthAnchor.constraint(equalTo: lblDropLocation.widthAnchor, multiplier: 0.95).isActive = true
        lblDateTime.heightAnchor.constraint(equalToConstant: 15).isActive = true

        
        self.pnlBottomInfoArea.addSubview(lblCurrentPrice)
        lblCurrentPrice.bottomAnchor.constraint(equalTo: self.lblDateTime.bottomAnchor, constant: 0.0).isActive = true
        lblCurrentPrice.rightAnchor.constraint(equalTo: pnlBottomInfoArea.rightAnchor, constant : -10.0).isActive = true
        lblCurrentPrice.heightAnchor.constraint(equalToConstant: 15).isActive = true
        lblCurrentPrice.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        self.pnlBottomInfoArea.addSubview(lblStatus)
        lblStatus.bottomAnchor.constraint(equalTo: lblDateTime.bottomAnchor, constant: 3.0).isActive = true
        lblStatus.centerXAnchor.constraint(equalTo: pnlBottomInfoArea.centerXAnchor, constant : 0.0).isActive = true
        lblStatus.heightAnchor.constraint(equalToConstant: 15).isActive = true
        lblStatus.widthAnchor.constraint(equalTo: pnlBottomInfoArea.widthAnchor, multiplier: 0.95).isActive = true
        
        
        self.contentView.layoutIfNeeded()
        completion?()
    }
    
    public required init?(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
        
    }
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
}


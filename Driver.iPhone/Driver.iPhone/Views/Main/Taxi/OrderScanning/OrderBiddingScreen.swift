//
//  TripMateViewController.swift
//  User.iPhone
//
//  Created by Trung Dao on 4/13/16.
//  Copyright © 2016 SCONNECTING. All rights reserved.
//
import UIKit
import Foundation
import ObjectMapper
import AlamofireObjectMapper
import SClientData
import SClientModel
import SClientModelControllers
import CoreLocation
import RealmSwift
import GoogleMaps

open class OrderBiddingScreen: UIViewController ,GMSMapViewDelegate{
    
    var CurrentOrder: TravelOrder?
    var gmsMapView: GMSMapView!
    var pathPolyLine : GMSPolyline?
    
    var mSourceMarker : GMSMarker!
    var mDestinyMarker : GMSMarker!
    
    var pnlOrderArea: UIView!
    
    var btnPickupIcon: UIButton!
    var lblPickupLocation: UIButton!
    
    var btnDropIcon: UIButton!
    var lblDropLocation: UIButton!
    
    var btnPathStatisticIcon: UIButton!
    var lblPathStatistic: UILabel!
    
    var pnlButtonArea: UIView!
    var btnBidding: UIButton!
    var btnVoid: UIButton!

    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        self.initControls{
            self.initLayouts{
                
                
            }
        }
    }
    
    init(travelOrder: TravelOrder){
        
        super.init(nibName: nil, bundle: nil)
        self.CurrentOrder = travelOrder
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func initControls(_ completion: (() -> ())?){
        
        let scrRect = UIScreen.main.bounds
        
        let btnBack = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(OrderBiddingScreen.btnBack_Clicked))
        btnBack.setFAIcon(FAType.faArrowLeft, iconSize : 20)
        btnBack.setTitlePositionAdjustment(UIOffsetMake(0, -5), for: .default)
        self.navigationItem.leftBarButtonItem = btnBack
        
        let camera  = GMSCameraPosition.camera(withLatitude: 0.702812, longitude: 106.643604, zoom: 15)
        gmsMapView = GMSMapView.map(withFrame: CGRect(x: 0,y: 0,width: scrRect.size.width, height: scrRect.size.height), camera: camera)
        gmsMapView.isMyLocationEnabled = true
        gmsMapView.settings.myLocationButton = false
        gmsMapView.settings.scrollGestures = true
        gmsMapView.settings.zoomGestures = true
        gmsMapView.settings.tiltGestures = true
        gmsMapView.settings.rotateGestures = true
        gmsMapView.isUserInteractionEnabled = true
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
        
        
        // Order Panel
        pnlOrderArea = UIView()
        pnlOrderArea.backgroundColor = UIColor(red: CGFloat(246/255.0), green: CGFloat(246/255.0), blue: CGFloat(246/255.0), alpha: 1.0)
        pnlOrderArea.layer.cornerRadius = 6.0
        pnlOrderArea.layer.borderColor = UIColor.gray.cgColor
        pnlOrderArea.layer.borderWidth = 0.5
        pnlOrderArea.layer.shadowOffset = CGSize(width: 2, height: 3)
        pnlOrderArea.layer.shadowOpacity = 0.5
        pnlOrderArea.layer.shadowRadius = 3
        pnlOrderArea.translatesAutoresizingMaskIntoConstraints = false
        pnlOrderArea.alpha = 1.0
        pnlOrderArea.isUserInteractionEnabled = true
        
        // Source Point Left Button
        let imgSource = ImageHelper.resize(UIImage(named: "pickupIcon.png")!, newWidth: 35)
        btnPickupIcon   = UIButton(type: UIButtonType.custom) as UIButton
        btnPickupIcon.frame = CGRect(x: 35, y: 35, width: 35, height: 35)
        btnPickupIcon.setImage(imgSource, for: UIControlState())
        btnPickupIcon.translatesAutoresizingMaskIntoConstraints = false
        
        // Source Point Label
        lblPickupLocation   = UIButton(type: UIButtonType.custom) as UIButton
        lblPickupLocation.frame = CGRect(x: 0, y: 0, width: 0, height: 10)
        lblPickupLocation.setTitle(" ", for: UIControlState())
        lblPickupLocation.setTitleColor(UIColor.darkGray, for: UIControlState())
        lblPickupLocation.titleLabel!.font = lblPickupLocation.titleLabel!.font.withSize(12)
        lblPickupLocation.titleLabel!.textAlignment = NSTextAlignment.left
        lblPickupLocation.titleLabel!.lineBreakMode = .byTruncatingTail
        lblPickupLocation.contentHorizontalAlignment = .left
        lblPickupLocation.contentEdgeInsets = UIEdgeInsetsMake(0,1,0,1)
        lblPickupLocation.translatesAutoresizingMaskIntoConstraints = false
        
        // Destiny Point Left Button
        let imgDrop = ImageHelper.resize(UIImage(named: "dropicon.png")!, newWidth: 35)
        btnDropIcon   = UIButton(type: UIButtonType.custom) as UIButton
        btnDropIcon.frame = CGRect(x: 35, y: 35, width: 35, height: 35)
        btnDropIcon.setImage(imgDrop, for: UIControlState())
        btnDropIcon.translatesAutoresizingMaskIntoConstraints = false
        
        // Destiny Point Label
        lblDropLocation   = UIButton(type: UIButtonType.custom) as UIButton
        lblDropLocation.frame = CGRect(x: 0, y: 0, width: 0, height: 10)
        lblDropLocation.setTitle(" ", for: UIControlState())
        lblDropLocation.setTitleColor(UIColor.darkGray, for: UIControlState())
        lblDropLocation.titleLabel!.font = lblDropLocation.titleLabel!.font.withSize(12)
        lblDropLocation.titleLabel!.textAlignment = NSTextAlignment.left
        lblDropLocation.contentEdgeInsets = UIEdgeInsetsMake(1,1,1,1)
        lblDropLocation.titleLabel!.lineBreakMode = .byTruncatingTail
        lblDropLocation.contentHorizontalAlignment = .left
        lblDropLocation.translatesAutoresizingMaskIntoConstraints = false
        
        // Path Statistic Left Button
        btnPathStatisticIcon   = UIButton(type: UIButtonType.custom) as UIButton
        btnPathStatisticIcon.setGMDIcon(GMDType.gmdLocalTaxi, forState: UIControlState())
        btnPathStatisticIcon.titleLabel?.font = btnPathStatisticIcon.titleLabel?.font.withSize(24)
        btnPathStatisticIcon.setTitleColor(UIColor(red: CGFloat(46.0/255.0), green: CGFloat(162.0/255.0), blue: CGFloat(214.0/255.0), alpha: 1.0), for: UIControlState())
        btnPathStatisticIcon.frame = CGRect(x: 35, y: 35, width: 35, height: 35)
        btnPathStatisticIcon.translatesAutoresizingMaskIntoConstraints = false
        
        // Path Statistic Label
        lblPathStatistic = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 50))
        lblPathStatistic.font = lblPathStatistic.font.withSize(12)
        lblPathStatistic.textColor = UIColor.darkGray
        lblPathStatistic.textAlignment = NSTextAlignment.left
        lblPathStatistic.text = ""
        lblPathStatistic.translatesAutoresizingMaskIntoConstraints = false
        // Bottom  Button Area
        pnlButtonArea = UIView()
        pnlButtonArea.translatesAutoresizingMaskIntoConstraints = false
        pnlButtonArea.isUserInteractionEnabled = true
        
        // Quick Order Button
        
        let imgBlueButton = ImageHelper.resize(UIImage(named: "SmallBlueButton.png")!, newWidth: scrRect.width/2)
        btnBidding   = UIButton(type: UIButtonType.custom) as UIButton
        btnBidding.setTitle("CHÀO THẦU", for: UIControlState())
        btnBidding.setBackgroundImage(imgBlueButton, for: UIControlState())
        btnBidding.titleLabel!.font =   btnBidding.titleLabel!.font.withSize(15)
        btnBidding.titleLabel!.textAlignment = NSTextAlignment.center
        btnBidding.contentEdgeInsets = UIEdgeInsetsMake(1,1,1,1)
        btnBidding.titleLabel!.lineBreakMode = .byTruncatingTail
        btnBidding.contentHorizontalAlignment = .center
        btnBidding.contentVerticalAlignment = .center
        btnBidding.contentMode = .scaleToFill
        btnBidding.translatesAutoresizingMaskIntoConstraints = false
        btnBidding.addTarget(self, action: #selector(OrderBiddingScreen.btnBidding_Clicked(_:)), for:.touchUpInside)
        
        
        let imgOrangeButton = ImageHelper.resize(UIImage(named: "SmallOrangeButton.png")!, newWidth: scrRect.width/2)
        btnVoid   = UIButton(type: UIButtonType.custom) as UIButton
        btnVoid.setTitle("HỦY THẦU", for: UIControlState())
        btnVoid.setBackgroundImage(imgOrangeButton, for: UIControlState())
        btnVoid.titleLabel!.font =   btnVoid.titleLabel!.font.withSize(15)
        btnVoid.titleLabel!.textAlignment = NSTextAlignment.center
        btnVoid.contentEdgeInsets = UIEdgeInsetsMake(1,1,1,1)
        btnVoid.titleLabel!.lineBreakMode = .byTruncatingTail
        btnVoid.contentHorizontalAlignment = .center
        btnVoid.contentVerticalAlignment = .center
        btnVoid.contentMode = .scaleToFill
        btnVoid.translatesAutoresizingMaskIntoConstraints = false
        btnVoid.addTarget(self, action: #selector(OrderBiddingScreen.btnVoid_Clicked(_:)), for:.touchUpInside)
        
        completion?()
    }
    
    
    func initLayouts(_ completion: (() -> ())?){
        
        
        let scrRect = UIScreen.main.bounds
        
        self.view.addSubview(gmsMapView)
        gmsMapView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant : 0.0).isActive = true
        gmsMapView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 15.0).isActive = true
        gmsMapView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0.0).isActive = true
        gmsMapView.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: 0.0).isActive = true
        
        
        self.view.addSubview(pnlButtonArea)
        pnlButtonArea.widthAnchor.constraint(equalToConstant: scrRect.width-7.0).isActive = true
        pnlButtonArea.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 2.0).isActive = true
        pnlButtonArea.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -3).isActive = true
        pnlButtonArea.initHeightConstraints(40,related: nil, second: nil, third: nil, fourth: nil)
        
        pnlButtonArea.addSubview(btnBidding)
        btnBidding.widthAnchor.constraint(equalTo: pnlButtonArea.widthAnchor, multiplier: 1.0).isActive = true
        btnBidding.heightAnchor.constraint(equalToConstant: 40).isActive = true
        btnBidding.centerXAnchor.constraint(equalTo: pnlButtonArea.centerXAnchor, constant: 0.0).isActive = true
        btnBidding.topAnchor.constraint(equalTo: pnlButtonArea.topAnchor, constant: 0.0).isActive = true
        
        pnlButtonArea.addSubview(btnVoid)
        btnVoid.widthAnchor.constraint(equalTo: pnlButtonArea.widthAnchor, multiplier: 1.0).isActive = true
        btnVoid.heightAnchor.constraint(equalToConstant: 40).isActive = true
        btnVoid.centerXAnchor.constraint(equalTo: pnlButtonArea.centerXAnchor, constant: 0.0).isActive = true
        btnVoid.topAnchor.constraint(equalTo: pnlButtonArea.topAnchor, constant: 0.0).isActive = true
        

        self.view.addSubview(pnlOrderArea)
        pnlOrderArea.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
        pnlOrderArea.bottomAnchor.constraint(equalTo: pnlButtonArea.topAnchor, constant: -5.0).isActive = true
        pnlOrderArea.widthAnchor.constraint(equalToConstant: scrRect.width-18.0).isActive = true
        pnlOrderArea.heightAnchor.constraint(equalToConstant: 132).isActive = true
        
        self.pnlOrderArea.addSubview(btnPickupIcon)
        btnPickupIcon.topAnchor.constraint(equalTo: pnlOrderArea.topAnchor, constant: 13.0).isActive = true
        btnPickupIcon.leftAnchor.constraint(equalTo: pnlOrderArea.leftAnchor, constant : 8.0).isActive = true
        btnPickupIcon.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        self.pnlOrderArea.addSubview(lblPickupLocation)
        lblPickupLocation.centerYAnchor.constraint(equalTo: btnPickupIcon.centerYAnchor, constant: 0.0).isActive = true
        lblPickupLocation.leftAnchor.constraint(equalTo: btnPickupIcon.rightAnchor, constant : 5.0).isActive = true
        lblPickupLocation.widthAnchor.constraint(equalTo: pnlOrderArea.widthAnchor, constant : -18.0).isActive = true
        lblPickupLocation.heightAnchor.constraint(equalToConstant: 13).isActive = true
        
        self.pnlOrderArea.addSubview(btnDropIcon)
        btnDropIcon.topAnchor.constraint(equalTo: btnPickupIcon.bottomAnchor, constant: 2.0).isActive = true
        btnDropIcon.leftAnchor.constraint(equalTo: btnPickupIcon.leftAnchor, constant : 0.0).isActive = true
        btnDropIcon.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        self.pnlOrderArea.addSubview(lblDropLocation)
        lblDropLocation.centerYAnchor.constraint(equalTo: btnDropIcon.centerYAnchor, constant: 0.0).isActive = true
        lblDropLocation.leftAnchor.constraint(equalTo: btnDropIcon.rightAnchor, constant : 5.0).isActive = true
        lblDropLocation.widthAnchor.constraint(equalTo: pnlOrderArea.widthAnchor, constant : -18.0).isActive = true
        lblDropLocation.heightAnchor.constraint(equalToConstant: 13).isActive = true
        
        self.pnlOrderArea.addSubview(btnPathStatisticIcon)
        btnPathStatisticIcon.topAnchor.constraint(equalTo: btnDropIcon.bottomAnchor, constant: 2.0).isActive = true
        btnPathStatisticIcon.leftAnchor.constraint(equalTo: btnDropIcon.leftAnchor, constant : 0.0).isActive = true
        btnPathStatisticIcon.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        self.pnlOrderArea.addSubview(lblPathStatistic)
        lblPathStatistic.centerYAnchor.constraint(equalTo: btnPathStatisticIcon.centerYAnchor, constant: 0.0).isActive = true
        lblPathStatistic.leftAnchor.constraint(equalTo: lblPickupLocation.leftAnchor, constant : 0.0).isActive = true
        lblPathStatistic.widthAnchor.constraint(equalTo: pnlOrderArea.widthAnchor, constant : -18.0).isActive = true
        lblPathStatistic.heightAnchor.constraint(equalToConstant: 13).isActive = true
        
        
        self.view.layoutIfNeeded()
        completion?()
    }
    
    
    open func invalidate(_ travelOrder: TravelOrder){
        
        self.navigationController?.navigationBar.isHidden = false
        self.navigationItem.title = travelOrder.OrderPickupPlace != nil ? travelOrder.OrderPickupPlace! : ""
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.white]
        self.navigationController?.navigationBar.titleTextAttributes = titleDict as? [String : AnyObject]

        self.view.bringSubview(toFront: self.pnlOrderArea)

        self.lblPickupLocation.setTitle((travelOrder.OrderPickupLoc != nil ) ?  travelOrder.OrderPickupPlace : "", for: UIControlState())
        self.lblDropLocation.setTitle((travelOrder.OrderDropLoc != nil ) ?  travelOrder.OrderDropPlace : "", for: UIControlState())
        
        self.lblPathStatistic.isHidden = ( travelOrder.OrderDropLoc == nil ) || ( travelOrder.OrderPickupLoc == nil )
        if(self.lblPathStatistic.isHidden){
            self.lblPathStatistic.text = ""
        }

        self.invalidateTravelPath(travelOrder)
        self.invalidateMap(travelOrder)
        
        SCONNECTING.TaxiManager?.getBidding(travelOrder, completion: { (item) in
            
                self.btnBidding.isHidden = (item != nil)
                self.btnVoid.isHidden = (item == nil)
            
        })
    }
    
    
    func  invalidateMap(_ travelOrder: TravelOrder){
        
        var sourceLoc: CLLocationCoordinate2D?
        var destinyLoc: CLLocationCoordinate2D?
        
        if( travelOrder.OrderPickupLoc != nil){
            sourceLoc = travelOrder.OrderPickupLoc!.coordinate()
        }
        
        if( travelOrder.ActPickupLoc != nil){
            sourceLoc = travelOrder.ActPickupLoc!.coordinate()
        }
        
        if( travelOrder.OrderDropLoc != nil){
            destinyLoc = travelOrder.OrderDropLoc!.coordinate()
        }
        
        if( travelOrder.ActDropLoc != nil){
            destinyLoc = travelOrder.ActDropLoc!.coordinate()
        }
        
        self.mSourceMarker.iconView.isHidden = ( sourceLoc == nil )
        if( self.mSourceMarker.iconView.isHidden == false){
            
            self.mSourceMarker.map = self.gmsMapView
            self.mSourceMarker.position = sourceLoc!
            self.mSourceMarker.map?.selectedMarker = self.mSourceMarker
            
        }else{
            
            self.mSourceMarker.map = nil
            
        }
        
        self.mDestinyMarker.iconView.isHidden = ( destinyLoc == nil )
        if( self.mDestinyMarker.iconView.isHidden == false){
            
            self.mDestinyMarker.map = self.gmsMapView
            self.mDestinyMarker.position = destinyLoc!
            self.mDestinyMarker.map?.selectedMarker = self.mDestinyMarker
            
        }else{
            
            self.mDestinyMarker.map = nil
            
        }
        
        
        if( sourceLoc == nil  ||  destinyLoc == nil ){
            
            pathPolyLine?.map = nil
            
            if( sourceLoc != nil){
                
                let camera  = GMSCameraPosition.camera(withLatitude: sourceLoc!.latitude, longitude: sourceLoc!.longitude, zoom: 15)
                self.gmsMapView.animate(with: GMSCameraUpdate.setCamera(camera))
                
            }else  if( destinyLoc != nil){
                
                let camera  = GMSCameraPosition.camera(withLatitude: destinyLoc!.latitude, longitude: destinyLoc!.longitude, zoom: 15)
                self.gmsMapView.animate(with: GMSCameraUpdate.setCamera(camera))
            }
            
        }else{
            
            
            GoogleMapUtil.getDistance(sourceLoc!, destLocation: destinyLoc!) { (routes) in
                if (routes != nil && routes!.count > 0){
                    
                    let overViewPolyLine = routes![0]["overview_polyline"]["points"].string
                    if overViewPolyLine != nil{
                        
                        let path = GMSMutablePath(fromEncodedPath: overViewPolyLine!)
                        
                        if(self.pathPolyLine == nil){
                            self.pathPolyLine = GMSPolyline(path: path)
                            self.pathPolyLine!.strokeWidth = 3
                            self.pathPolyLine!.strokeColor = UIColor(red: 73.0/255.0, green: 139.0/255.0, blue: 199.0/255.0, alpha: 1.0)
                            
                        }else{
                            self.pathPolyLine?.path = path
                        }
                        self.pathPolyLine!.map = self.gmsMapView
                        
                        self.gmsMapView.animate(with: GMSCameraUpdate.fit( GMSCoordinateBounds(path: path!), withPadding: 65.0))
                        
                    }
                }
            }
        }
        
        
    }
    
    
    func invalidateTravelPath(_ travelOrder: TravelOrder){
        
            self.lblPathStatistic.text = ""
            self.lblPathStatistic.isHidden = true
            
            if(travelOrder.OrderDistance > 0 && travelOrder.OrderDuration > 0){
                
                let strDistance = NSString(format:"%.1f Km", travelOrder.OrderDistance/1000 ) as String
                let hours =  Int(travelOrder.OrderDuration / 3600)
                let minutes =  Int(round((travelOrder.OrderDuration.truncatingRemainder(dividingBy: 3600)) / 60))
                var strDuration = ""
                if( hours > 0){
                    strDuration =  NSString(format:"%d giờ %d phút", hours, minutes ) as String
                }else{
                    strDuration =  NSString(format:"%d phút", minutes ) as String
                    
                }
                
                if((travelOrder.OrderPickupCountry) != nil){
                    
                    TravelOrderController.CalculateOrderPrice((SCONNECTING.DriverManager?.CurrentDriver!.id)!, distance: travelOrder.OrderDistance , currency: travelOrder.Currency, serverHandler: { (result) in
                        
                            let strPrice : String? =  (result != nil && result! > 0) ? result!.toCurrency(nil, country: SCONNECTING.DriverManager?.CurrentDriverStatus!.Country!) : ""
                        
                            var strInfo =  strDistance + " - " + strDuration
                            if(strPrice != nil && strPrice != ""){
                                strInfo = strInfo  + " - " + strPrice!
                            }
                            self.lblPathStatistic.text = strInfo
                            self.lblPathStatistic.isHidden = false
                    })
                   
                    
                }
                
            }
        
    }

    open func btnBack_Clicked() {
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    
    @IBAction open func btnBidding_Clicked(_ sender: UIButton) {
        
        
        UIView.animate(withDuration: 0.1 ,
                                   animations: {
                                    sender.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            },
                                   completion: { finish in
                                    UIView.animate(withDuration: 0.1, animations: {
                                        sender.transform = CGAffineTransform.identity
                                    })
                                    UIView.animate(withDuration: 0.25, animations: {
                                        
                                        self.showChooseExpireTime()
                                        
                                        
                                    }) 
                                    
        })
        
    }
    
    
    
    @IBAction open func btnVoid_Clicked(_ sender: UIButton) {
        
        
        UIView.animate(withDuration: 0.1 ,
                                   animations: {
                                    sender.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            },
                                   completion: { finish in
                                    UIView.animate(withDuration: 0.1, animations: {
                                        sender.transform = CGAffineTransform.identity
                                    })
                                    UIView.animate(withDuration: 0.25, animations: {
                                        
                                        SCONNECTING.TaxiManager!.voidBidding(self.CurrentOrder!, completion: { (deleted) in
                                            self.invalidate(self.CurrentOrder!)
                                        })
                                        
                                        
                                    }) 
                                    
        })
        
    }
    

    
}

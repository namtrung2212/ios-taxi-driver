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
import CoreLocation
import RealmSwift
import GoogleMaps



extension TravelMonitoringView {
    
    func initControls(_ completion: (() -> ())?){
        
        self.initOrderPanel{
                self.initUserProfilePanel(completion)
        }
    }
    
    func initLayout(_ completion: (() -> ())?){
        self.initOrderPanelLayout{
            self.initUserProfilePanelLayout(completion)
        }
    }
    
    
    func initOrderPanel(_ completion: (() -> ())?){
        
        let scrRect = UIScreen.main.bounds
        
        let imgSmallOrangeButton = ImageHelper.resize(UIImage(named: "SmallOrangeButton.png")!, newWidth: scrRect.width/2)
        
        let imgOrangeButton = ImageHelper.resize(UIImage(named: "OrangeButton.png")!, newWidth: scrRect.width/2)
        let imgBlueButton = ImageHelper.resize(UIImage(named: "SmallBlueButton.png")!, newWidth: scrRect.width/2)
        
        // Order Panel
        pnlOrderArea = UIView()
        
        pnlOrderArea.backgroundColor = UIColor(red: CGFloat(246/255.0), green: CGFloat(246/255.0), blue: CGFloat(246/255.0), alpha: 1.0)
        pnlOrderArea.layer.cornerRadius = 5.0
        pnlOrderArea.layer.borderColor = UIColor.gray.cgColor
        pnlOrderArea.layer.borderWidth = 0.5
        pnlOrderArea.layer.shadowOffset = CGSize(width: 2, height: 3)
        pnlOrderArea.layer.shadowOpacity = 0.5
        pnlOrderArea.layer.shadowRadius = 3
        
        pnlOrderArea.translatesAutoresizingMaskIntoConstraints = false
        pnlOrderArea.alpha = 0.92
        pnlOrderArea.isHidden = true
        pnlOrderArea.isUserInteractionEnabled = true
        
        btnCollapseOrder   = UIButton(type: UIButtonType.custom) as UIButton
        btnCollapseOrder.frame = CGRect(x: 0, y: 0, width: 0, height: 10)
        btnCollapseOrder.titleLabel!.font = btnCollapseOrder.titleLabel!.font.withSize(25)
        btnCollapseOrder.setGMDIcon(GMDType.gmdExpandMore, forState: UIControlState())
        btnCollapseOrder.setTitleColor(UIColor.gray, for: UIControlState())
        btnCollapseOrder.translatesAutoresizingMaskIntoConstraints = false
        
        // Source Point Left Button
        let imgSource = ImageHelper.resize(UIImage(named: "pickupIcon.png")!, newWidth: 35)
        btnPickupIcon   = UIButton(type: UIButtonType.custom) as UIButton
        btnPickupIcon.frame = CGRect(x: 35, y: 35, width: 35, height: 35)
        btnPickupIcon.setImage(imgSource, for: UIControlState())
        btnPickupIcon.translatesAutoresizingMaskIntoConstraints = false
        
        //  Source TextBox
        let imgSouceTextBox = ImageHelper.resize(UIImage(named: "textbox1.png")!, newWidth: scrRect.width * 1.0)
        imgPickupLocationBG = UIImageView(image: imgSouceTextBox)
        imgPickupLocationBG.translatesAutoresizingMaskIntoConstraints = false
        imgPickupLocationBG.isUserInteractionEnabled = true
        
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
        
        //  Destiny TextBox
        let imgDestinyTextBox = ImageHelper.resize(UIImage(named: "textbox1.png")!, newWidth: scrRect.width * 1.0)
        imgDropLocationBG = UIImageView(image: imgDestinyTextBox)
        imgDropLocationBG.translatesAutoresizingMaskIntoConstraints = false
        imgDropLocationBG.isUserInteractionEnabled = true
        
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
        
        // Path Statistic Label
        lblMoreInfo = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 50))
        lblMoreInfo.font = UIFont(name: "HelveticaNeue-Bold", size: 12)
        lblMoreInfo.textColor = UIColor.darkGray
        lblMoreInfo.textAlignment = NSTextAlignment.center
        lblMoreInfo.text = ""
        lblMoreInfo.translatesAutoresizingMaskIntoConstraints = false
        lblMoreInfo.isHidden = true
        
        
        lblStatus = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 50))
        lblStatus.font = UIFont(name: "HelveticaNeue-Bold", size: 13)
        lblStatus.textColor = UIColor(red: 73.0/255.0, green: 139.0/255.0, blue: 199.0/255.0, alpha: 1.0)
        lblStatus.textAlignment = NSTextAlignment.center
        lblStatus.text = ""
        lblStatus.translatesAutoresizingMaskIntoConstraints = false        
        
        lblCurrentPrice = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 50))
        lblCurrentPrice.font = UIFont(name: "HelveticaNeue-Bold", size: 20)
        lblCurrentPrice.textColor = UIColor.darkGray
        lblCurrentPrice.textAlignment = NSTextAlignment.center
        lblCurrentPrice.text = ""
        lblCurrentPrice.translatesAutoresizingMaskIntoConstraints = false
        lblCurrentPrice.isHidden = true


        // Bottom  Button Area
        pnlButtonArea = UIView()
        pnlButtonArea.translatesAutoresizingMaskIntoConstraints = false
        pnlButtonArea.isUserInteractionEnabled = true
        pnlButtonArea.isHidden = true
        
        
        // Quick Order Button
        btnVoid   = UIButton(type: UIButtonType.custom) as UIButton
        btnVoid.setTitle("HỦY CHUYẾN", for: UIControlState())
        btnVoid.setBackgroundImage(imgOrangeButton, for: UIControlState())
        btnVoid.titleLabel!.font =   btnVoid.titleLabel!.font.withSize(15)
        btnVoid.titleLabel!.textAlignment = NSTextAlignment.center
        btnVoid.contentEdgeInsets = UIEdgeInsetsMake(1,1,1,1)
        btnVoid.titleLabel!.lineBreakMode = .byTruncatingTail
        btnVoid.contentHorizontalAlignment = .center
        btnVoid.contentVerticalAlignment = .center
        btnVoid.contentMode = .scaleToFill
        btnVoid.translatesAutoresizingMaskIntoConstraints = false
        
        
        // Quick Order Button
        btnTripStart   = UIButton(type: UIButtonType.custom) as UIButton
        btnTripStart.setTitle("KHỞI HÀNH", for: UIControlState())
        btnTripStart.setBackgroundImage(imgBlueButton, for: UIControlState())
        btnTripStart.titleLabel!.font =   btnTripStart.titleLabel!.font.withSize(15)
        btnTripStart.titleLabel!.textAlignment = NSTextAlignment.center
        btnTripStart.contentEdgeInsets = UIEdgeInsetsMake(1,1,1,1)
        btnTripStart.titleLabel!.lineBreakMode = .byTruncatingTail
        btnTripStart.contentHorizontalAlignment = .center
        btnTripStart.contentVerticalAlignment = .center
        btnTripStart.contentMode = .scaleToFill
        btnTripStart.translatesAutoresizingMaskIntoConstraints = false

        
        // Custom Order Button
       // let imgBlueButton = ImageHelper.resize(UIImage(named: "SmallBlueButton.png")!, newWidth: scrRect.width/2)
        btnTripFinish   = UIButton(type: UIButtonType.custom) as UIButton
        btnTripFinish.setTitle("TRẢ KHÁCH", for: UIControlState())
        btnTripFinish.setBackgroundImage(imgBlueButton, for: UIControlState())
        btnTripFinish.titleLabel!.font =   btnTripFinish.titleLabel!.font.withSize(15)
        btnTripFinish.titleLabel!.textAlignment = NSTextAlignment.center
        btnTripFinish.contentEdgeInsets = UIEdgeInsetsMake(1,1,1,1)
        btnTripFinish.titleLabel!.lineBreakMode = .byTruncatingTail
        btnTripFinish.contentHorizontalAlignment = .center
        btnTripFinish.contentVerticalAlignment = .center
        btnTripFinish.contentMode = .scaleToFill
        btnTripFinish.translatesAutoresizingMaskIntoConstraints = false
        
        btnCashPayment   = UIButton(type: UIButtonType.custom) as UIButton
        btnCashPayment.setTitle("NHẬN TIỀN MẶT", for: UIControlState())
        btnCashPayment.setBackgroundImage(imgBlueButton, for: UIControlState())
        btnCashPayment.titleLabel!.font =   btnCashPayment.titleLabel!.font.withSize(15)
        btnCashPayment.titleLabel!.textAlignment = NSTextAlignment.center
        btnCashPayment.contentEdgeInsets = UIEdgeInsetsMake(1,1,1,1)
        btnCashPayment.titleLabel!.lineBreakMode = .byTruncatingTail
        btnCashPayment.contentHorizontalAlignment = .center
        btnCashPayment.contentVerticalAlignment = .center
        btnCashPayment.contentMode = .scaleToFill
        btnCashPayment.translatesAutoresizingMaskIntoConstraints = false
        
        
        btnDone   = UIButton(type: UIButtonType.custom) as UIButton
        btnDone.setTitle("HOÀN TẤT", for: UIControlState())
        btnDone.setBackgroundImage(imgBlueButton, for: UIControlState())
        btnDone.titleLabel!.font =   btnDone.titleLabel!.font.withSize(15)
        btnDone.titleLabel!.textAlignment = NSTextAlignment.center
        btnDone.contentEdgeInsets = UIEdgeInsetsMake(1,1,1,1)
        btnDone.titleLabel!.lineBreakMode = .byTruncatingTail
        btnDone.contentHorizontalAlignment = .center
        btnDone.contentVerticalAlignment = .center
        btnDone.contentMode = .scaleToFill
        btnDone.translatesAutoresizingMaskIntoConstraints = false

        
        lblPickupLocation.addTarget(self, action: Selector("btnPickupIcon_Clicked:"), for:.touchUpInside)
        btnCollapseOrder.addTarget(self, action: Selector("btnCollapseOrder_Clicked:"), for:.touchUpInside)
        
        btnPickupIcon.addTarget(self, action: Selector("btnPickupIcon_Clicked:"), for:.touchUpInside)
        btnDropIcon.addTarget(self, action: Selector("btnDropIcon_Clicked:"), for:.touchUpInside)
        lblDropLocation.addTarget(self, action: Selector("btnDropIcon_Clicked:"), for:.touchUpInside)
      
        btnVoid.addTarget(self, action: Selector("btnVoid_Clicked:"), for:.touchUpInside)
        btnTripStart.addTarget(self, action: Selector("btnTripStart_Clicked:"), for:.touchUpInside)
        btnTripFinish.addTarget(self, action: Selector("btnTripFinish_Clicked:"), for:.touchUpInside)
        btnCashPayment.addTarget(self, action: Selector("btnCashPayment_Clicked:"), for:.touchUpInside)
        btnDone.addTarget(self, action: Selector("btnDone_Clicked:"), for:.touchUpInside)
        
        completion?()
    }
    
    func initOrderPanelLayout(_ completion: (() -> ())?){
        
        
        let scrRect = UIScreen.main.bounds
                
        self.parent.view.addSubview(pnlButtonArea)
        pnlButtonArea.widthAnchor.constraint(equalToConstant: scrRect.width-7.0).isActive = true
        pnlButtonArea.centerXAnchor.constraint(equalTo: self.parent.view.centerXAnchor, constant: 2.0).isActive = true
                
        pnlButtonArea.bottomAnchor.constraint(equalTo: self.parent.view.bottomAnchor, constant: -3).isActive = true
        pnlButtonArea.initHeightConstraints(45,related: nil, second: nil, third: nil, fourth: nil)
        
        pnlButtonArea.addSubview(btnVoid)
        btnVoid.topAnchor.constraint(equalTo: pnlButtonArea.topAnchor, constant: 0.0).isActive = true
        btnVoid.heightAnchor.constraint(equalToConstant: 45).isActive = true
        btnVoid.initWidthConstraints(-2, related: pnlButtonArea.widthAnchor, second: -(scrRect.width-3.0)/2 , third: nil, fourth: nil)
        btnVoid.leftAnchor.constraint(equalTo: pnlButtonArea.leftAnchor, constant: 1.0).isActive = true
        
        pnlButtonArea.addSubview(btnTripFinish)
        btnTripFinish.topAnchor.constraint(equalTo: pnlButtonArea.topAnchor, constant: 0.0).isActive = true
        btnTripFinish.heightAnchor.constraint(equalToConstant: 45).isActive = true
        btnTripFinish.widthAnchor.constraint(equalTo: pnlButtonArea.widthAnchor, constant:  -(scrRect.width-3.0)/2 ).isActive = true
        btnTripFinish.rightAnchor.constraint(equalTo: pnlButtonArea.rightAnchor, constant: -3).isActive = true
        
        
        pnlButtonArea.addSubview(btnDone)
        btnDone.topAnchor.constraint(equalTo: pnlButtonArea.topAnchor, constant: 0.0).isActive = true
        btnDone.heightAnchor.constraint(equalToConstant: 45).isActive = true
        btnDone.initWidthConstraints(-(scrRect.width-3.0)/2, related: pnlButtonArea.widthAnchor, second: nil , third: nil, fourth: nil)
        btnDone.leftAnchor.constraint(equalTo: pnlButtonArea.leftAnchor, constant: 1.0).isActive = true
                
        pnlButtonArea.addSubview(btnCashPayment)
        btnCashPayment.topAnchor.constraint(equalTo: pnlButtonArea.topAnchor, constant: 0.0).isActive = true
        btnCashPayment.heightAnchor.constraint(equalToConstant: 45).isActive = true
        btnCashPayment.widthAnchor.constraint(equalTo: pnlButtonArea.widthAnchor, constant:  -(scrRect.width-3.0)/2 ).isActive = true
        btnCashPayment.rightAnchor.constraint(equalTo: pnlButtonArea.rightAnchor, constant: -3).isActive = true
        
        pnlButtonArea.addSubview(btnTripStart)
        btnTripStart.topAnchor.constraint(equalTo: pnlButtonArea.topAnchor, constant: 0.0).isActive = true
        btnTripStart.heightAnchor.constraint(equalToConstant: 45).isActive = true
        btnTripStart.widthAnchor.constraint(equalTo: pnlButtonArea.widthAnchor, constant:  -(scrRect.width-3.0)/2 ).isActive = true
        btnTripStart.rightAnchor.constraint(equalTo: pnlButtonArea.rightAnchor, constant: -3).isActive = true
        
        self.parent.view.addSubview(pnlOrderArea)
        pnlOrderArea.centerXAnchor.constraint(equalTo: self.parent.view.centerXAnchor, constant: 0).isActive = true
        pnlOrderArea.bottomAnchor.constraint(equalTo: pnlButtonArea.topAnchor, constant: -5.0).isActive = true
        pnlOrderArea.widthAnchor.constraint(equalToConstant: scrRect.width-18.0).isActive = true
        pnlOrderArea.initHeightConstraints(155,related: nil, second: 90, third: 180, fourth: nil)
        
        self.pnlOrderArea.addSubview(btnCollapseOrder)
        btnCollapseOrder.topAnchor.constraint(equalTo: pnlOrderArea.topAnchor, constant: 5.0).isActive = true
        btnCollapseOrder.centerXAnchor.constraint(equalTo: pnlOrderArea.centerXAnchor, constant : 0.0).isActive = true
        btnCollapseOrder.heightAnchor.constraint(equalToConstant: 15).isActive = true
        
        self.pnlOrderArea.addSubview(lblStatus)
        lblStatus.topAnchor.constraint(equalTo: btnCollapseOrder.bottomAnchor, constant: 5.0).isActive = true
        lblStatus.centerXAnchor.constraint(equalTo: pnlOrderArea.centerXAnchor, constant : 0.0).isActive = true
        lblStatus.heightAnchor.constraint(equalToConstant: 15).isActive = true
        
        self.pnlOrderArea.addSubview(lblMoreInfo)
        lblMoreInfo.initBottomConstraints(-10.0, related: self.pnlOrderArea.bottomAnchor, second: 0, third: nil, fourth: nil)
        lblMoreInfo.centerXAnchor.constraint(equalTo: pnlOrderArea.centerXAnchor, constant : 0.0).isActive = true
        lblMoreInfo.widthAnchor.constraint(equalTo: pnlOrderArea.widthAnchor, multiplier: 0.95).isActive = true
        lblMoreInfo.initHeightConstraints(15, related: nil, second: 0, third: nil, fourth: nil)
        
        self.pnlOrderArea.addSubview(btnDropIcon)
        btnDropIcon.bottomAnchor.constraint(equalTo: lblMoreInfo.topAnchor, constant: -5.0).isActive = true
        btnDropIcon.leftAnchor.constraint(equalTo: pnlOrderArea.leftAnchor, constant : 8.0).isActive = true
        btnDropIcon.initHeightConstraints(35, related: nil, second: 0, third: nil, fourth: nil)
        
        self.pnlOrderArea.addSubview(imgDropLocationBG)
        imgDropLocationBG.centerYAnchor.constraint(equalTo: btnDropIcon.centerYAnchor, constant: 0.0).isActive = true
        imgDropLocationBG.leftAnchor.constraint(equalTo: btnDropIcon.rightAnchor, constant : 2.0).isActive = true
        imgDropLocationBG.widthAnchor.constraint(equalTo: pnlOrderArea.widthAnchor, constant : -57.0).isActive = true
        imgDropLocationBG.initHeightConstraints(33, related: nil, second: 0, third: nil, fourth: nil)
        
        self.pnlOrderArea.addSubview(lblDropLocation)
        lblDropLocation.centerYAnchor.constraint(equalTo: btnDropIcon.centerYAnchor, constant: 0.0).isActive = true
        lblDropLocation.leftAnchor.constraint(equalTo: imgDropLocationBG.leftAnchor, constant : 5.0).isActive = true
        lblDropLocation.widthAnchor.constraint(equalTo: imgDropLocationBG.widthAnchor, constant : -28.0).isActive = true
        lblDropLocation.initHeightConstraints(13, related: nil, second: 0, third: nil, fourth: nil)
        
        self.pnlOrderArea.addSubview(btnPickupIcon)
        btnPickupIcon.bottomAnchor.constraint(equalTo: btnDropIcon.topAnchor, constant: -7.0).isActive = true
        btnPickupIcon.leftAnchor.constraint(equalTo: btnDropIcon.leftAnchor, constant : 0.0).isActive = true
        btnPickupIcon.initHeightConstraints(35, related: nil, second: 0, third: nil, fourth: nil)
        
        self.pnlOrderArea.addSubview(imgPickupLocationBG)
        imgPickupLocationBG.centerYAnchor.constraint(equalTo: btnPickupIcon.centerYAnchor, constant: 0.0).isActive = true
        imgPickupLocationBG.leftAnchor.constraint(equalTo: btnPickupIcon.rightAnchor, constant : 2.0).isActive = true
        imgPickupLocationBG.widthAnchor.constraint(equalTo: imgDropLocationBG.widthAnchor, constant : 0.0).isActive = true
        imgPickupLocationBG.initHeightConstraints(33, related: nil, second: 0, third: nil, fourth: nil)
        
        self.pnlOrderArea.addSubview(lblPickupLocation)
        lblPickupLocation.centerYAnchor.constraint(equalTo: btnPickupIcon.centerYAnchor, constant: 0.0).isActive = true
        lblPickupLocation.leftAnchor.constraint(equalTo: imgPickupLocationBG.leftAnchor, constant : 5.0).isActive = true
        lblPickupLocation.widthAnchor.constraint(equalTo: imgPickupLocationBG.widthAnchor, constant : -28.0).isActive = true
        lblPickupLocation.initHeightConstraints(13, related: nil, second: 0, third: nil, fourth: nil)
        
        self.pnlOrderArea.addSubview(lblCurrentPrice)
        lblCurrentPrice.initTopConstraints(4, related: lblStatus.bottomAnchor, second: 10, third: nil, fourth: nil)
        lblCurrentPrice.centerXAnchor.constraint(equalTo: pnlOrderArea.centerXAnchor, constant : 0.0).isActive = true
        lblCurrentPrice.widthAnchor.constraint(equalTo: pnlOrderArea.widthAnchor, multiplier: 0.95).isActive = true
        

        
        self.parent.view.layoutIfNeeded()
        completion?()
    }
    
    
    
    func initUserProfilePanel(_ completion: (() -> ())?){
        
        let scrRect = UIScreen.main.bounds
        
        
        // Profile Panel
        pnlUserProfileArea = UIView()
        
        pnlUserProfileArea.backgroundColor = UIColor(red: CGFloat(246/255.0), green: CGFloat(246/255.0), blue: CGFloat(246/255.0), alpha: 0.9)
        pnlUserProfileArea.layer.cornerRadius = 5.0
        pnlUserProfileArea.layer.borderColor = UIColor.gray.withAlphaComponent(0.9).cgColor
        pnlUserProfileArea.layer.borderWidth = 0.5
        pnlUserProfileArea.layer.shadowOffset = CGSize(width: 2, height: 3)
        pnlUserProfileArea.layer.shadowOpacity = 0.5
        pnlUserProfileArea.layer.shadowRadius = 3
        
        pnlUserProfileArea.translatesAutoresizingMaskIntoConstraints = false
        pnlUserProfileArea.isHidden = true
        pnlUserProfileArea.isUserInteractionEnabled = true
        
        btnCollapseProfile   = UIButton(type: UIButtonType.custom) as UIButton
        btnCollapseProfile.frame = CGRect(x: 0, y: 0, width: 0, height: 10)
        btnCollapseProfile.titleLabel!.font = btnCollapseProfile.titleLabel!.font.withSize(25)
        btnCollapseProfile.setGMDIcon(GMDType.gmdExpandMore, forState: UIControlState())
        btnCollapseProfile.setTitleColor(UIColor.gray, for: UIControlState())
        btnCollapseProfile.translatesAutoresizingMaskIntoConstraints = false
        
        
        let avatar = ImageHelper.resize(UIImage(named: "Avatar.png")!, newWidth: 60)
        
        self.imgAvatar = UIImageView(image: avatar)
        self.imgAvatar.frame = CGRect(x: 0, y: 0, width: 60, height: 60)
        
        self.btnAvatar   = UIButton(type: UIButtonType.custom) as UIButton
        self.btnAvatar.frame = CGRect(x: 0, y: 0, width: 60, height: 60)
        self.btnAvatar.setImage(avatar, for: UIControlState())
        self.btnAvatar.layer.borderWidth = 0.6
        self.btnAvatar.layer.masksToBounds = false
        self.btnAvatar.layer.borderColor = UIColor.gray.cgColor
        self.btnAvatar.layer.cornerRadius = 13
        self.btnAvatar.layer.cornerRadius =  self.btnAvatar.frame.size.height/2
        self.btnAvatar.clipsToBounds = true
        self.btnAvatar.layer.shadowOffset = CGSize(width: 2, height: 3)
        self.btnAvatar.layer.shadowOpacity = 0.5
        self.btnAvatar.layer.shadowRadius = 3
        self.btnAvatar.translatesAutoresizingMaskIntoConstraints = false
        self.btnAvatar.isHidden = true
        
        self.lblUserName = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 50))
        self.lblUserName.font = UIFont(name: "HelveticaNeue-Bold", size: 12)
        self.lblUserName.textColor = UIColor.darkGray
        self.lblUserName.textAlignment = NSTextAlignment.left
        self.lblUserName.translatesAutoresizingMaskIntoConstraints = false
        
        
        
        self.lblLastMessage = UILabel(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        self.lblLastMessage.font = UIFont(name: "HelveticaNeue-Italic", size: 11)
        self.lblLastMessage.textColor = UIColor.darkGray
        self.lblLastMessage.text = ""
        self.lblLastMessage.textAlignment = NSTextAlignment.left
        self.lblLastMessage.translatesAutoresizingMaskIntoConstraints = false
        self.lblLastMessage.isHidden = true
        

        
        let imgredCircle = ImageHelper.resize(UIImage(named: "redcircle.png")!, newWidth: 20.0)
        redCircle = UIImageView(image: imgredCircle)
        redCircle.translatesAutoresizingMaskIntoConstraints = false
        redCircle.isUserInteractionEnabled = false
        redCircle.isHidden = true
        
        
        self.lblMessageNo = UILabel(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        self.lblMessageNo.font = UIFont(name: "HelveticaNeue", size: 10)
        self.lblMessageNo.textColor = UIColor.white
        self.lblMessageNo.text = "12"
        self.lblMessageNo.textAlignment = NSTextAlignment.center
        self.lblMessageNo.translatesAutoresizingMaskIntoConstraints = false
        self.lblMessageNo.isHidden = true

        chattingView = TravelChattingView(parent: self.parent)
        chattingView.initControls(completion)
    }
    
    func initUserProfilePanelLayout(_ completion: (() -> ())?){
        
        let scrRect = UIScreen.main.bounds
        
        self.parent.view.addSubview(pnlUserProfileArea)
        pnlUserProfileArea.widthAnchor.constraint(equalTo: self.parent.view.widthAnchor , constant : -18.0).isActive = true
        pnlUserProfileArea.leftAnchor.constraint(equalTo: self.parent.view.leftAnchor, constant: 8.0).isActive = true
        pnlUserProfileArea.topAnchor.constraint(equalTo: self.parent.view.topAnchor, constant: 70).isActive = true
        pnlUserProfileArea.initHeightConstraints(50,related: nil, second: 400, third: nil, fourth: nil)
        
        pnlUserProfileArea.addSubview(btnCollapseProfile)
        btnCollapseProfile.topAnchor.constraint(equalTo: pnlUserProfileArea.bottomAnchor, constant: -17.0).isActive = true
        btnCollapseProfile.centerXAnchor.constraint(equalTo: pnlUserProfileArea.centerXAnchor, constant : 0.0).isActive = true
        btnCollapseProfile.heightAnchor.constraint(equalToConstant: 15).isActive = true
        
        
        self.parent.view.addSubview(btnAvatar)
        
        btnAvatar.topAnchor.constraint(equalTo: self.parent.view.topAnchor, constant: 66).isActive = true
        btnAvatar.leftAnchor.constraint(equalTo: pnlUserProfileArea.leftAnchor, constant : 5.0).isActive = true
        btnAvatar.widthAnchor.constraint(equalToConstant: 60).isActive = true
        btnAvatar.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        pnlUserProfileArea.addSubview(lblUserName)
        lblUserName.initTopConstraints(16, related: pnlUserProfileArea.topAnchor, second: 6, third: nil, fourth: nil)
        lblUserName.leftAnchor.constraint(equalTo: pnlUserProfileArea.leftAnchor, constant : 75.0).isActive = true
        lblUserName.widthAnchor.constraint(equalTo: pnlUserProfileArea.widthAnchor, constant : -20.0).isActive = true
        lblUserName.heightAnchor.constraint(equalToConstant: 50)
        
        self.parent.view.addSubview(redCircle)
        redCircle.topAnchor.constraint(equalTo: btnAvatar.topAnchor, constant : 0.0).isActive = true
        redCircle.leftAnchor.constraint(equalTo: btnAvatar.rightAnchor, constant : -18.0).isActive = true
        redCircle.widthAnchor.constraint(equalToConstant: 20).isActive = true
        redCircle.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        
        self.parent.view.addSubview(lblMessageNo)
        lblMessageNo.centerXAnchor.constraint(equalTo: redCircle.centerXAnchor, constant : 0.0).isActive = true
        lblMessageNo.centerYAnchor.constraint(equalTo: redCircle.centerYAnchor, constant : 0.0).isActive = true
        lblMessageNo.widthAnchor.constraint(equalToConstant: 50).isActive = true
        lblMessageNo.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        pnlUserProfileArea.addSubview(lblLastMessage)
        lblLastMessage.topAnchor.constraint(equalTo: lblUserName.bottomAnchor, constant : 3.0).isActive = true
        lblLastMessage.leftAnchor.constraint(equalTo: lblUserName.leftAnchor, constant : 0.0).isActive = true
        lblLastMessage.widthAnchor.constraint(equalTo: pnlUserProfileArea.widthAnchor, constant : -80.0).isActive = true
        lblLastMessage.heightAnchor.constraint(equalToConstant: 50)
        

        
        btnAvatar.addTarget(self, action: Selector("btnAvatar_Clicked:"), for:.touchUpInside)
        btnCollapseProfile.addTarget(self, action: Selector("btnCollapseProfile_Clicked:"), for:.touchUpInside)
        
        
        chattingView.initLayout{
            self.parent.view.layoutIfNeeded()
            completion?()
        }
    }
    
}

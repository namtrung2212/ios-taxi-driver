//
//  File.swift
//  User.iPhone
//
//  Created by Trung Dao on 5/13/16.
//  Copyright © 2016 SCONNECTING. All rights reserved.
//

import Foundation
//
//  HomeViewController.swift
//  User.iPhone
//
//  Created by Trung Dao on 4/13/16.
//  Copyright © 2016 SCONNECTING. All rights reserved.
//
import UIKit
import Foundation
import ObjectMapper
import AlamofireObjectMapper
import AlamofireImage
import SClientData
import SClientModel
import SClientUI
import SClientModelControllers

import CoreLocation
import RealmSwift
import GoogleMaps

extension LeftMenuViewController {
    
    func initControls(_ completion: (() -> ())?){
        
        let scrRect = UIScreen.main.bounds
        
        self.view.backgroundColor =  UIColor(red: 73.0/255.0, green: 139.0/255.0, blue: 199.0/255.0, alpha: 0.9)
        
        self.navigationController?.isNavigationBarHidden = true
        
        
        scrollView = UIScrollView()
        scrollView.backgroundColor = UIColor.clear
        scrollView.delegate = self
        scrollView.frame = CGRect(x: 0, y: 0, width: SlideMenuOptions.leftViewWidth, height: self.view.bounds.height)
        scrollView.autoresizingMask = UIViewAutoresizing.flexibleHeight
        scrollView.contentSize = CGSize(width: SlideMenuOptions.leftViewWidth, height: 2000)
        
        let avatar = ImageHelper.resize(UIImage(named: "Avatar.png")!, newWidth: 100)
        
        self.imgAvatar = UIImageView(image: avatar)
        self.imgAvatar.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        
        self.btnAvatar   = UIButton(type: UIButtonType.custom) as UIButton
        self.btnAvatar.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
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
        
        let url = SCONNECTING.DriverManager!.CurrentDriver != nil ? SClientData.ServerURL + "/avatar/driver/\(SCONNECTING.DriverManager!.CurrentDriver!.id! )" : ""
        self.imgAvatar.af_setImageWithURL(
            URL(string: url)!,
            placeholderImage: ImageHelper.resize(UIImage(named: "Avatar.png")!, newWidth: 100),
            filter: AspectScaledToFillSizeWithRoundedCornersFilter(size: self.btnAvatar.frame.size, radius: 24),
            imageTransition: .crossDissolve(0.2)
        )
        self.btnAvatar.setImage(self.imgAvatar.image, for: UIControlState())
        btnAvatar.addTarget(self, action: Selector("btnAvatar_Clicked:"), for:.touchUpInside)
        
        self.lblUserName = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 50))
        self.lblUserName.font = UIFont(name: "HelveticaNeue-Bold", size: 14)
        self.lblUserName.textColor = UIColor.white
        self.lblUserName.textAlignment = NSTextAlignment.center
        self.lblUserName.translatesAutoresizingMaskIntoConstraints = false
        
        self.lblCarNo = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 50))
        self.lblCarNo.font = UIFont(name: "HelveticaNeue", size: 14)
        self.lblCarNo.textColor = UIColor.white
        self.lblCarNo.textAlignment = NSTextAlignment.center
        self.lblCarNo.translatesAutoresizingMaskIntoConstraints = false

        self.mainMenu = MainMenu(parent: self)
        self.mainMenu.initControls()
        
        
        completion?()
    }
    
    func initLayout(_ completion: (() -> ())?){
        
        self.view.addSubview(scrollView)
        
        self.scrollView.addSubview(btnAvatar)
        btnAvatar.topAnchor.constraint(equalTo: self.scrollView.topAnchor, constant: 20).isActive = true
        btnAvatar.centerXAnchor.constraint(equalTo: self.scrollView.centerXAnchor, constant : 0.0).isActive = true
        btnAvatar.widthAnchor.constraint(equalToConstant: 100).isActive = true
        btnAvatar.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        self.scrollView.addSubview(lblUserName)
        lblUserName.topAnchor.constraint(equalTo: btnAvatar.bottomAnchor, constant : 5.0).isActive = true
        lblUserName.centerXAnchor.constraint(equalTo: btnAvatar.centerXAnchor, constant : 0.0).isActive = true
        lblUserName.widthAnchor.constraint(equalTo: self.scrollView.widthAnchor, constant : 0.0).isActive = true
        lblUserName.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        self.scrollView.addSubview(lblCarNo)
        lblCarNo.topAnchor.constraint(equalTo: lblUserName.bottomAnchor, constant : 5.0).isActive = true
        lblCarNo.centerXAnchor.constraint(equalTo: btnAvatar.centerXAnchor, constant : 0.0).isActive = true
        lblCarNo.widthAnchor.constraint(equalTo: self.scrollView.widthAnchor, constant : 0.0).isActive = true
        lblCarNo.heightAnchor.constraint(equalToConstant: 20).isActive = true
        

        self.mainMenu.initLayout()
        
        self.view.layoutIfNeeded()
        completion?()
    }
    
    public func getPreferedTableHeight() -> CGFloat{
        self.mainMenu.tableView.sizeToFit()
        return self.mainMenu.getPreferedTableHeight()
        
    }
    
    public func resetScrollSize(){
        
        _ = UIScreen.main.bounds
        scrollView.contentSize = CGSize(width: SlideMenuOptions.leftViewWidth, height: self.getPreferedTableHeight() + 350)
        
        self.view.layoutIfNeeded()
        
    }
}

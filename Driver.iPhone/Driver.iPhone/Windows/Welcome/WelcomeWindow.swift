//
//  ActivationWindow.swift
//  User.iPhone
//
//  Created by Trung Dao on 6/15/16.
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

import UIKit

open class WelcomeWindow: UIWindow{
    
    open var welcomScreen : WelcomeScreen?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.bounds = UIScreen.main.bounds
        self.backgroundColor = UIColor.white
        
        welcomScreen =  WelcomeScreen(nibName: nil, bundle: nil)
        
        self.rootViewController = welcomScreen
    }
    
    required public init?(coder aDecoder: NSCoder) {
        self.init()
    }
}


open class WelcomeScreen: UIViewController,UITextFieldDelegate{
    
    var BGImage: UIImageView!
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        
        let scrRect = UIScreen.main.bounds

        BGImage = UIImageView(image: ImageHelper.resize(UIImage(named: "lauchingImage1242x2208.png")!, newWidth: scrRect.width))
        BGImage.frame = CGRect(x: 0, y: 0, width: scrRect.width, height: scrRect.height)
        BGImage.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(BGImage)
        BGImage.widthAnchor.constraint(equalToConstant: scrRect.width).isActive = true
        BGImage.heightAnchor.constraint(equalToConstant: scrRect.height).isActive = true
        BGImage.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0.0).isActive = true
        BGImage.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 0.0).isActive = true
    }

}

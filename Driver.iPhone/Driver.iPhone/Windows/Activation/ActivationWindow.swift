//
//  ActivationWindow.swift
//  User.iPhone
//
//  Created by Trung Dao on 6/15/16.
//  Copyright © 2016 SCONNECTING. All rights reserved.
//

import Foundation

import UIKit

open class ActivationWindow: UIWindow{
    
    open var activationScreen : ActivationScreen?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.bounds = UIScreen.main.bounds
        self.backgroundColor = UIColor.white
        
        activationScreen =  ActivationScreen(nibName: nil, bundle: nil)
        
        self.rootViewController = activationScreen
    }
    
    required public init?(coder aDecoder: NSCoder) {
        self.init()
    }
}

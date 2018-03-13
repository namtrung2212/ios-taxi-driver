//
//  LeftMenu.Menu.ItemObject.swift
//  User.iPhone
//
//  Created by Trung Dao on 7/13/16.
//  Copyright © 2016 SCONNECTING. All rights reserved.
//

import Foundation

open class MenuItemObject{

    open var Index: Int
    open var Section: Int
    open var Caption: String
    open var Desc : String?
    open var leftIcon: String?
    open var rightIcon: String?
    
    open var height : Double = 25
    
    init( caption: String, section: Int, index: Int){
        
        self.Caption = caption
        self.Section = section
        self.Index = index
    }
    
    init( caption: String, section: Int, index: Int, leffImage: String){
        
        self.Caption = caption
        self.Section = section
        self.Index = index
        self.leftIcon = leffImage
    }
}

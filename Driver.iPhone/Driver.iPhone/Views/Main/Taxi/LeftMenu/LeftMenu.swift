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
import DTTableViewManager
import DTModelStorage
import AlamofireImage


open class LeftMenuViewController: UIViewController ,UIScrollViewDelegate,SlideMenuControllerDelegate{
    
    var scrollView: UIScrollView!
    

    var imgAvatar: UIImageView!
    var btnAvatar: UIButton!
    var lblUserName: UILabel!
    var lblCarNo: UILabel!

    var mainMenu: MainMenu!
    var btnTravel :UIButton!
    var btnTripMate :UIButton!
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        self.initControls{
            self.initLayout{
                
            }
        }
        
        
    }
    
        
    func invalidate(_ completion: (() -> ())?){
        
        let url = SCONNECTING.DriverManager!.CurrentDriver != nil ? SClientData.ServerURL + "/avatar/driver/\(SCONNECTING.DriverManager!.CurrentDriver!.id! )" : ""
        self.imgAvatar.af_setImageWithURL(
            URL(string: url)!,
            placeholderImage: ImageHelper.resize(UIImage(named: "Avatar.png")!, newWidth: 100),
            filter: AspectScaledToFillSizeWithRoundedCornersFilter(size: self.btnAvatar.frame.size, radius: 24),
            imageTransition: .crossDissolve(0.2)
        )
        
        self.btnAvatar.setImage(self.imgAvatar.image, for: UIControlState())
        self.lblUserName.text = SCONNECTING.DriverManager!.CurrentDriver!.Name!.uppercased()
        self.lblCarNo.text = SCONNECTING.DriverManager!.CurrentDriverStatus!.CarNo!.uppercased()
        self.mainMenu.invalidate{
            
        }
        
    }
}

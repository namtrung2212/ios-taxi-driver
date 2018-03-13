
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
import DTTableViewManager
import DTModelStorage
import SClientModelControllers
import AlamofireImage

import RealmSwift

open class TravelChattingObject{
    
    open var order: TravelOrder?
    open var cellObject: TravelOrderChatting?
    open var preferHeight: CGFloat
    open var preferWidth: CGFloat
    
    init(order: TravelOrder? ,item: TravelOrderChatting? ){
        
        self.cellObject = item
        self.order = order
        
        preferHeight = UILabel.appearance().font.withSize(12).sizeOfJustifiedString(item!.Content!, constrainedToWidth: TravelChattingCell.ContentLabelWidth).height
        preferWidth = UILabel.appearance().font.withSize(12).sizeOfJustifiedString(item!.Content!, constrainedToWidth: TravelChattingCell.ContentLabelWidth).width
        
        preferHeight = UILabel.appearance().font.withSize(12).sizeOfJustifiedString(item!.Content!, constrainedToWidth: preferWidth).height + 4
        preferWidth = UILabel.appearance().font.withSize(12).sizeOfJustifiedString(item!.Content!, constrainedToWidth: preferWidth).width + 6
        /*
        if(preferHeight < 26){
            preferHeight = 26
        }
 */
        
    }
    
    open static func fromArray(_ order: TravelOrder? ,arrItems: [TravelOrderChatting]?,completion: ((_ objects: [TravelChattingObject]?) -> ())?) {
        
        var arrObjects : [TravelChattingObject] = []
        var iCount: Int = 0
        
        arrItems?.forEach({ (item) in
            
            let obj = TravelChattingObject(order: order,item: item)
            
            arrObjects.append(obj)
            
            iCount += 1
            if( iCount == arrItems!.count  ){
                completion?(objects:arrObjects)
            }
            
        })
        
    }
    
    
}

open class TravelChattingCell: UITableViewCell, ModelTransfer {
    
    
    open static var CellHeight: CGFloat = 70
    
    open static var AvatarAreaWidth: CGFloat = 40
    open static var ContentLabelWidth: CGFloat = UIScreen.main.bounds.size.width - 80 - AvatarAreaWidth
    
    open var imgAvatar: UIImageView!
    open var lblContent: UILabel!
    
    var contentWidth: NSLayoutConstraint!
    var contentAreaLeft: NSLayoutConstraint!
    var contentAreaRight: NSLayoutConstraint!
    var avatarLeft: NSLayoutConstraint!
    var avatarRight: NSLayoutConstraint!
    
    open var imgNotation: UIImageView!
    var pnlContentArea: UIView!
    
    
    public override init(style: UITableViewCellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = UITableViewCellSelectionStyle.none
        self.backgroundView =  UIView()
        self.backgroundColor = UIColor.clear
        
        imgAvatar = UIImageView(image: ImageHelper.resize(UIImage(named: "Avatar.png")!, newWidth: TravelChattingCell.AvatarAreaWidth - 20))
        imgAvatar.frame = CGRect(x: 0, y: 0, width: TravelChattingCell.AvatarAreaWidth - 20, height: TravelChattingCell.AvatarAreaWidth - 20)
        imgAvatar.layer.borderWidth=1.0
        imgAvatar.layer.masksToBounds = false
        imgAvatar.layer.borderColor = UIColor.gray.cgColor
        imgAvatar.layer.cornerRadius = 13
        imgAvatar.layer.cornerRadius =  self.imgAvatar.frame.size.height/2
        imgAvatar.clipsToBounds = true
        imgAvatar.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(imgAvatar)
        imgAvatar.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant : 5.0).isActive = true
        avatarLeft = imgAvatar.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant : 2.0)
        avatarLeft.isActive = true
        avatarRight = imgAvatar.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant : -2.0)
        avatarRight.isActive = false
        
        pnlContentArea = UIView()
        pnlContentArea.backgroundColor = UIColor(red: CGFloat(247/255.0), green: CGFloat(247/255.0), blue: CGFloat(247/255.0), alpha: 1.0)
        pnlContentArea.layer.cornerRadius = 10.0
        pnlContentArea.layer.borderColor = UIColor(red: CGFloat(247/255.0), green: CGFloat(247/255.0), blue: CGFloat(247/255.0), alpha: 1.0).cgColor
        pnlContentArea.layer.borderWidth = 0.5
        pnlContentArea.layer.shadowOffset = CGSize(width: 1, height: 1)
        pnlContentArea.layer.shadowOpacity = 0.3
        pnlContentArea.layer.shadowRadius = 2
        pnlContentArea.translatesAutoresizingMaskIntoConstraints = false
        pnlContentArea.isUserInteractionEnabled = true
        
        self.contentView.addSubview(pnlContentArea)
        pnlContentArea.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant : 5.0).isActive = true
        pnlContentArea.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant : -5.0).isActive = true
        contentAreaLeft =  pnlContentArea.leftAnchor.constraint(equalTo: imgAvatar.rightAnchor, constant : 5.0)
        contentAreaLeft.isActive = true
        contentAreaRight =  pnlContentArea.rightAnchor.constraint(equalTo: imgAvatar.leftAnchor, constant : -5.0)
        contentAreaRight.isActive = false
        
        lblContent = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 50))
        lblContent.font = UILabel.appearance().font.withSize(12)
        lblContent.textColor = UIColor.black
        lblContent.textAlignment = NSTextAlignment.justified
        lblContent.lineBreakMode = .byWordWrapping
        lblContent.numberOfLines = 0
        lblContent.translatesAutoresizingMaskIntoConstraints = false
        
        pnlContentArea.addSubview(lblContent)
        lblContent.topAnchor.constraint(equalTo: pnlContentArea.topAnchor, constant : 2.0).isActive = true
        lblContent.bottomAnchor.constraint(equalTo: pnlContentArea.bottomAnchor, constant : -2.0).isActive = true
        lblContent.centerXAnchor.constraint(equalTo: pnlContentArea.centerXAnchor, constant : 0.0).isActive = true
        contentWidth =  lblContent.widthAnchor.constraint(equalToConstant: TravelChattingCell.ContentLabelWidth)
        contentWidth.isActive = true
        
        pnlContentArea.widthAnchor.constraint(equalTo: lblContent.widthAnchor, constant: 8.0).isActive = true

    }
    
    open  func updateWithModel(_ obj: TravelChattingObject) {
        
        self.lblContent.text = obj.cellObject!.Content
        contentWidth.constant = obj.preferWidth 
        if(obj.preferHeight < 60){
            self.pnlContentArea.layer.cornerRadius = 6.0
        }
        self.pnlContentArea.layoutIfNeeded()
        
        let url = SClientData.ServerURL + (obj.cellObject!.IsUser ? "/avatar/user/\(obj.cellObject!.User!)" : "/avatar/driver/\(obj.cellObject!.Driver!)" )
        
        self.imgAvatar.af_setImageWithURL(
            URL(string: url)!,
            placeholderImage:  ImageHelper.resize(UIImage(named: "Avatar.png")!, newWidth: TravelChattingCell.AvatarAreaWidth - 20),
            filter: AspectScaledToFillSizeWithRoundedCornersFilter(size: self.imgAvatar.frame.size, radius: 20.0),
            imageTransition: .crossDissolve(0.2)
        )
        
        if(obj.cellObject!.IsUser == false){
            self.contentAreaLeft.isActive = false
            self.contentAreaRight.isActive = true
            self.avatarLeft.isActive = false
            self.avatarRight.isActive = true
            self.pnlContentArea.backgroundColor = UIColor(red: CGFloat(125/255.0), green: CGFloat(187/255.0), blue: CGFloat(233/255.0), alpha: 1.0)
            self.pnlContentArea.layer.borderColor = UIColor(red: CGFloat(125/255.0), green: CGFloat(187/255.0), blue: CGFloat(233/255.0), alpha: 1.0).cgColor
            
            self.layoutIfNeeded()
        }else{
            self.contentAreaRight.isActive = false
            self.contentAreaLeft.isActive = true
            self.avatarRight.isActive = false
            self.avatarLeft.isActive = true
            self.pnlContentArea.backgroundColor = UIColor(red: CGFloat(247/255.0), green: CGFloat(247/255.0), blue: CGFloat(247/255.0), alpha: 1.0)
            self.pnlContentArea.layer.borderColor = UIColor(red: CGFloat(247/255.0), green: CGFloat(247/255.0), blue: CGFloat(247/255.0), alpha: 1.0).cgColor
            
            self.layoutIfNeeded()

        }
    }
    func hideAvatar(_ hide: Bool){
        self.imgAvatar.isHidden = hide
    }

    public required init?(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
        
    }
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        
    }


}


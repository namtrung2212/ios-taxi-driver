//
//  FontUtil.swift
//  User.iPhone
//
//  Created by Trung Dao on 6/2/16.
//  Copyright © 2016 SCONNECTING. All rights reserved.
//

import Foundation

extension UIFont {
    func sizeOfString (_ string: String, constrainedToWidth width: CGFloat) -> CGSize {
        return NSString(string: string).boundingRect(with: CGSize(width: Double(width), height: DBL_MAX),
                                                             options: NSStringDrawingOptions.usesLineFragmentOrigin,
                                                             attributes: [NSFontAttributeName: self],
                                                             context: nil).size
    }
    
    func sizeOfJustifiedString (_ string: String, constrainedToWidth width: CGFloat) -> CGSize {
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = NSTextAlignment.justified
        
        
        return NSString(string: string).boundingRect(with: CGSize(width: Double(width), height: DBL_MAX),
                                                             options: NSStringDrawingOptions.usesLineFragmentOrigin,
                                                             attributes: [NSFontAttributeName: self,NSParagraphStyleAttributeName: paragraphStyle],
                                                             context: nil).size
    }
    
}

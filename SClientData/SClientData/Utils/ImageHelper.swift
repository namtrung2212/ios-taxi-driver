//
//  File.swift
//  SClientData
//
//  Created by Trung Dao on 5/3/16.
//  Copyright © 2016 SCONNECTING. All rights reserved.
//

import Foundation



open class ImageHelper {
    
    open static func resize(_ image: UIImage, newWidth: CGFloat?) -> UIImage {
        
        var newWidth2 = image.size.width
        if(newWidth != nil){
            newWidth2 = newWidth!
        }
        
        var newHeight2 = CGFloat((newWidth2 / image.size.width) * image.size.height)
        
        return image.af_imageAspectScaledToFitSize(CGSize(width: newWidth2,height: newHeight2))
        
    }

    open static func effectBlur(_ image : UIImage) -> UIImage{
        
        let imageToBlur = CIImage(image: image)
        let blurfilter = CIFilter(name: "CIGaussianBlur")
        blurfilter!.setValue(imageToBlur, forKey: "inputImage")
        let resultImage = blurfilter!.value(forKey: "outputImage") as! CIImage
        
        return UIImage(ciImage: resultImage)
    }
}

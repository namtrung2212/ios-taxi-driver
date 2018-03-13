//
//  ImageUploader.swift
//  SClientUI
//
//  Created by Trung Dao on 4/11/16.
//  Copyright © 2016 SCONNECTING. All rights reserved.
//

import UIKit
import DKImagePickerController
import Alamofire
import SClientData

open class ImagePicker: NSObject {
    
    open static func ChooseImages(_ rootViewCtrl: UIViewController, maxSelect: Int,size: CGSize?,completion: @escaping (_ images: [UIImage]) -> ()){
       
        var results : [UIImage] = []
        let pickerController = DKImagePickerController
        //pickerController.singleSelect = true
        pickerController.maxSelectableCount = maxSelect
        pickerController.sourceType = DKImagePickerControllerSourceType.Photo
        pickerController.showsCancelButton = true
        
        pickerController.didSelectAssets = { (assets: [DKAsset]) in
            
            assets.forEach({ (item) in
                item.fetchImageWithSize(size != nil ? size! : CGSize(width:600.0, height:600.0), completeBlock: {
                    (image: UIImage?, info: [AnyHashable: Any]?) -> Void in
                    
                    if (image != nil){
                            results.append(image!)
                    }
                    
                    if(results.count >= assets.count){
                        completion( images: results)
                    }
                })
            })
          
        }
        
        rootViewCtrl.present(pickerController, animated: true) {}
        
    }
    
    open static func ChooseImage(_ rootViewCtrl: UIViewController, size: CGSize?,completion: @escaping (_ image: UIImage?) -> ()){
        
        var result : UIImage?
        
        let pickerController = DKImagePickerController
        pickerController.singleSelect = true
        pickerController.sourceType = DKImagePickerControllerSourceType.Photo
        pickerController.showsCancelButton = true
        pickerController.didCancel = {
            
            completion( image: nil)
        }
        pickerController.didSelectAssets = { (assets: [DKAsset]) in
            
            assets.forEach({ (item) in
                item.fetchImageWithSize(size != nil ? size! : CGSize(width:600.0, height:600.0), completeBlock: {
                    (image: UIImage?, info: [AnyHashable: Any]?) -> Void in
                    
                    if (image != nil){
                        result = image!
                    }
                    completion( image: result)
                    
                })
            })
            
        }
        
        rootViewCtrl.present(pickerController, animated: true) {}
        
    }
}

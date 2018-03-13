//
//  ImageManager.swift
//  SClientData
//
//  Created by Trung Dao on 4/12/16.
//  Copyright © 2016 SCONNECTING. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

public struct UploadPackage {
    
    public var URL : String
    public var Images : [UIImage] = []
    
    public var Params : [String : String] = [:]
    
    public  init(url : String, images: [UIImage], params: [String : String]?) {
        URL = url
        images.forEach { (image) in
            Images.append(image)
        }
        
        
        for (param, value) in params! {
            Params[param] = value
        }
        
    }
    
    public subscript (param: String) -> String?{
        get {
            return Params[param]!
        }
        set(newValue) {
            Params[param] = newValue
        }
    }
}


open class ImageManager: NSObject {

    
    static let downloader = ImageDownloader()
    
    open static func Download(_ URLAddress : String , completion : @escaping (_ image: UIImage?)->()){
        
        let URLRequest = Foundation.URLRequest(url: URL(string: URLAddress)!)
        
        downloader.downloadImage(URLRequest: URLRequest) { response in
            
            completion(image: response.result.value)
            
        }
    }
    
    open static func Upload(_ package: UploadPackage, progress: @escaping (_ percentage: Double?) -> (), completion: @escaping (_ result: String?) -> ()){
        DispatchQueue(label: "Image_Upload", attributes: []).async {
            
            Alamofire.upload(.POST,package.URL, multipartFormData: { multipartFormData in
                
                package.Images.forEach({ (image) in
                    let imageData = UIImagePNGRepresentation(image)
                    
                    if(imageData != nil)  {
                        multipartFormData.appendBodyPart(data: imageData!, name: "photo", fileName: UUID().uuidString + ".png" , mimeType: "image/png" )
                    }
                })
                
                for (param, value) in  package.Params {
                    multipartFormData.appendBodyPart(data: "\(value)".data(using: String.Encoding.utf8, allowLossyConversion: false)!, name : "\(param)")
                }
                },
                             encodingCompletion: { encodingResult in
                                
                                switch encodingResult {
                                    
                                case .success(let upload, _, _):
                                    upload.responseString { response in
                                        completion(result: response.result.value)
                                    }
                                    upload.progress { _, totalBytesRead, totalBytesExpectedToRead in
                                        let percentage = Double(totalBytesRead)/Double(totalBytesExpectedToRead)
                                        DispatchQueue.main.async {
                                            progress(percentage : percentage)
                                        }
                                    }
                                case .failure(let encodingError):
                                    print(encodingError)
                                }
                }
            )
        }
        
    }
    
    
    

    
}

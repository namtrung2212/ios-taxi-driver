//
//  CryptoHelper.swift
//  SClientData
//
//  Created by Trung Dao on 8/20/16.
//  Copyright © 2016 SCONNECTING. All rights reserved.
//

import JWT

open class CryptoHelper{
    
    static var instance : CryptoHelper = CryptoHelper()
    
    public init(){
        
    }
    open static  var HashSecretKey: String{
        get {
            return "LoveOfMyLife"
        }
    }
    
    
    open static  var HashIssuer: String{
        get {
            return "namtrung2212@gmail.com"
        }
    }

    
    open static func generateHashKey (_ valueToHash : String)->String {
       
       return JWT.encode(.hs256(HashSecretKey)) { builder in
            builder.issuer = HashIssuer
            builder.issuedAt = Date()
            builder.expiration =  Date().addingTimeInterval(60)
            builder["hashedvalue"] = valueToHash
        }
        
    }
    
    
}
